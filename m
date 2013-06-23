Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab3FWIEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 04:04:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:24522 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3FWIE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 04:04:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,922,1363158000"; 
   d="scan'208";a="358190578"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH] x86, tboot: provide debugfs interfaces to access TXT log
Date: Sun, 23 Jun 2013 15:54:10 +0800
Message-Id: <1371974050-21436-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These logs come from tboot (Trusted Boot, an open source,
pre-kernel/VMM module that uses Intel TXT to perform a
measured and verified launch of an OS kernel/VMM.).

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/kernel/tboot.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index f84fe00..dd6f198 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -31,6 +31,7 @@
 #include <linux/pfn.h>
 #include <linux/mm.h>
 #include <linux/tboot.h>
+#include <linux/debugfs.h>
 
 #include <asm/realmode.h>
 #include <asm/processor.h>
@@ -338,6 +339,70 @@ static struct notifier_block tboot_cpu_notifier __cpuinitdata =
 	.notifier_call = tboot_cpu_callback,
 };
 
+#if defined(CONFIG_DEBUG_FS)
+
+#define TBOOT_LOG_UUID	{0x26, 0x25, 0x19, 0xc0, 0x30, 0x6b, 0xb4, 0x4d, \
+			 0x4c, 0x84, 0xa3, 0xe9, 0x53, 0xb8, 0x81, 0x74}
+#define TBOOT_SERIAL_LOG_ADDR	0x60000
+#define TBOOT_SERIAL_LOG_SIZE	0x08000
+
+static uint8_t tboot_log_uuid[16] = TBOOT_LOG_UUID;
+
+struct tboot_log {
+	uint8_t		uuid[16];
+	uint32_t	max_size;
+	uint32_t	curr_pos;
+	char		buf[];
+};
+
+static struct tboot_log *get_log(void)
+{
+	struct tboot_log *log;
+
+	log = (struct tboot_log *)ioremap_nocache(TBOOT_SERIAL_LOG_ADDR,
+						  TBOOT_SERIAL_LOG_SIZE);
+	if (!log)
+		return NULL;
+
+	if (memcmp(&tboot_log_uuid, &log->uuid, sizeof(log->uuid))) {
+		iounmap(log);
+		return NULL;
+	}
+
+	return log;
+}
+
+static ssize_t tboot_log_read(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct tboot_log *log;
+
+	log = get_log();
+	if (!log)
+		return -EFAULT;
+
+	if (*ppos >= log->max_size)
+		return 0;
+
+	if (*ppos + count > log->max_size)
+		count = log->max_size - *ppos;
+
+	if (copy_to_user(user_buf, log->buf + *ppos, count))
+		return -EFAULT;
+
+	*ppos += count;
+
+	iounmap(log);
+	return count;
+}
+
+static const struct file_operations tboot_log_fops = {
+	.read = tboot_log_read,
+	.llseek = default_llseek,
+};
+
+#endif /* CONFIG_DEBUG_FS */
+
 static __init int tboot_late_init(void)
 {
 	if (!tboot_enabled())
@@ -348,6 +413,11 @@ static __init int tboot_late_init(void)
 	atomic_set(&ap_wfs_count, 0);
 	register_hotcpu_notifier(&tboot_cpu_notifier);
 
+#if defined(CONFIG_DEBUG_FS)
+	debugfs_create_file("tboot_log", S_IRUSR,
+			arch_debugfs_dir, NULL, &tboot_log_fops);
+#endif
+
 	acpi_os_set_prepare_sleep(&tboot_sleep);
 	return 0;
 }
-- 
1.7.9.5

