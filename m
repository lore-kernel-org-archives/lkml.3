Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaHIFp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 01:45:57 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55682 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaHIFpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 01:45:54 -0400
Subject: [PATCH v3 2/2] powerpc/powernv: Interface to register/unregister
 opal dump region
To: linuxppc-dev@lists.ozlabs.org
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Sat, 09 Aug 2014 11:15:45 +0530
Message-ID: <20140809054540.17676.34572.stgit@hegdevasant.in.ibm.com>
In-Reply-To: <20140809054424.17676.1090.stgit@hegdevasant.in.ibm.com>
References: <20140809054424.17676.1090.stgit@hegdevasant.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080905-1618-0000-0000-000000B6BDFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PowerNV platform is capable of capturing host memory region when system
crashes (because of host/firmware). We have new OPAL API to register/
unregister memory region to be captured when system crashes.

This patch adds support for new API. Also during boot time we register
kernel log buffer and unregister before doing kexec.

Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/opal.h                |   11 +++++++++++
 arch/powerpc/platforms/powernv/opal-wrappers.S |    2 ++
 arch/powerpc/platforms/powernv/opal.c          |   23 +++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
index b2f8ce1..86055e5 100644
--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -149,6 +149,8 @@ struct opal_sg_list {
 #define OPAL_DUMP_INFO2				94
 #define OPAL_PCI_EEH_FREEZE_SET			97
 #define OPAL_HANDLE_HMI				98
+#define OPAL_REGISTER_DUMP_REGION		101
+#define OPAL_UNREGISTER_DUMP_REGION		102
 
 #ifndef __ASSEMBLY__
 
@@ -920,6 +922,8 @@ int64_t opal_set_param(uint64_t token, uint32_t param_id, uint64_t buffer,
 		uint64_t length);
 int64_t opal_sensor_read(uint32_t sensor_hndl, int token, __be32 *sensor_data);
 int64_t opal_handle_hmi(void);
+int64_t opal_register_dump_region(uint32_t id, uint64_t start, uint64_t end);
+int64_t opal_unregister_dump_region(uint32_t id);
 
 /* Internal functions */
 extern int early_init_dt_scan_opal(unsigned long node, const char *uname,
@@ -974,6 +978,13 @@ struct opal_sg_list *opal_vmalloc_to_sg_list(void *vmalloc_addr,
 					     unsigned long vmalloc_size);
 void opal_free_sg_list(struct opal_sg_list *sg);
 
+/*
+ * Dump region ID range usable by the OS
+ */
+#define OPAL_DUMP_REGION_HOST_START		0x80
+#define OPAL_DUMP_REGION_LOG_BUF		0x80
+#define OPAL_DUMP_REGION_HOST_END		0xFF
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __OPAL_H */
diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
index a328be4..2e6ce1b 100644
--- a/arch/powerpc/platforms/powernv/opal-wrappers.S
+++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
@@ -245,3 +245,5 @@ OPAL_CALL(opal_sensor_read,			OPAL_SENSOR_READ);
 OPAL_CALL(opal_get_param,			OPAL_GET_PARAM);
 OPAL_CALL(opal_set_param,			OPAL_SET_PARAM);
 OPAL_CALL(opal_handle_hmi,			OPAL_HANDLE_HMI);
+OPAL_CALL(opal_register_dump_region,		OPAL_REGISTER_DUMP_REGION);
+OPAL_CALL(opal_unregister_dump_region,		OPAL_UNREGISTER_DUMP_REGION);
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index f0a01a4..b44eec3 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -605,6 +605,24 @@ static int opal_sysfs_init(void)
 	return 0;
 }
 
+static void __init opal_dump_region_init(void)
+{
+	void *addr;
+	uint64_t size;
+	int rc;
+
+	/* Register kernel log buffer */
+	addr = log_buf_addr_get();
+	size = log_buf_len_get();
+	rc = opal_register_dump_region(OPAL_DUMP_REGION_LOG_BUF,
+				       __pa(addr), size);
+	/* Don't warn if this is just an older OPAL that doesn't
+	 * know about that call
+	 */
+	if (rc && rc != OPAL_UNSUPPORTED)
+		pr_warn("DUMP: Failed to register kernel log buffer. "
+			"rc = %d\n", rc);
+}
 static int __init opal_init(void)
 {
 	struct device_node *np, *consoles;
@@ -654,6 +672,8 @@ static int __init opal_init(void)
 	/* Create "opal" kobject under /sys/firmware */
 	rc = opal_sysfs_init();
 	if (rc == 0) {
+		/* Setup dump region interface */
+		opal_dump_region_init();
 		/* Setup error log interface */
 		rc = opal_elog_init();
 		/* Setup code update interface */
@@ -694,6 +714,9 @@ void opal_shutdown(void)
 		else
 			mdelay(10);
 	}
+
+	/* Unregister memory dump region */
+	opal_unregister_dump_region(OPAL_DUMP_REGION_LOG_BUF);
 }
 
 /* Export this so that test modules can use it */

