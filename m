Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbaEFFFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 01:05:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:44120 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276AbaEFFFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 01:05:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,994,1389772800"; 
   d="scan'208";a="535252345"
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, Zhang Yanmin <yanmin.zhang@intel.com>,
        Liu ShuoX <shuox.liu@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Olof Johansson <olof@lixom.net>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>, Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>,
        David Cohen <david.a.cohen@linux.intel.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v5 1/3] pstore: restructure ramoops to support more trace
Date: Tue,  6 May 2014 13:03:44 +0800
Message-Id: <1399352628-13308-2-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399352628-13308-1-git-send-email-shuox.liu@intel.com>
References: <1399352628-13308-1-git-send-email-shuox.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanmin <yanmin.zhang@intel.com>

The patch restructure ramoops of pstore a little to support more user-defined
tracers through ramoops. Here is reason we enhance ramoops:
pstore ramoops is a very import debug feature for mobile development. At present,
ramoops has supported kdump, console and ftrace tracer. Sometimes, we need some
special tracers such as recording cmd and data when driver send/receive. But now,
it's hard to add new tracers into ramoops without touching the pstore core codes.
So we restructure ramoops to let it more flexiable, more eailier to extend.

With this, we split the pstore codes and new tracers which are based on ramoops.
Developer could add a new tracer based on ramoops standalone and pstore detects
it automatically.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 Documentation/ramoops.txt                 |  71 ++++++++++++-
 arch/x86/kernel/vmlinux.lds.S             |   9 ++
 drivers/platform/chrome/chromeos_pstore.c |   2 +-
 fs/pstore/inode.c                         |  85 +++++++++++++++-
 fs/pstore/internal.h                      |   1 +
 fs/pstore/platform.c                      |  38 +++++++
 fs/pstore/ram.c                           | 159 ++++++++++++++++++++++++------
 fs/pstore/ram_core.c                      |  20 ++++
 include/linux/pstore.h                    |   2 +
 include/linux/pstore_ram.h                |  21 +---
 include/linux/pstore_ramoops.h            |  84 ++++++++++++++++
 11 files changed, 443 insertions(+), 49 deletions(-)
 create mode 100644 include/linux/pstore_ramoops.h

diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 69b3cac..9d37cd4 100644
--- a/Documentation/ramoops.txt
+++ b/Documentation/ramoops.txt
@@ -49,7 +49,7 @@ Setting the ramoops parameters can be done in 2 different manners:
  2. Use a platform device and set the platform data. The parameters can then
  be set through that platform data. An example of doing that is:
 
-#include <linux/pstore_ram.h>
+#include <linux/pstore_ramoops.h>
 [...]
 
 static struct ramoops_platform_data ramoops_data = {
@@ -117,3 +117,72 @@ file. Here is an example of usage:
  0 ffffffff811d9c54  ffffffff8101a7a0  __const_udelay <- native_machine_emergency_restart+0x110/0x1e0
  0 ffffffff811d9c34  ffffffff811d9c80  __delay <- __const_udelay+0x30/0x40
  0 ffffffff811d9d14  ffffffff811d9c3f  delay_tsc <- __delay+0xf/0x20
+
+6. Persistent record tracing
+
+Persistent record tracing is useful for debugging software and hardware
+related hang issues. Its flexible usage allows developers to record data in
+a self-defined record structure at tracepoints where they want. After
+rebooting or reset, kernel saves the old records and provides "NAME-ramoops"
+file for applications/users to access.
+Here is an example of usage:
+
+#include <linux/pstore_ramoops.h>
+[...]
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
+static void add_test_record(char *str, unsigned long val)
+{
+	struct norm_zone_test_record *record;
+	record = ramoops_get_new_record(&test_zone);
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
+static int __init norm_zone_test_init(void)
+{
+	cpufreq_register_notifier(&freq_transition,
+			CPUFREQ_TRANSITION_NOTIFIER);
+	return 0;
+}
+module_init(norm_zone_test_init);
+
+Developers could put a call to the memblock_reserve() function (below) in
+setup_arch to reserve memory and implement a ramoops platform device.
+
+#include <linux/memblock.h>
+#include <linux/pstore_ramoops.h>
+
+memblock_reserve(ramoops_data.mem_address, ramoops_data.mem_size +
+					pstore_norm_zones_size(NULL));
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 49edf2d..2422622 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -304,6 +304,15 @@ SECTIONS
 		NOSAVE_DATA
 	}
 #endif
+#ifdef CONFIG_PSTORE
+	/* ramoops zone */
+	. = ALIGN(8);
+	.ram_zone : AT(ADDR(.ram_zone) - LOAD_OFFSET) {
+		__ramoops_zone_start = .;
+		*(.ram_zone)
+		__ramoops_zone_end = .;
+	}
+#endif
 
 	/* BSS */
 	. = ALIGN(PAGE_SIZE);
diff --git a/drivers/platform/chrome/chromeos_pstore.c b/drivers/platform/chrome/chromeos_pstore.c
index e0e0e65..59e102f 100644
--- a/drivers/platform/chrome/chromeos_pstore.c
+++ b/drivers/platform/chrome/chromeos_pstore.c
@@ -11,7 +11,7 @@
 #include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/pstore_ram.h>
+#include <linux/pstore_ramoops.h>
 
 static struct dmi_system_id chromeos_pstore_dmi_table[] __initdata = {
 	{
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 192297b..d463481 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -54,6 +54,78 @@ struct pstore_private {
 	char	data[];
 };
 
+struct pstore_seq_data {
+	size_t off;
+};
+
+static void *pstore_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct pstore_private *ps = s->private;
+	struct ramoops_context *cxt = ps->psi->data;
+	struct ramoops_zone    *zones = cxt->zones;
+	int size = zones[ps->id].item_size;
+	struct pstore_seq_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	data->off = 0;
+	data->off += *pos * size;
+	if (data->off + size > ps->size) {
+		kfree(data);
+		return NULL;
+	}
+
+	return data;
+}
+
+static void pstore_seq_stop(struct seq_file *s, void *v)
+{
+	kfree(v);
+}
+
+static void *pstore_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct pstore_private *ps = s->private;
+	struct pstore_seq_data *data = v;
+	struct ramoops_context *cxt = ps->psi->data;
+	struct ramoops_zone    *zones = cxt->zones;
+	int size = zones[ps->id].item_size;
+
+	data->off += size;
+	if (data->off + size > ps->size)
+		return NULL;
+
+	(*pos)++;
+	return data;
+}
+
+static int pstore_seq_show(struct seq_file *s, void *v)
+{
+	struct pstore_private *ps = s->private;
+	struct pstore_seq_data *data = v;
+	void *record = (void *)(ps->data + data->off);
+	struct ramoops_context *cxt = ps->psi->data;
+	struct ramoops_zone    *zones = cxt->zones;
+
+	if (zones[ps->id].print_record)
+		zones[ps->id].print_record(s, record);
+	else {
+		seq_printf(s, "zone %s doesn't support print_record\n",
+			zones[ps->id].name);
+	}
+
+	return 0;
+}
+
+static const struct seq_operations pstore_seq_ops = {
+	.start	= pstore_seq_start,
+	.next	= pstore_seq_next,
+	.stop	= pstore_seq_stop,
+	.show	= pstore_seq_show,
+};
+
 struct pstore_ftrace_seq_data {
 	const void *ptr;
 	size_t off;
@@ -126,7 +198,8 @@ static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 	struct seq_file *sf = file->private_data;
 	struct pstore_private *ps = sf->private;
 
-	if (ps->type == PSTORE_TYPE_FTRACE)
+	if (ps->type == PSTORE_TYPE_FTRACE ||
+		ps->type == PSTORE_TYPE_NORM)
 		return seq_read(file, userbuf, count, ppos);
 	return simple_read_from_buffer(userbuf, count, ppos, ps->data, ps->size);
 }
@@ -140,6 +213,8 @@ static int pstore_file_open(struct inode *inode, struct file *file)
 
 	if (ps->type == PSTORE_TYPE_FTRACE)
 		sops = &pstore_ftrace_seq_ops;
+	if (ps->type == PSTORE_TYPE_NORM)
+		sops = &pstore_seq_ops;
 
 	err = seq_open(file, sops);
 	if (err < 0)
@@ -286,6 +361,8 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	char			name[PSTORE_NAMELEN];
 	struct pstore_private	*private, *pos;
 	unsigned long		flags;
+	struct ramoops_context	*cxt = psi->data;
+	struct ramoops_zone	*zones = cxt ? cxt->zones : NULL;
 
 	spin_lock_irqsave(&allpstore_lock, flags);
 	list_for_each_entry(pos, &allpstore, list) {
@@ -337,6 +414,12 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	case PSTORE_TYPE_PPC_COMMON:
 		sprintf(name, "powerpc-common-%s-%lld", psname, id);
 		break;
+	case PSTORE_TYPE_NORM:
+		/* if zones NULL, it's unknown */
+		if (zones) {
+			sprintf(name, "%s-%s", zones[id].name, psname);
+			break;
+		}
 	case PSTORE_TYPE_UNKNOWN:
 		sprintf(name, "unknown-%s-%lld", psname, id);
 		break;
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index 3b3d305..86623ee 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/time.h>
 #include <linux/pstore.h>
+#include <linux/pstore_ramoops.h>
 
 #if NR_CPUS <= 2 && defined(CONFIG_ARM_THUMB)
 #define PSTORE_CPU_IN_IP 0x1
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 46d269e..f208c2b 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -353,6 +353,44 @@ static struct kmsg_dumper pstore_dumper = {
 	.dump = pstore_dump,
 };
 
+
+struct ramoops_zone *pstore_norm_zones(void)
+{
+	return (struct ramoops_zone *)&__ramoops_zone_start;
+}
+EXPORT_SYMBOL_GPL(pstore_norm_zones);
+
+/* calculate norm zone number and size if they exist */
+unsigned long pstore_norm_zones_size(int *zone_count)
+{
+	unsigned long mem_size = 0;
+	struct ramoops_zone *zones;
+	struct ramoops_zone *zone_end;
+	int i;
+	int count;
+
+	zones = (struct ramoops_zone *)&__ramoops_zone_start;
+	zone_end = (struct ramoops_zone *)&__ramoops_zone_end;
+
+	if (zones > zone_end)
+		return 0;
+	count = zone_end - zones;
+	if (zone_count)
+		*zone_count = count > 0 ? count : 0;
+	if (count <= 0)
+		return 0;
+
+	for (i = 0; i < count; i++) {
+		/*Roundup in case buffer is overflown*/
+		if (zones[i].size && !is_power_of_2(zones[i].size))
+			zones[i].size = roundup_pow_of_two(zones[i].size);
+		mem_size += zones[i].size;
+	}
+
+	return mem_size;
+}
+EXPORT_SYMBOL_GPL(pstore_norm_zones_size);
+
 #ifdef CONFIG_PSTORE_CONSOLE
 static void pstore_console_write(struct console *con, const char *s, unsigned c)
 {
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 3b57443..eb10ce5 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -33,7 +33,9 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/compiler.h>
-#include <linux/pstore_ram.h>
+#include <linux/seq_file.h>
+#include <linux/pstore_ramoops.h>
+#include <linux/sched.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
 #define MIN_MEM_SIZE 4096UL
@@ -73,26 +75,6 @@ MODULE_PARM_DESC(ramoops_ecc,
 		"ECC buffer size in bytes (1 is a special value, means 16 "
 		"bytes ECC)");
 
-struct ramoops_context {
-	struct persistent_ram_zone **przs;
-	struct persistent_ram_zone *cprz;
-	struct persistent_ram_zone *fprz;
-	phys_addr_t phys_addr;
-	unsigned long size;
-	size_t record_size;
-	size_t console_size;
-	size_t ftrace_size;
-	int dump_oops;
-	struct persistent_ram_ecc_info ecc_info;
-	unsigned int max_dump_cnt;
-	unsigned int dump_write_cnt;
-	/* _read_cnt need clear on ramoops_pstore_open */
-	unsigned int dump_read_cnt;
-	unsigned int console_read_cnt;
-	unsigned int ftrace_read_cnt;
-	struct pstore_info pstore;
-};
-
 static struct platform_device *dummy;
 static struct ramoops_platform_data *dummy_data;
 
@@ -103,6 +85,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
 	cxt->dump_read_cnt = 0;
 	cxt->console_read_cnt = 0;
 	cxt->ftrace_read_cnt = 0;
+	cxt->norm_read_cnt = 0;
 	return 0;
 }
 
@@ -156,6 +139,47 @@ static void ramoops_read_kmsg_hdr(char *buffer, struct timespec *time,
 	}
 }
 
+/* Norm ram zone user should use it to output instead of seq_pritnf */
+int pstore_print(struct seq_file *m, const char *f, ...)
+{
+	int ret;
+	va_list args;
+
+	va_start(args, f);
+	if (m)
+		ret = seq_vprintf(m, f, args);
+	else
+		ret = vprintk(f, args);
+	va_end(args);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pstore_print);
+
+/* Dump runtime records into printk buffer */
+void pstore_dump_records(struct ramoops_zone *zone)
+{
+	size_t size, off = 0;
+	char *buf;
+	struct persistent_ram_zone *prz;
+	int item_size = zone->item_size;
+	int i;
+
+	prz = zone->prz;
+	if (!prz)
+		return;
+	buf = persistent_ram_buffer(prz);
+	size = persistent_ram_size(prz);
+	if (zone->print_record) {
+		for (i = 0; off < size; off += item_size, i++) {
+			zone->print_record(NULL, (void *)(buf + off));
+			if (!(i % 20))
+				cond_resched();
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(pstore_dump_records);
+
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   int *count, struct timespec *time,
 				   char **buf, bool *compressed,
@@ -176,6 +200,16 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 		prz = ramoops_get_next_prz(&cxt->fprz, &cxt->ftrace_read_cnt,
 					   1, id, type, PSTORE_TYPE_FTRACE, 0);
 	if (!prz)
+		while (cxt->norm_read_cnt < cxt->norm_num) {
+			prz = ramoops_get_next_prz(cxt->norm_przs,
+					&cxt->norm_read_cnt, cxt->norm_num,
+					id, type, PSTORE_TYPE_NORM, 0);
+			if (!prz)
+				continue;
+			else
+				break;
+		}
+	if (!prz)
 		return 0;
 
 	size = persistent_ram_old_size(prz);
@@ -295,6 +329,11 @@ static int ramoops_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	case PSTORE_TYPE_FTRACE:
 		prz = cxt->fprz;
 		break;
+	case PSTORE_TYPE_NORM:
+		if (id >= cxt->norm_num)
+			return -EINVAL;
+		prz = cxt->norm_przs[id];
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -329,6 +368,20 @@ static void ramoops_free_przs(struct ramoops_context *cxt)
 	kfree(cxt->przs);
 }
 
+static void ramoops_free_norm_przs(struct ramoops_context *cxt)
+{
+	int i;
+
+	cxt->norm_num = 0;
+	if (!cxt->norm_przs)
+		return;
+
+	for (i = 0; i < cxt->norm_num &&
+			!IS_ERR_OR_NULL(cxt->norm_przs[i]); i++)
+		persistent_ram_free(cxt->norm_przs[i]);
+	kfree(cxt->norm_przs);
+}
+
 static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
 			     phys_addr_t *paddr, size_t dump_mem_sz)
 {
@@ -376,7 +429,7 @@ fail_prz:
 
 static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 			    struct persistent_ram_zone **prz,
-			    phys_addr_t *paddr, size_t sz, u32 sig)
+			    phys_addr_t *paddr, size_t sz, u32 sig, bool ecc)
 {
 	if (!sz)
 		return 0;
@@ -388,7 +441,7 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 		return -ENOMEM;
 	}
 
-	*prz = persistent_ram_new(*paddr, sz, sig, &cxt->ecc_info);
+	*prz = persistent_ram_new(*paddr, sz, sig, ecc ? &cxt->ecc_info : NULL);
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
@@ -404,12 +457,47 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 	return 0;
 }
 
+static int ramoops_init_norm_przs(struct device *dev,
+			struct ramoops_context *cxt,
+			phys_addr_t *paddr)
+{
+	int err = -ENOMEM;
+	struct ramoops_zone *zones = cxt->zones;
+	int i;
+
+	cxt->norm_przs = kzalloc(sizeof(*cxt->przs) * cxt->norm_num,
+			GFP_KERNEL);
+	if (!cxt->norm_przs) {
+		dev_err(dev, "failed to initialize a prz array for dumps\n");
+		goto fail_prz;
+	}
+
+	for (i = 0; i < cxt->norm_num; i++) {
+		err = ramoops_init_prz(dev, cxt, &zones[i].prz,
+				paddr, zones[i].size, 0, false);
+		if (err)
+			goto fail_prz;
+		persistent_ram_set_record_size(zones[i].prz,
+						zones[i].item_size);
+		zones[i].get_new_record = persistent_ram_new_record;
+		zones[i].prz->buffer_size -=
+			(zones[i].prz->buffer_size % zones[i].item_size);
+		cxt->norm_przs[i] = zones[i].prz;
+	}
+
+	return 0;
+fail_prz:
+	ramoops_free_norm_przs(cxt);
+	return err;
+}
+
 static int ramoops_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ramoops_platform_data *pdata = pdev->dev.platform_data;
 	struct ramoops_context *cxt = &oops_cxt;
 	size_t dump_mem_sz;
+	size_t norm_mem_size;
 	phys_addr_t paddr;
 	int err = -EINVAL;
 
@@ -419,8 +507,11 @@ static int ramoops_probe(struct platform_device *pdev)
 	if (cxt->max_dump_cnt)
 		goto fail_out;
 
+	cxt->norm_zone_size = norm_mem_size =
+		pstore_norm_zones_size(&cxt->norm_num);
+
 	if (!pdata->mem_size || (!pdata->record_size && !pdata->console_size &&
-			!pdata->ftrace_size)) {
+			!pdata->ftrace_size && !norm_mem_size)) {
 		pr_err("The memory size and the record/console size must be "
 			"non-zero\n");
 		goto fail_out;
@@ -433,6 +524,8 @@ static int ramoops_probe(struct platform_device *pdev)
 	if (pdata->ftrace_size && !is_power_of_2(pdata->ftrace_size))
 		pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
 
+	if (cxt->norm_num)
+		cxt->zones = pstore_norm_zones();
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
@@ -443,25 +536,29 @@ static int ramoops_probe(struct platform_device *pdev)
 
 	paddr = cxt->phys_addr;
 
-	dump_mem_sz = cxt->size - cxt->console_size - cxt->ftrace_size;
+	dump_mem_sz = cxt->size - cxt->console_size -
+		cxt->ftrace_size - norm_mem_size;
 	err = ramoops_init_przs(dev, cxt, &paddr, dump_mem_sz);
 	if (err)
 		goto fail_out;
+	err = ramoops_init_norm_przs(dev, cxt, &paddr);
+	if (err)
+		goto fail_norm_przs;
 
 	err = ramoops_init_prz(dev, cxt, &cxt->cprz, &paddr,
-			       cxt->console_size, 0);
+			       cxt->console_size, 0, true);
 	if (err)
 		goto fail_init_cprz;
 
-	err = ramoops_init_prz(dev, cxt, &cxt->fprz, &paddr, cxt->ftrace_size,
-			       LINUX_VERSION_CODE);
+	err = ramoops_init_prz(dev, cxt, &cxt->fprz, &paddr,
+				cxt->ftrace_size, 0, true);
 	if (err)
 		goto fail_init_fprz;
 
-	if (!cxt->przs && !cxt->cprz && !cxt->fprz) {
+	if (!cxt->przs && !cxt->cprz && !cxt->fprz && !cxt->norm_przs) {
 		pr_err("memory size too small, minimum is %zu\n",
 			cxt->console_size + cxt->record_size +
-			cxt->ftrace_size);
+			cxt->ftrace_size + cxt->norm_zone_size);
 		err = -EINVAL;
 		goto fail_cnt;
 	}
@@ -514,6 +611,8 @@ fail_cnt:
 fail_init_fprz:
 	kfree(cxt->cprz);
 fail_init_cprz:
+	ramoops_free_norm_przs(cxt);
+fail_norm_przs:
 	ramoops_free_przs(cxt);
 fail_out:
 	return err;
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index ff7e3d4..9c25a0f 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -30,6 +30,7 @@ struct persistent_ram_buffer {
 	uint32_t    sig;
 	atomic_t    start;
 	atomic_t    size;
+	uint32_t    record_size;
 	uint8_t     data[0];
 };
 
@@ -356,6 +357,19 @@ int notrace persistent_ram_write(struct persistent_ram_zone *prz,
 	return count;
 }
 
+notrace void *persistent_ram_new_record(struct persistent_ram_zone *prz)
+{
+	size_t record_size;
+
+	if (!prz)
+		return NULL;
+
+	record_size = prz->buffer->record_size;
+	buffer_size_add(prz, record_size);
+	return (void *)(prz->buffer->data +
+			buffer_start_add(prz, record_size));
+}
+
 size_t persistent_ram_old_size(struct persistent_ram_zone *prz)
 {
 	return prz->old_log_size;
@@ -380,6 +394,12 @@ void persistent_ram_zap(struct persistent_ram_zone *prz)
 	persistent_ram_update_header_ecc(prz);
 }
 
+void persistent_ram_set_record_size(struct persistent_ram_zone *prz,
+			uint32_t record_size)
+{
+	prz->buffer->record_size = record_size;
+}
+
 static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 {
 	struct page **pages;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index ece0c6b..9936859 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -39,6 +39,8 @@ enum pstore_type_id {
 	PSTORE_TYPE_PPC_RTAS	= 4,
 	PSTORE_TYPE_PPC_OF	= 5,
 	PSTORE_TYPE_PPC_COMMON	= 6,
+	/* normal ram zones */
+	PSTORE_TYPE_NORM	= 7,
 	PSTORE_TYPE_UNKNOWN	= 255
 };
 
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 9974975..d7d0b7a 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -22,6 +22,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/pstore.h>
 
 struct persistent_ram_buffer;
 struct rs_control;
@@ -59,6 +60,10 @@ void persistent_ram_zap(struct persistent_ram_zone *prz);
 
 int persistent_ram_write(struct persistent_ram_zone *prz, const void *s,
 	unsigned int count);
+void persistent_ram_set_record_size(struct persistent_ram_zone *prz,
+		uint32_t record_size);
+
+void *persistent_ram_new_record(struct persistent_ram_zone *prz);
 
 void persistent_ram_save_old(struct persistent_ram_zone *prz);
 size_t persistent_ram_old_size(struct persistent_ram_zone *prz);
@@ -67,20 +72,4 @@ void persistent_ram_free_old(struct persistent_ram_zone *prz);
 ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
 	char *str, size_t len);
 
-/*
- * Ramoops platform data
- * @mem_size	memory size for ramoops
- * @mem_address	physical memory address to contain ramoops
- */
-
-struct ramoops_platform_data {
-	unsigned long	mem_size;
-	unsigned long	mem_address;
-	unsigned long	record_size;
-	unsigned long	console_size;
-	unsigned long	ftrace_size;
-	int		dump_oops;
-	struct persistent_ram_ecc_info ecc_info;
-};
-
 #endif
diff --git a/include/linux/pstore_ramoops.h b/include/linux/pstore_ramoops.h
new file mode 100644
index 0000000..28f47a9
--- /dev/null
+++ b/include/linux/pstore_ramoops.h
@@ -0,0 +1,84 @@
+#ifndef __LINUX_PSTORE_RAMOOPS_H__
+#define __LINUX_PSTORE_RAMOOPS_H__
+#include <linux/pstore_ram.h>
+
+struct ramoops_context {
+	struct persistent_ram_zone **przs;
+	struct persistent_ram_zone *cprz;
+	struct persistent_ram_zone *fprz;
+	phys_addr_t phys_addr;
+	unsigned long size;
+	size_t record_size;
+	size_t console_size;
+	size_t ftrace_size;
+	int dump_oops;
+	struct persistent_ram_ecc_info ecc_info;
+	unsigned int max_dump_cnt;
+	unsigned int dump_write_cnt;
+	unsigned int dump_read_cnt;
+	unsigned int console_read_cnt;
+	unsigned int ftrace_read_cnt;
+	struct pstore_info pstore;
+	struct ramoops_zone *zones;
+	struct persistent_ram_zone **norm_przs;
+	size_t norm_zone_size;
+	unsigned int norm_num;
+	unsigned int norm_read_cnt;
+};
+
+struct ramoops_zone {
+	char		name[16];
+	unsigned long	size;
+	struct persistent_ram_zone *prz;
+	int		item_size;
+	void (*print_record)(struct seq_file *s, void *record);
+	void *(*get_new_record)(struct persistent_ram_zone *prz);
+};
+
+/*
+ * Ramoops platform data
+ * @mem_size	memory size for ramoops
+ * @mem_address	physical memory address to contain ramoops
+ */
+
+struct ramoops_platform_data {
+	unsigned long	mem_size;
+	unsigned long	mem_address;
+	unsigned long	record_size;
+	unsigned long	console_size;
+	unsigned long	ftrace_size;
+	int		dump_oops;
+	struct persistent_ram_ecc_info ecc_info;
+};
+
+extern void *__ramoops_zone_start __weak;
+extern void *__ramoops_zone_end __weak;
+/*
+ * define a ram_zone for ramoops
+ * Refer to Documentation/ramoops.txt
+ */
+#ifdef MODULE
+#define DEFINE_PSTORE_RAMZONE(zone) \
+	struct ramoops_zone zone
+#else
+#define DEFINE_PSTORE_RAMZONE(zone) \
+	struct ramoops_zone zone \
+	__attribute__((__section__(".ram_zone"))) \
+	__aligned(sizeof(void *))
+#endif
+
+/* calculate norm zone number and size if they exist */
+unsigned long pstore_norm_zones_size(int *zone_count);
+struct ramoops_zone *pstore_norm_zones(void);
+__printf(2, 3) int pstore_print(struct seq_file *m,
+		const char *f, ...);
+void pstore_dump_records(struct ramoops_zone *zone);
+
+static inline void *ramoops_get_new_record(struct ramoops_zone *zone)
+{
+	if (zone && zone->get_new_record)
+		return zone->get_new_record(zone->prz);
+	return NULL;
+}
+
+#endif
-- 
1.8.3.2

