Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959Ab3IDFaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:30:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36275 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761389Ab3IDFaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:30:16 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas.Mingarelli@hp.com, toshi.kani@hp.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 2/2] Add support for modifying firmware configuration via HP iLO
Date: Wed,  4 Sep 2013 01:29:51 -0400
Message-Id: <1378272591-9755-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378272591-9755-1-git-send-email-matthew.garrett@nebula.com>
References: <1378272591-9755-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent HP iLO systems provide support for modifying the firmware
configuration at runtime via accesses to the iLO hardware. This patch adds
support for exposing the available firmware configuration options via sysfs
and permits userspace to modify them, taking effect after the next reboot.
This has been implemented based on tracing register accesses from the HP
userspace utility that performs the same job - the userspace driver performs
direct hardware access via port IO, which honestly seems like an amazingly
bad idea. Moving this in-kernel is massively safer.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 .../ABI/testing/sysfs-firmware-hp_bios_config      |  27 +
 drivers/platform/x86/Kconfig                       |  14 +-
 drivers/platform/x86/hpilo_support.c               | 777 ++++++++++++++++++++-
 3 files changed, 811 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-hp_bios_config

diff --git a/Documentation/ABI/testing/sysfs-firmware-hp_bios_config b/Documentation/ABI/testing/sysfs-firmware-hp_bios_config
new file mode 100644
index 0000000..69ad11b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-hp_bios_config
@@ -0,0 +1,27 @@
+What:		/sys/firmware/hpilo_bios_config
+Date:		July 2013
+Contact:	Matthew Garrett <matthew.garrett@nebula.com>
+Description:
+		This directory exposes the HP iLO interface for manipulating
+		firmware configuration options. One subdirectory is present
+		for each configuration option, and contains the following
+		files:
+
+		active:		The currently active value for the
+				configuration option.
+
+		choices:	The available choices for the configuration
+				option with human-readable descriptions of
+				each option.
+
+		description:	The human-readable description of the
+				configuration option.
+
+		new:		Read/write attribute for setting the value
+				of the configuration option. Writing an integer
+				will configure the firmware to use this choice
+				on the next reboot. Reading will return the
+				value that has been chosen, if any.
+
+		warning:	Human-readable text describing any caveats
+				associated with the configuration option.
\ No newline at end of file
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 34e6a47..e880a37 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -818,12 +818,18 @@ config PVPANIC
 	  (guest) communicate panic events to the host.
 
 config HP_ILO_SUPPORT
-        tristate "HP ProLiant iLO2+ Hardware Watchdog Timer"
+        tristate "HP ProLiant iLO2+ System Support driver"
         depends on X86 && PCI
         help
-          A software monitoring watchdog and NMI sourcing driver. This driver
-          will detect lockups and provide a stack trace. This is a driver that
-          will only load on an HP ProLiant system with a minimum of iLO2 support.
+	  This driver provides support for the System Support functionality of
+	  the HP ProLiant iLO2 and later devices. It implements two main
+	  functions:
+
+	  1) A software monitoring watchdog and NMI sourcing driver. This
+	  driver will detect lockups and provide a stack trace.
+
+	  2) On systems with appropriate support, an interface to allow
+	  runtime configuration of system firmware configuration options.
 
           To compile this driver as a module, choose M here: the module will be
           called hpilo_support.
diff --git a/drivers/platform/x86/hpilo_support.c b/drivers/platform/x86/hpilo_support.c
index de7e4f4..d8788fd 100644
--- a/drivers/platform/x86/hpilo_support.c
+++ b/drivers/platform/x86/hpilo_support.c
@@ -16,22 +16,26 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/device.h>
+#include <linux/dmi.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
+#include <linux/nvram.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/nvram.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
 #ifdef CONFIG_HPWDT_NMI_DECODING
-#include <linux/dmi.h>
-#include <linux/spinlock.h>
 #include <linux/nmi.h>
 #include <linux/kdebug.h>
 #include <linux/notifier.h>
@@ -51,9 +55,13 @@ static bool nowayout = WATCHDOG_NOWAYOUT;
 static char expect_release;
 static unsigned long hpwdt_is_open;
 
+static struct kobject *hpilo_kobj;
+static struct pci_dev *hpilo_dev;
 static void __iomem *pci_mem_addr;		/* the PCI-memory address */
 static unsigned long __iomem *hpwdt_timer_reg;
 static unsigned long __iomem *hpwdt_timer_con;
+static unsigned long rcu_address;
+static int rcu_size;
 
 static DEFINE_PCI_DEVICE_TABLE(hpwdt_devices) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },	/* iLO2 */
@@ -62,6 +70,60 @@ static DEFINE_PCI_DEVICE_TABLE(hpwdt_devices) = {
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
 
+enum access_type { EV, CMOS, NVRAM };
+enum flag_type { NONE, FLAG_EXCLUDE, FLAG_SET };
+
+struct hpilo_option {
+        struct list_head list;
+        char name[5];
+        char *desc;
+        char *warning;
+        struct kobject kobj;
+        u8 active;
+        u8 new;
+        spinlock_t choice_lock;
+        struct list_head choice_list;
+};
+
+struct hpilo_option_choice {
+        struct list_head list;
+        enum access_type access_type;
+        char *name;
+        char token[7];
+        u8 choice;
+        u8 mask;
+        u8 value;
+        u16 offset;
+        enum flag_type flag_type;
+        char flag_target[5];
+        u8 flag_choice;
+};
+
+struct hpilo_attribute {
+        struct attribute attr;
+        ssize_t (*show) (struct hpilo_option *entry, char *buf);
+        ssize_t (*store)(struct hpilo_option *entry, const char *buf,
+                         size_t count);
+};
+
+#define HPILO_ATTR(_name, _mode, _show, _store) \
+struct hpilo_attribute hpilo_attr_##_name = {            \
+	.attr = {.name = __stringify(_name), .mode = _mode},	     \
+	.show = _show,						     \
+	.store = _store,					     \
+};
+
+static LIST_HEAD(option_list);
+static DEFINE_SPINLOCK(option_list_lock);
+
+static int read_ev(char *token, int offset, unsigned char *value);
+static int write_ev(char *token, int offset, unsigned char value);
+static int read_cmos(int offset, unsigned char *value);
+static int write_cmos(int offset, unsigned char value);
+static int read_nvram(int offset, unsigned char *value);
+static int write_nvram(int offset, unsigned char value);
+static void set_cold_reboot(void);
+
 #ifdef CONFIG_HPWDT_NMI_DECODING
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
 #define CRU_BIOS_SIGNATURE_VALUE	0x55524324
@@ -102,7 +164,6 @@ struct smbios_proliant_info {
 };
 #define SMBIOS_ICRU_INFORMATION		219
 
-
 struct cmn_registers {
 	union {
 		struct {
@@ -428,6 +489,711 @@ static int detect_cru_service(void)
 #endif /* CONFIG_X86_64 */
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 
+/* type 229 */
+struct smbios_table_info {
+	char signature[4];
+	u64 address;
+	u32 length;
+};
+#define SMBIOS_TABLE_INFORMATION	229
+
+static struct hpilo_option *to_option(struct kobject *kobj)
+{
+        return container_of(kobj, struct hpilo_option, kobj);
+}
+
+static struct hpilo_attribute *to_attribute(struct attribute *attr)
+{
+        return container_of(attr, struct hpilo_attribute, attr);
+}
+
+static struct hpilo_option *find_option(char *name)
+{
+        struct hpilo_option *option;
+
+        list_for_each_entry(option, &option_list, list) {
+                if (strcmp(name, option->name) == 0)
+                        return option;
+        }
+
+        return NULL;
+}
+
+static struct hpilo_option_choice *find_choice(struct hpilo_option *opt,
+                                                 int choiceval)
+{
+        struct hpilo_option_choice *choice;
+
+        list_for_each_entry(choice, &opt->choice_list, list) {
+                if (choice->choice == choiceval)
+                        return choice;
+        }
+
+        return NULL;
+}
+
+static bool is_set(struct hpilo_option_choice *choice)
+{
+        char value;
+
+        switch (choice->access_type) {
+        case EV:
+                read_ev(choice->token, choice->offset, &value);
+                value &= ~(choice->mask);
+                if (value == choice->value)
+                        return true;
+                break;
+        case CMOS:
+                read_cmos(choice->offset, &value);
+                value &= ~(choice->mask);
+                if (value == choice->value)
+                        return true;
+                break;
+        case NVRAM:
+                read_nvram(choice->offset, &value);
+                value &= ~(choice->mask);
+                if (value == choice->value)
+                        return true;
+                break;
+        default:
+                dev_err(&hpilo_dev->dev, "Unknown choice address space\n");
+                return -EINVAL;
+        }
+
+        return false;
+}
+
+static int set_value(struct hpilo_option_choice *choice)
+{
+        char value;
+
+        switch (choice->access_type) {
+        case EV:
+                read_ev(choice->token, choice->offset, &value);
+                value &= choice->mask;
+                value |= choice->value;
+                write_ev(choice->token, choice->offset, value);
+                break;
+        case CMOS:
+                read_cmos(choice->offset, &value);
+                value &= choice->mask;
+                value |= choice->value;
+                write_cmos(choice->offset, value);
+                break;
+        case NVRAM:
+                read_nvram(choice->offset, &value);
+                value &= choice->mask;
+                value |= choice->value;
+                write_nvram(choice->offset, value);
+                break;
+        default:
+                dev_err(&hpilo_dev->dev, "Unknown choice address space\n");
+                return -EINVAL;
+        }
+
+        return 0;
+}
+
+static ssize_t hpilo_show_active(struct hpilo_option *option, char *buf)
+{
+        return sprintf(buf, "%d\n", option->active);
+}
+
+static ssize_t hpilo_show_choices(struct hpilo_option *option, char *buf)
+{
+        int size = 0;
+        struct hpilo_option_choice *choice;
+
+        spin_lock(&option->choice_lock);
+        list_for_each_entry(choice, &option->choice_list, list) {
+                size += sprintf(buf + size, "%d: %s\n", choice->choice,
+                                choice->name);
+        }
+        spin_unlock(&option->choice_lock);
+
+        return size;
+}
+
+static ssize_t hpilo_show_desc(struct hpilo_option *option, char *buf)
+{
+        return sprintf(buf, "%s\n", option->desc);
+}
+
+static ssize_t hpilo_show_new(struct hpilo_option *option, char *buf)
+{
+	if (option->new)
+		return sprintf(buf, "%d\n", option->new);
+	else
+		return sprintf(buf, "None set\n");
+}
+
+static ssize_t hpilo_store_new(struct hpilo_option *option, const char *buf,
+                                 size_t count)
+{
+        unsigned long result;
+        struct hpilo_option *flagoption;
+        struct hpilo_option_choice *choice, *flagchoice;
+
+        if (kstrtoul(buf, 10, &result) != 0)
+                return -EINVAL;
+
+        spin_lock(&option_list_lock);
+
+        choice = find_choice(option, result);
+
+        if (!choice) {
+                count = -EINVAL;
+                goto out;
+        }
+
+        if (choice->flag_type == FLAG_SET) {
+                flagoption = find_option(choice->flag_target);
+
+                if (flagoption) {
+                        flagchoice = find_choice(flagoption,
+                                                 choice->flag_choice);
+                        if (flagchoice)
+                                set_value(flagchoice);
+                }
+        } else if (choice->flag_type == FLAG_EXCLUDE) {
+                flagoption = find_option(choice->flag_target);
+                if (flagoption) {
+                        flagchoice = find_choice(flagoption,
+                                                 choice->flag_choice);
+                        if (flagchoice) {
+                                if (is_set(flagchoice)) {
+                                        dev_err(&hpilo_dev->dev,
+                                                "Attempting to set mutually exclusive option");
+                                        count = -EINVAL;
+                                        goto out;
+                                }
+                        }
+                }
+        }
+
+        set_value(choice);
+        set_cold_reboot();
+
+        option->new = result;
+out:
+        spin_unlock(&option_list_lock);
+        return count;
+}
+
+static ssize_t hpilo_show_warning(struct hpilo_option *option, char *buf)
+{
+        if (option->warning)
+                return sprintf(buf, "%s\n", option->warning);
+        else
+                return sprintf(buf, "None\n");
+}
+
+static HPILO_ATTR(active, 0400, hpilo_show_active, NULL);
+static HPILO_ATTR(choices, 0400, hpilo_show_choices, NULL);
+static HPILO_ATTR(description, 0400, hpilo_show_desc, NULL);
+static HPILO_ATTR(new, 0600, hpilo_show_new, hpilo_store_new);
+static HPILO_ATTR(warning, 0400, hpilo_show_warning, NULL);
+
+static void hpilo_option_release(struct kobject *kobj)
+{
+        struct hpilo_option *option = to_option(kobj);
+        struct hpilo_option_choice *choice, *next;
+
+        spin_lock(&option->choice_lock);
+
+        list_for_each_entry_safe(choice, next, &option->choice_list, list) {
+                kfree(choice->name);
+                kfree(choice);
+        }
+
+        spin_unlock(&option->choice_lock);
+        list_del(&option->list);
+        kfree(option->warning);
+        kfree(option->desc);
+        kfree(option);
+}
+static ssize_t hpilo_attr_show(struct kobject *kobj, struct attribute *attr,
+                                 char *buf)
+{
+        struct hpilo_option *option = to_option(kobj);
+        struct hpilo_attribute *hpilo_attribute = to_attribute(attr);
+
+        return hpilo_attribute->show(option, buf);
+}
+
+static ssize_t hpilo_attr_store(struct kobject *kobj, struct attribute *attr,
+                                  const char *buf, size_t count)
+{
+        struct hpilo_option *option = to_option(kobj);
+        struct hpilo_attribute *hpilo_attribute = to_attribute(attr);
+
+        return hpilo_attribute->store(option, buf, count);
+}
+
+static const struct sysfs_ops hpilo_option_ops = {
+        .show = hpilo_attr_show,
+        .store = hpilo_attr_store,
+};
+
+static struct attribute *def_attrs[] = {
+        &hpilo_attr_choices.attr,
+        &hpilo_attr_description.attr,
+        &hpilo_attr_warning.attr,
+        &hpilo_attr_active.attr,
+        &hpilo_attr_new.attr,
+        NULL,
+};
+
+static struct kobj_type hp_option_ktype = {
+        .release = hpilo_option_release,
+        .sysfs_ops = &hpilo_option_ops,
+        .default_attrs = def_attrs,
+};
+
+static void find_rcu_table(const struct dmi_header *dm)
+{
+	struct smbios_table_info *entry;
+        int i;
+
+        if (dm->length < 16)
+                return;
+
+        entry = (void *)dm + 4;
+
+        for (i = 0; i < (dm->length - 4) / sizeof(*entry); i++) {
+                if (memcmp(entry[i].signature, "$CRP", 4) == 0) {
+                        rcu_address = entry[i].address;
+                        rcu_size = entry[i].length;
+                        return;
+                }
+        }
+}
+
+static void find_dmi_table(const struct dmi_header *dm, void *dummy)
+{
+        if (dm->type == 0xe5)
+                find_rcu_table(dm);
+}
+
+static int validate_rcu_table(void __iomem *table)
+{
+        if (memcmp(table, "$RBS", 4) != 0)
+                return -EINVAL;
+
+        return 0;
+}
+
+static int find_ev_reg(char *token, int offset, unsigned char *outpage,
+                       unsigned char *outreg)
+{
+        unsigned char registers[6] = {0, 0, 0, 0, 0, 0};
+        bool found = false;
+        unsigned char page, reg;
+
+        for (page = 0xfd; page >= 0x9e; page--) {
+                pci_write_config_byte(hpilo_dev, 0xa6, page);
+                for (reg = 0x9f; reg >= 0x80; reg--) {
+                        registers[0] = registers[1];
+                        registers[1] = registers[2];
+                        registers[2] = registers[3];
+                        registers[3] = registers[4];
+                        registers[4] = registers[5];
+                        pci_read_config_byte(hpilo_dev, reg, &registers[5]);
+                        if (memcmp(registers, token, 6) == 0) {
+                                found = true;
+                                break;
+                        }
+                }
+                if (found)
+                        break;
+        }
+
+        if (!found)
+                return -ENOENT;
+
+        reg -= offset;
+        reg -= 3;
+
+        if (reg < 0x80) {
+                page--;
+                reg += 0x20;
+        }
+
+        *outreg = reg;
+        *outpage = page;
+
+        return 0;
+}
+
+static void set_ev_checksum(void)
+{
+        unsigned char page, reg, value;
+        unsigned short sum = 0;
+
+        for (page = 0xfd; page >= 0x9e; page--) {
+                pci_write_config_byte(hpilo_dev, 0xa6, page);
+                for (reg = 0x9f; reg >= 0x80; reg--) {
+                        if (page == 0x9e && reg < 0x82)
+                                break;
+                        pci_read_config_byte(hpilo_dev, reg, &value);
+                        sum += value;
+                }
+        }
+
+        sum = 0 - sum;
+
+        pci_write_config_byte(hpilo_dev, 0x81, sum >> 8);
+        pci_write_config_byte(hpilo_dev, 0x80, sum & 0xff);
+}
+
+static int read_ev(char *token, int offset, unsigned char *value)
+{
+        unsigned char page, reg;
+        int ret;
+
+        ret = find_ev_reg(token, offset, &page, &reg);
+
+        if (ret)
+                return ret;
+
+        pci_write_config_byte(hpilo_dev, 0xa6, page);
+        pci_read_config_byte(hpilo_dev, reg, value);
+
+        return 0;
+}
+
+static int write_ev(char *token, int offset, unsigned char value)
+{
+        unsigned char page, reg;
+        int ret;
+
+        ret = find_ev_reg(token, offset, &page, &reg);
+
+        if (ret)
+                return ret;
+
+        pci_write_config_byte(hpilo_dev, 0xa6, page);
+        pci_write_config_byte(hpilo_dev, reg, value);
+
+        set_ev_checksum();
+
+        return 0;
+}
+
+static int read_nvram(int offset, unsigned char *value)
+{
+        int page = offset / 0x20;
+        int reg = offset - (page * 0x20) + 0x80;
+
+        pci_write_config_byte(hpilo_dev, 0xa6, page);
+        pci_read_config_byte(hpilo_dev, reg, value);
+
+        return 0;
+}
+
+static int write_nvram(int offset, unsigned char value)
+{
+        int page = offset / 0x20;
+        int reg = offset - (page * 0x20) + 0x80;
+
+        pci_write_config_byte(hpilo_dev, 0xa6, page);
+        pci_write_config_byte(hpilo_dev, reg, value);
+
+        return 0;
+}
+
+static int read_cmos(int offset, unsigned char *value)
+{
+        *value = nvram_read_byte(offset - NVRAM_FIRST_BYTE);
+        return 0;
+}
+
+static int write_cmos(int offset, unsigned char value)
+{
+        nvram_write_byte(offset - NVRAM_FIRST_BYTE, value);
+        return 0;
+}
+
+static void set_cold_reboot(void)
+{
+        unsigned char value;
+
+        read_nvram(0x39, &value);
+        value |= 0x1;
+        write_nvram(0x39, value);
+}
+
+static int install_option(struct hpilo_option *option)
+{
+        int ret;
+
+        if (list_empty(&option->choice_list)) {
+                kfree(option);
+                return 0;
+        }
+
+        spin_lock(&option_list_lock);
+        list_add_tail(&option->list, &option_list);
+        spin_unlock(&option_list_lock);
+
+        if (!option->desc)
+                return 0;
+
+        ret = kobject_init_and_add(&option->kobj, &hp_option_ktype,
+                                   hpilo_kobj, "%s", option->name);
+
+        return ret;
+}
+
+static int parse_entry(struct hpilo_option *option,
+                       unsigned char __iomem *entry, int type,
+                       int length)
+{
+        struct hpilo_option_choice *choice;
+        unsigned char __iomem *choiceentry, *flag;
+        int choicelen, access_type;
+
+        /* Don't know what to do with type 3 entries yet */
+        if (type == 3)
+                return 0;
+
+        option->name[0] = entry[6];
+        option->name[1] = entry[5];
+        option->name[2] = entry[4];
+        option->name[3] = entry[3];
+        option->name[4] = 0;
+        access_type = entry[13];
+
+        spin_lock_init(&option->choice_lock);
+        INIT_LIST_HEAD(&option->choice_list);
+
+        choiceentry = entry + 15;
+
+        while (choiceentry < (entry + length)) {
+                bool skip = false;
+
+                choice = kzalloc(sizeof(*choice), GFP_KERNEL);
+
+                if (!choice)
+                        return -ENOMEM;
+
+                INIT_LIST_HEAD(&choice->list);
+
+                switch (access_type) {
+                case 0x03:
+                        choice->access_type = EV;
+                        choice->choice = choiceentry[0];
+                        choice->offset = choiceentry[2];
+                        choice->mask = choiceentry[3];
+                        choice->value = choiceentry[4];
+                        memcpy(choice->token, choiceentry + 6, 6);
+                        choice->token[6] = 0;
+                        choicelen = 14;
+                        break;
+                case 0x04:
+                        choice->access_type = NVRAM;
+                        choice->choice = choiceentry[0];
+                        choice->offset = (choiceentry[2] << 8) | choiceentry[1];
+                        choice->mask = choiceentry[3];
+                        choice->value = choiceentry[4];
+                        choicelen = 6;
+                        break;
+                case 0x05:
+                        choice->access_type = CMOS;
+                        choice->choice = choiceentry[0];
+                        choice->offset = choiceentry[1];
+                        choice->mask = choiceentry[2];
+                        choice->value = choiceentry[3];
+                        choicelen = 5;
+                        break;
+                default:
+                        /*
+                         * We don't know how to deal with these types
+                         * yet
+                         */
+                        kfree(choice);
+                        choiceentry = entry + length;
+                        skip = true;
+                        break;
+                }
+
+                if (skip)
+                        continue;
+
+                if (choiceentry[choicelen-1] != 0) {
+                        flag = choiceentry + choicelen;
+                        /* Parse flags */
+                        switch (flag[5]) {
+                        case 0:
+                                choice->flag_type = FLAG_EXCLUDE;
+                                break;
+                        default:
+                                choice->flag_type = FLAG_SET;
+                                break;
+                        }
+                        choice->flag_target[0] = flag[3];
+                        choice->flag_target[1] = flag[2];
+                        choice->flag_target[2] = flag[1];
+                        choice->flag_target[3] = flag[0];
+                        choice->flag_target[4] = 0;
+                        choice->flag_choice = flag[4];
+                        choiceentry += 6;
+                }
+
+                if (is_set(choice))
+                        option->active = choice->choice;
+
+                list_add_tail(&choice->list, &option->choice_list);
+
+                choiceentry += choicelen;
+        }
+
+        return 0;
+}
+
+static void parse_string(struct hpilo_option *option, char __iomem *entry)
+{
+        struct hpilo_option_choice *choice;
+
+        if (!option)
+                return;
+
+        switch (entry[6]) {
+        case 0x05:
+                option->desc = kstrdup(entry + 8, GFP_KERNEL);
+                break;
+        case 0x06:
+                list_for_each_entry(choice, &option->choice_list, list) {
+                        if (choice->name != NULL)
+                                continue;
+
+                        choice->name = kstrdup(entry + 8, GFP_KERNEL);
+                        break;
+                }
+                break;
+        case 0x60:
+                option->warning = kstrdup(entry + 8, GFP_KERNEL);
+                break;
+        }
+}
+
+static int parse_rcu_table(void __iomem *table)
+{
+        unsigned char __iomem *entry = table + 0x15;
+        u8 type;
+        int length, ret;
+        struct hpilo_option *option = NULL;
+
+        while (1) {
+                type = entry[0];
+                length = (entry[2] << 8) | entry[1];
+                if ((void *)entry + length > table + rcu_size) {
+                        dev_err(&hpilo_dev->dev,
+                                "Entry overflows rcu table\n");
+                        return 0;
+                }
+
+                if (length == 0)
+                        break;
+
+                if (type == 1) {
+                        parse_string(option, entry);
+                } else {
+                        /* Skip any entries with null names */
+                        if (entry[6] == 0) {
+                                entry += length;
+                                continue;
+                        }
+
+                        if (option)
+                                install_option(option);
+
+                        option = kzalloc(sizeof(*option), GFP_KERNEL);
+                        if (!option)
+                                return -ENOMEM;
+
+                        ret = parse_entry(option, entry, type, length);
+                        if (ret)
+                                return ret;
+                }
+
+                entry += length;
+        }
+
+        if (option)
+                install_option(option);
+
+        return 0;
+}
+
+void hpilo_bios_config_teardown(void)
+{
+        struct hpilo_option *option, *next;
+
+        spin_lock(&option_list_lock);
+        list_for_each_entry_safe(option, next, &option_list, list) {
+                if (option->desc)
+                        kobject_put(&option->kobj);
+        }
+        spin_unlock(&option_list_lock);
+        kobject_put(hpilo_kobj);
+}
+
+int hpilo_bios_config_setup(struct pci_dev *dev)
+{
+        int ret = 0;
+        static void __iomem *rcu_table;
+
+        hpilo_dev = dev;
+
+        hpilo_kobj = kobject_create_and_add("hpilo_bios_config",
+					    firmware_kobj);
+
+        if (!hpilo_kobj) {
+                ret = -ENOMEM;
+                goto out;
+        }
+
+        dmi_walk(find_dmi_table, NULL);
+
+        if (!rcu_address || !rcu_size) {
+                dev_err(&dev->dev, "Unable to find RCU table\n");
+                ret = -ENODEV;
+                goto out_put;
+        }
+
+        rcu_table = ioremap(rcu_address, rcu_size);
+
+        if (!rcu_table) {
+                dev_err(&dev->dev, "Can't map RCU table");
+                ret = -ENODEV;
+                goto out_put;
+        }
+
+        if (validate_rcu_table(rcu_table) != 0) {
+                dev_err(&dev->dev, "Can't validate RCU table\n");
+                ret = -ENODEV;
+                goto out_unmap;
+        }
+
+        if (parse_rcu_table(rcu_table) != 0) {
+                dev_err(&dev->dev, "Unable to parse RCU table\n");
+                ret = -EINVAL;
+                goto out_unmap;
+        }
+
+        iounmap(rcu_table);
+
+        return 0;
+
+out_unmap:
+        iounmap(rcu_table);
+out_put:
+        kobject_put(hpilo_kobj);
+out:
+        return ret;
+}
+
 /*
  *	Watchdog operations
  */
@@ -840,6 +1606,10 @@ static int hpwdt_init_one(struct pci_dev *dev,
 	dev_info(&dev->dev, "HP Watchdog Timer Driver: %s"
 			", timer margin: %d seconds (nowayout=%d).\n",
 			HPWDT_VERSION, soft_margin, nowayout);
+
+	/* It's ok for this to fail */
+	hpilo_bios_config_setup(dev);
+
 	return 0;
 
 error_misc_register:
@@ -856,6 +1626,7 @@ static void hpwdt_exit(struct pci_dev *dev)
 	if (!nowayout)
 		hpwdt_stop();
 
+	hpilo_bios_config_teardown();
 	misc_deregister(&hpwdt_miscdev);
 	hpwdt_exit_nmi_decoding();
 	pci_iounmap(dev, pci_mem_addr);
-- 
1.8.3.1

