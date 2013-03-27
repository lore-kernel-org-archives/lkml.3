Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3C0Xvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:51:44 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:14622
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012Ab3C0Xvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:51:43 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKCFM0-02-4A7-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/3] iommu/amd: Add IOMMU event log injection interface for testing event flag decoding logic
Date: Wed, 27 Mar 2013 18:51:34 -0500
Message-ID: <1364428294-2579-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Add IOMMU event log injection interface for testing event flag decoding logic.
This interface allows users to specify device id, event flag, and event types via debugfs.

echo 0x300 > /sys/kernel/debug/amd-iommu-evninj/devid // (e.g. Bus:Dev.fun 3:0.0)
echo 0xfff > /sys/kernel/debug/amd-iommu-evninj/flags // (e.g. Specify flag value)
echo 2 > /sys/kernel/debug/amd-iommu-evninj/type      // (e.g. for IO_PAGE_FAULT event)

Once the event is injected, IOMMU driver will parse and print out the event information
in kernel log (dmesg) with the various information depending on the types of event and flag
specified.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/Kconfig            |    9 ++++
 drivers/iommu/Makefile           |    1 +
 drivers/iommu/amd_iommu.c        |    7 ++-
 drivers/iommu/amd_iommu_inject.c |   99 ++++++++++++++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_proto.h  |    9 ++++
 5 files changed, 123 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/amd_iommu_inject.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 5c514d07..c9787b9 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -64,6 +64,15 @@ config AMD_IOMMU_STATS
 	  information to userspace via debugfs.
 	  If unsure, say N.
 
+config AMD_IOMMU_EVENT_LOG_INJ
+	bool "Enable AMID IOMMU event injection interface via debugfs"
+	depends on AMD_IOMMU
+	select DEBUG_FS
+	---help---
+	  This option enables code in the AMD IOMMU driver to allow event log
+	  injection for testing IOMMU event log decoding logic via debugfs
+	  If unsure, say N.
+
 config AMD_IOMMU_V2
 	tristate "AMD IOMMU Version 2 driver"
 	depends on AMD_IOMMU && PROFILING
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index ef0e520..190eec5 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
 obj-$(CONFIG_AMD_IOMMU_V2) += amd_iommu_v2.o
+obj-$(CONFIG_AMD_IOMMU_EVENT_LOG_INJ) += amd_iommu_inject.o
 obj-$(CONFIG_DMAR_TABLE) += dmar.o
 obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
 obj-$(CONFIG_IRQ_REMAP) += intel_irq_remapping.o irq_remapping.o
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 477cfbb..30ac0cb 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -711,7 +711,7 @@ static void dump_command(unsigned long phys_addr)
 		pr_err("AMD-Vi: CMD[%d]: %08x\n", i, cmd->data[i]);
 }
 
-static void iommu_print_event(int type, int devid, int domid,
+void amd_iommu_print_event(int type, int devid, int domid,
 			      int flags, u64 address)
 {
 	pr_err("AMD-Vi: Event logged [");
@@ -799,7 +799,7 @@ retry:
 		goto retry;
 	}
 
-	iommu_print_event(type, devid, domid, flags, address);
+	amd_iommu_print_event(type, devid, domid, flags, address);
 
 	memset(__evt, 0, 4 * sizeof(u32));
 }
@@ -3288,6 +3288,9 @@ int __init amd_iommu_init_dma_ops(void)
 	else
 		pr_info("AMD-Vi: Lazy IO/TLB flushing enabled\n");
 
+#ifdef CONFIG_AMD_IOMMU_EVENT_LOG_INJ
+	amd_iommu_evninj_init();
+#endif
 	return 0;
 
 free_domains:
diff --git a/drivers/iommu/amd_iommu_inject.c b/drivers/iommu/amd_iommu_inject.c
new file mode 100644
index 0000000..b431b5f
--- /dev/null
+++ b/drivers/iommu/amd_iommu_inject.c
@@ -0,0 +1,99 @@
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+#include <linux/pci.h>
+#include <linux/irq.h>
+
+#include "amd_iommu_types.h"
+#include "amd_iommu_proto.h"
+
+#define TMPBUFSIZE 50
+
+/*
+ * ERROR Injection Stuff
+ */
+
+static struct dentry *evninj_dir;
+static struct dentry *evninj_dentry_devid;
+static struct dentry *evninj_dentry_domid;
+static struct dentry *evninj_dentry_addr;
+static struct dentry *evninj_dentry_flags;
+static struct dentry *evninj_dentry_type;
+
+static uint32_t evninj_devid;
+static uint32_t evninj_domid;
+static uint64_t evninj_addr;
+static uint32_t evninj_flags;
+static uint32_t evninj_type;
+
+DEFINE_RAW_SPINLOCK(evninj_lock);
+
+static ssize_t evninj_read_type(struct file *file, char __user *buf,
+			  size_t count, loff_t *offset)
+{
+	char tmpbuf[TMPBUFSIZE];
+	size_t maxlen = snprintf(tmpbuf, TMPBUFSIZE, "%u\n", evninj_type);
+	if (maxlen > TMPBUFSIZE)
+		maxlen = TMPBUFSIZE;
+	return simple_read_from_buffer(buf, count, offset, tmpbuf, maxlen);
+}
+
+static ssize_t evninj_write_type(struct file *file, const char __user *buf,
+			   size_t count, loff_t *offset)
+{
+	char tmpbuf[TMPBUFSIZE];
+	unsigned long flags;
+	int ret;
+
+	if (*offset)
+		return -EINVAL;
+
+	if (!count)
+		return 0;
+
+	if (count > TMPBUFSIZE - 1)
+		return -EINVAL;
+
+	memset(tmpbuf, 0x0, TMPBUFSIZE);
+
+	if (copy_from_user(tmpbuf, buf, count))
+		return -EFAULT;
+
+	raw_spin_lock_irqsave(&evninj_lock, flags);
+	ret = kstrtouint(tmpbuf, 0, &evninj_type);
+	raw_spin_unlock_irqrestore(&evninj_lock, flags);
+
+	if (ret != 0)
+		return -EINVAL;
+
+	amd_iommu_print_event(evninj_type, evninj_devid, evninj_domid,
+			      evninj_flags, evninj_addr);
+
+	return count;
+}
+
+static const struct file_operations evninj_type_ops = {
+	.read  = &evninj_read_type,
+	.write = &evninj_write_type,
+};
+
+int amd_iommu_evninj_init(void)
+{
+	evninj_dir = debugfs_create_dir("amd-iommu-evninj", NULL);
+	if (evninj_dir == NULL)
+		return -EINVAL;
+
+	pr_info("AMD-Vi: IOMMU event injection enabled.\n");
+
+	/* Log inject stuff */
+	evninj_dentry_devid = debugfs_create_u32("devid", 0744,
+		evninj_dir, &evninj_devid);
+	evninj_dentry_domid = debugfs_create_u32("domid", 0744,
+		evninj_dir, &evninj_domid);
+	evninj_dentry_addr  = debugfs_create_u64("addr" , 0744,
+		evninj_dir, &evninj_addr);
+	evninj_dentry_flags = debugfs_create_u32("flags", 0744,
+		evninj_dir, &evninj_flags);
+	evninj_dentry_type  = debugfs_create_file("type", 0744,
+		evninj_dir, NULL, &evninj_type_ops);
+	return 0;
+}
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index c294961..8eb9340 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -31,6 +31,9 @@ extern int amd_iommu_init_devices(void);
 extern void amd_iommu_uninit_devices(void);
 extern void amd_iommu_init_notifier(void);
 extern void amd_iommu_init_api(void);
+extern void amd_iommu_print_event(int type, int devid,
+	int domid, int flags, u64 address);
+
 
 /* Needed for interrupt remapping */
 extern int amd_iommu_supported(void);
@@ -69,6 +72,12 @@ static inline void amd_iommu_stats_init(void) { }
 
 #endif /* !CONFIG_AMD_IOMMU_STATS */
 
+#ifdef CONFIG_AMD_IOMMU_EVENT_LOG_INJ
+
+extern int amd_iommu_evninj_init(void);
+
+#endif /* CONFIG_AMD_IOMMU_EVENT_LOG_INJ */
+
 static inline bool is_rd890_iommu(struct pci_dev *pdev)
 {
 	return (pdev->vendor == PCI_VENDOR_ID_ATI) &&
-- 
1.7.10.4


