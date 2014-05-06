Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079AbaEFFFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 01:05:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:43325 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358AbaEFFFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 01:05:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,994,1389772800"; 
   d="scan'208";a="526617969"
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, Liu ShuoX <shuox.liu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Dave Young <dyoung@redhat.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linn Crosetto <linn@hp.com>
Subject: [PATCH] [NOMERGE] reserved ram for pstore on PC (applied on top of new pstore patch)
Date: Tue,  6 May 2014 13:03:47 +0800
Message-Id: <1399352628-13308-5-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399352628-13308-1-git-send-email-shuox.liu@intel.com>
References: <1399352628-13308-1-git-send-email-shuox.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for pstore record test.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 arch/x86/kernel/setup.c |   2 +
 fs/pstore/Makefile      |   2 +-
 fs/pstore/test.c        | 170 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 fs/pstore/test.c

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 09c76d2..021b17a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -854,6 +854,7 @@ dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
  * Note: On x86_64, fixmaps are ready for use even before this is called.
  */
 
+extern void pstore_ram_reserved_memory(void);
 void __init setup_arch(char **cmdline_p)
 {
 	memblock_reserve(__pa_symbol(_text),
@@ -1217,6 +1218,7 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.resources.reserve_resources();
 
+	pstore_ram_reserved_memory();
 	e820_setup_gap();
 
 #ifdef CONFIG_VT
diff --git a/fs/pstore/Makefile b/fs/pstore/Makefile
index 4c9095c..b2a961b 100644
--- a/fs/pstore/Makefile
+++ b/fs/pstore/Makefile
@@ -7,5 +7,5 @@ obj-y += pstore.o
 pstore-objs += inode.o platform.o
 obj-$(CONFIG_PSTORE_FTRACE)	+= ftrace.o
 
-ramoops-objs += ram.o ram_core.o
+ramoops-objs += ram.o ram_core.o test.o
 obj-$(CONFIG_PSTORE_RAM)	+= ramoops.o
diff --git a/fs/pstore/test.c b/fs/pstore/test.c
new file mode 100644
index 0000000..109c5a8
--- /dev/null
+++ b/fs/pstore/test.c
@@ -0,0 +1,170 @@
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/cpufreq.h>
+#include <linux/seq_file.h>
+#include <linux/pstore_ramoops.h>
+#include <linux/platform_device.h>
+#include <linux/memblock.h>
+#include <linux/bootmem.h>
+#include <linux/debugfs.h>
+
+struct norm_zone_test_record {
+	unsigned long val;
+	char str[32];
+};
+
+static void print_record(struct seq_file *s, void *rec)
+{
+	struct norm_zone_test_record *record = rec;
+	pstore_print(s, "%s: %ld\n",
+		record->str, record->val);
+}
+
+DEFINE_PSTORE_RAMZONE(test_zone) = {
+	.size = 4096,
+	.name = "test_zone",
+	.item_size = sizeof(struct norm_zone_test_record),
+	.print_record = print_record,
+};
+
+DEFINE_PSTORE_RAMZONE(test_zone1) = {
+	.size = 4096,
+	.name = "test_zone1",
+	.item_size = sizeof(struct norm_zone_test_record),
+	.print_record = print_record,
+};
+
+static void add_test_record(char *str, unsigned long val)
+{
+	struct norm_zone_test_record *record;
+	record = persistent_ram_new_record(test_zone.prz);
+	if (record) {
+		record->val = val;
+		strcpy(record->str, str);
+	}
+	record = persistent_ram_new_record(test_zone1.prz);
+	if (record) {
+		record->val = val;
+		strcpy(record->str, str);
+	}
+}
+
+static int test_cpufreq_transition(struct notifier_block *nb,
+		unsigned long event, void *data)
+{
+	add_test_record("cpufreq transition", event);
+	return 0;
+}
+
+static struct notifier_block freq_transition = {
+	.notifier_call = test_cpufreq_transition,
+};
+
+#define SZ_4K   0x00001000
+#define SZ_2M   0x00200000
+#define SZ_2_1M 0x00219000
+#define SZ_16M  0x01000000
+
+#define PSTORE_RAM_START_DEFAULT        SZ_16M
+#define PSTORE_RAM_SIZE_DEFAULT         SZ_2_1M
+
+#ifdef CONFIG_X86_32
+#define RAM_MAX_MEM (max_low_pfn << PAGE_SHIFT)
+#else
+#define RAM_MAX_MEM (1 << 28)
+#endif
+
+static struct ramoops_platform_data pstore_ram_data = { 
+	.mem_size       = PSTORE_RAM_SIZE_DEFAULT,
+	.mem_address    = PSTORE_RAM_START_DEFAULT,
+	.record_size    = SZ_4K,
+	.console_size   = SZ_2M,
+	.dump_oops      = 1,
+};
+
+static struct platform_device pstore_ram_dev = { 
+	.name = "ramoops",
+	.dev = { 
+		.platform_data = &pstore_ram_data,
+	},  
+};
+
+static int __init pstore_ram_register(void)
+{
+	int ret;
+
+	ret = platform_device_register(&pstore_ram_dev);
+	if (ret) {
+		pr_err("%s: unable to register pstore_ram device: "
+			"start=0x%llx, size=0x%lx, ret=%d\n", __func__,
+			(unsigned long long)pstore_ram_data.mem_address,
+			pstore_ram_data.mem_size, ret);
+	}
+
+	return ret;
+}
+postcore_initcall(pstore_ram_register);
+
+void __init pstore_ram_reserved_memory(void)
+{
+	phys_addr_t mem;
+	size_t size;
+	int ret;
+
+	size = PSTORE_RAM_SIZE_DEFAULT;
+	size += pstore_norm_zones_size(NULL);
+	size = ALIGN(size, PAGE_SIZE);
+	mem = memblock_find_in_range(0, RAM_MAX_MEM, size, PAGE_SIZE);
+	if (!mem) {
+		pr_err("Cannot find memblock range for pstore_ram\n");
+		return;
+	}
+
+	ret = memblock_reserve(mem, size);
+	if (ret) {
+		pr_err("Failed to reserve memory from 0x%llx-0x%llx\n",
+				(unsigned long long)mem,
+				(unsigned long long)(mem + size - 1));
+		return;
+	}
+
+	pstore_ram_data.mem_address = mem;
+	pstore_ram_data.mem_size = size;
+
+	pr_info("reserved RAM buffer (0x%zx@0x%llx)\n",
+			size, (unsigned long long)mem);
+}
+
+static ssize_t pstore_ramoops_write(struct file *f, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static ssize_t pstore_ramoops_read(struct file *f, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct ramoops_zone *zone = (struct ramoops_zone *)f->private_data;
+
+	pstore_dump_records(zone);
+	return 0;
+}
+
+static const struct file_operations pstore_ramoops_fops = { 
+	.open   = simple_open,
+	.read   = pstore_ramoops_read,
+	.write  = pstore_ramoops_write,
+};
+
+
+static int __init norm_zone_test_init(void)
+{
+	cpufreq_register_notifier(&freq_transition,
+			CPUFREQ_TRANSITION_NOTIFIER);
+	debugfs_create_file("zone_dump", 0660, NULL, (void *)&test_zone, &pstore_ramoops_fops);
+	debugfs_create_file("zone1_dump", 0660, NULL, (void *)&test_zone1, &pstore_ramoops_fops);
+
+	return 0;
+}
+module_init(norm_zone_test_init);
-- 
1.8.3.2

