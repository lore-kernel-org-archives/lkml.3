Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3FXGFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:05:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:24160 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab3FXGFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:05:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,926,1363158000"; 
   d="scan'208";a="321529333"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v2] x86, tboot: provide debugfs interfaces to access TXT log
Date: Mon, 24 Jun 2013 13:55:33 +0800
Message-Id: <1372053333-21788-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These logs come from tboot (Trusted Boot, an open source,
pre-kernel/VMM module that uses Intel TXT to perform a
measured and verified launch of an OS kernel/VMM.).

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/kernel/tboot.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index f84fe00..2dec186 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -31,6 +31,7 @@
 #include <linux/pfn.h>
 #include <linux/mm.h>
 #include <linux/tboot.h>
+#include <linux/debugfs.h>
 
 #include <asm/realmode.h>
 #include <asm/processor.h>
@@ -338,6 +339,72 @@ static struct notifier_block tboot_cpu_notifier __cpuinitdata =
 	.notifier_call = tboot_cpu_callback,
 };
 
+#if defined(CONFIG_DEBUG_FS)
+
+#define TBOOT_LOG_UUID	{0x26, 0x25, 0x19, 0xc0, 0x30, 0x6b, 0xb4, 0x4d, \
+			 0x4c, 0x84, 0xa3, 0xe9, 0x53, 0xb8, 0x81, 0x74}
+#define TBOOT_SERIAL_LOG_ADDR	0x60000
+#define TBOOT_SERIAL_LOG_SIZE	0x08000
+#define LOG_MAX_SIZE_OFF	16
+#define LOG_BUF_OFF		24
+
+static uint8_t tboot_log_uuid[16] = TBOOT_LOG_UUID;
+
+static ssize_t tboot_log_read(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	void __iomem *log_base;
+	u8 log_uuid[16];
+	u32 max_size;
+	void *kbuf;
+	int ret = -EFAULT;
+
+	log_base = ioremap_nocache(TBOOT_SERIAL_LOG_ADDR,
+			TBOOT_SERIAL_LOG_SIZE);
+	if (!log_base)
+		return ret;
+
+	memcpy_fromio(log_uuid, log_base, sizeof(log_uuid));
+	if (memcmp(&tboot_log_uuid, log_uuid, sizeof(log_uuid)))
+		goto err_iounmap;
+
+	max_size = readl(log_base + LOG_MAX_SIZE_OFF);
+	if (*ppos >= max_size) {
+		ret = 0;
+		goto err_iounmap;
+	}
+
+	if (*ppos + count > max_size)
+		count = max_size - *ppos;
+
+	kbuf = kmalloc(count, GFP_KERNEL);
+	if (!kbuf) {
+		ret = -ENOMEM;
+		goto err_iounmap;
+	}
+
+	memcpy_fromio(kbuf, log_base + LOG_BUF_OFF + *ppos, count);
+	if (copy_to_user(user_buf, kbuf, count))
+		goto err_kfree;
+
+	*ppos += count;
+
+	ret = count;
+
+err_kfree:
+	kfree(kbuf);
+err_iounmap:
+	iounmap(log_base);
+	return ret;
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
@@ -348,6 +415,11 @@ static __init int tboot_late_init(void)
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

