Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408Ab3JQSUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:20:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758374Ab3JQSUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:20:17 -0400
Date: Thu, 17 Oct 2013 11:19:48 -0700
From: tip-bot for Kuppuswamy Sathyanarayanan <tipbot@zytor.com>
Message-ID: <tip-76b13ba79b6854700b812a4a7c9298583cad4bc5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381896701-23476-10-git-send-email-david.a.cohen@linux.intel.com>
References: <1381896701-23476-10-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] intel_mid: Moved SFI related code to sfi.c
Git-Commit-ID: 76b13ba79b6854700b812a4a7c9298583cad4bc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 11:19:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76b13ba79b6854700b812a4a7c9298583cad4bc5
Gitweb:     http://git.kernel.org/tip/76b13ba79b6854700b812a4a7c9298583cad4bc5
Author:     Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
AuthorDate: Tue, 15 Oct 2013 21:11:38 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 Oct 2013 17:16:46 -0700

intel_mid: Moved SFI related code to sfi.c

Moved SFI specific parsing/handling code to sfi.c. This will enable us
to reuse our intel-mid code for platforms that supports firmware
interfaces other than SFI (like ACPI).

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: http://lkml.kernel.org/r/1381896701-23476-10-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/intel-mid.h        |   1 +
 arch/x86/platform/intel-mid/Makefile    |   2 +
 arch/x86/platform/intel-mid/intel-mid.c | 451 +----------------------------
 arch/x86/platform/intel-mid/sfi.c       | 485 ++++++++++++++++++++++++++++++++
 4 files changed, 489 insertions(+), 450 deletions(-)

diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index ad236ae..3b0e7a7 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -15,6 +15,7 @@
 
 extern int intel_mid_pci_init(void);
 extern int __init sfi_parse_mrtc(struct sfi_table_header *table);
+extern int __init sfi_parse_mtmr(struct sfi_table_header *table);
 extern int sfi_mrtc_num;
 extern struct sfi_rtc_table_entry sfi_mrtc_array[];
 
diff --git a/arch/x86/platform/intel-mid/Makefile b/arch/x86/platform/intel-mid/Makefile
index de29635..b11e5b2 100644
--- a/arch/x86/platform/intel-mid/Makefile
+++ b/arch/x86/platform/intel-mid/Makefile
@@ -1,3 +1,5 @@
 obj-$(CONFIG_X86_INTEL_MID) += intel-mid.o
 obj-$(CONFIG_X86_INTEL_MID)	+= intel_mid_vrtc.o
 obj-$(CONFIG_EARLY_PRINTK_INTEL_MID)	+= early_printk_intel_mid.o
+# SFI specific code
+obj-$(CONFIG_SFI) += sfi.o
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 40a3ff8..4091569 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -18,19 +18,9 @@
 #include <linux/interrupt.h>
 #include <linux/scatterlist.h>
 #include <linux/sfi.h>
-#include <linux/intel_pmic_gpio.h>
-#include <linux/spi/spi.h>
-#include <linux/i2c.h>
-#include <linux/platform_data/pca953x.h>
-#include <linux/gpio_keys.h>
-#include <linux/input.h>
-#include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
-#include <linux/mfd/intel_msic.h>
-#include <linux/gpio.h>
-#include <linux/i2c/tc35876x.h>
 
 #include <asm/setup.h>
 #include <asm/mpspec_def.h>
@@ -68,19 +58,11 @@
 
 enum intel_mid_timer_options intel_mid_timer_options;
 
-static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
-static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
 enum intel_mid_cpu_type __intel_mid_cpu_chip;
 EXPORT_SYMBOL_GPL(__intel_mid_cpu_chip);
 
-int sfi_mtimer_num;
-
-struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
-EXPORT_SYMBOL_GPL(sfi_mrtc_array);
-int sfi_mrtc_num;
 static void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
 			struct devs_id *dev);
-
 static void intel_mid_power_off(void)
 {
 }
@@ -90,114 +72,6 @@ static void intel_mid_reboot(void)
 	intel_scu_ipc_simple_command(IPCMSG_COLD_BOOT, 0);
 }
 
-/* parse all the mtimer info to a static mtimer array */
-static int __init sfi_parse_mtmr(struct sfi_table_header *table)
-{
-	struct sfi_table_simple *sb;
-	struct sfi_timer_table_entry *pentry;
-	struct mpc_intsrc mp_irq;
-	int totallen;
-
-	sb = (struct sfi_table_simple *)table;
-	if (!sfi_mtimer_num) {
-		sfi_mtimer_num = SFI_GET_NUM_ENTRIES(sb,
-					struct sfi_timer_table_entry);
-		pentry = (struct sfi_timer_table_entry *) sb->pentry;
-		totallen = sfi_mtimer_num * sizeof(*pentry);
-		memcpy(sfi_mtimer_array, pentry, totallen);
-	}
-
-	pr_debug("SFI MTIMER info (num = %d):\n", sfi_mtimer_num);
-	pentry = sfi_mtimer_array;
-	for (totallen = 0; totallen < sfi_mtimer_num; totallen++, pentry++) {
-		pr_debug("timer[%d]: paddr = 0x%08x, freq = %dHz,"
-			" irq = %d\n", totallen, (u32)pentry->phys_addr,
-			pentry->freq_hz, pentry->irq);
-			if (!pentry->irq)
-				continue;
-			mp_irq.type = MP_INTSRC;
-			mp_irq.irqtype = mp_INT;
-/* triggering mode edge bit 2-3, active high polarity bit 0-1 */
-			mp_irq.irqflag = 5;
-			mp_irq.srcbus = MP_BUS_ISA;
-			mp_irq.srcbusirq = pentry->irq;	/* IRQ */
-			mp_irq.dstapic = MP_APIC_ALL;
-			mp_irq.dstirq = pentry->irq;
-			mp_save_irq(&mp_irq);
-	}
-
-	return 0;
-}
-
-struct sfi_timer_table_entry *sfi_get_mtmr(int hint)
-{
-	int i;
-	if (hint < sfi_mtimer_num) {
-		if (!sfi_mtimer_usage[hint]) {
-			pr_debug("hint taken for timer %d irq %d\n",
-				hint, sfi_mtimer_array[hint].irq);
-			sfi_mtimer_usage[hint] = 1;
-			return &sfi_mtimer_array[hint];
-		}
-	}
-	/* take the first timer available */
-	for (i = 0; i < sfi_mtimer_num;) {
-		if (!sfi_mtimer_usage[i]) {
-			sfi_mtimer_usage[i] = 1;
-			return &sfi_mtimer_array[i];
-		}
-		i++;
-	}
-	return NULL;
-}
-
-void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr)
-{
-	int i;
-	for (i = 0; i < sfi_mtimer_num;) {
-		if (mtmr->irq == sfi_mtimer_array[i].irq) {
-			sfi_mtimer_usage[i] = 0;
-			return;
-		}
-		i++;
-	}
-}
-
-/* parse all the mrtc info to a global mrtc array */
-int __init sfi_parse_mrtc(struct sfi_table_header *table)
-{
-	struct sfi_table_simple *sb;
-	struct sfi_rtc_table_entry *pentry;
-	struct mpc_intsrc mp_irq;
-
-	int totallen;
-
-	sb = (struct sfi_table_simple *)table;
-	if (!sfi_mrtc_num) {
-		sfi_mrtc_num = SFI_GET_NUM_ENTRIES(sb,
-						struct sfi_rtc_table_entry);
-		pentry = (struct sfi_rtc_table_entry *)sb->pentry;
-		totallen = sfi_mrtc_num * sizeof(*pentry);
-		memcpy(sfi_mrtc_array, pentry, totallen);
-	}
-
-	pr_debug("SFI RTC info (num = %d):\n", sfi_mrtc_num);
-	pentry = sfi_mrtc_array;
-	for (totallen = 0; totallen < sfi_mrtc_num; totallen++, pentry++) {
-		pr_debug("RTC[%d]: paddr = 0x%08x, irq = %d\n",
-			totallen, (u32)pentry->phys_addr, pentry->irq);
-		mp_irq.type = MP_INTSRC;
-		mp_irq.irqtype = mp_INT;
-		mp_irq.irqflag = 0xf;	/* level trigger and active low */
-		mp_irq.srcbus = MP_BUS_ISA;
-		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
-		mp_irq.dstapic = MP_APIC_ALL;
-		mp_irq.dstirq = pentry->irq;
-		mp_save_irq(&mp_irq);
-	}
-	return 0;
-}
-
 static unsigned long __init intel_mid_calibrate_tsc(void)
 {
 	unsigned long fast_calibrate;
@@ -339,55 +213,6 @@ static inline int __init setup_x86_intel_mid_timer(char *arg)
 }
 __setup("x86_intel_mid_timer=", setup_x86_intel_mid_timer);
 
-/*
- * Parsing GPIO table first, since the DEVS table will need this table
- * to map the pin name to the actual pin.
- */
-static struct sfi_gpio_table_entry *gpio_table;
-static int gpio_num_entry;
-
-static int __init sfi_parse_gpio(struct sfi_table_header *table)
-{
-	struct sfi_table_simple *sb;
-	struct sfi_gpio_table_entry *pentry;
-	int num, i;
-
-	if (gpio_table)
-		return 0;
-	sb = (struct sfi_table_simple *)table;
-	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
-	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
-
-	gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
-	if (!gpio_table)
-		return -1;
-	memcpy(gpio_table, pentry, num * sizeof(*pentry));
-	gpio_num_entry = num;
-
-	pr_debug("GPIO pin info:\n");
-	for (i = 0; i < num; i++, pentry++)
-		pr_debug("info[%2d]: controller = %16.16s, pin_name = %16.16s,"
-		" pin = %d\n", i,
-			pentry->controller_name,
-			pentry->pin_name,
-			pentry->pin_no);
-	return 0;
-}
-
-static int get_gpio_by_name(const char *name)
-{
-	struct sfi_gpio_table_entry *pentry = gpio_table;
-	int i;
-
-	if (!pentry)
-		return -1;
-	for (i = 0; i < gpio_num_entry; i++, pentry++) {
-		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
-			return pentry->pin_no;
-	}
-	return -1;
-}
-
 /* the offset for the mapping of global gpio pin to irq */
 #define INTEL_MID_IRQ_OFFSET 0x100
 
@@ -703,197 +528,6 @@ static const struct devs_id __initconst device_ids[] = {
 	{ 0 }
 };
 
-#define MAX_IPCDEVS	24
-static struct platform_device *ipc_devs[MAX_IPCDEVS];
-static int ipc_next_dev;
-
-#define MAX_SCU_SPI	24
-static struct spi_board_info *spi_devs[MAX_SCU_SPI];
-static int spi_next_dev;
-
-#define MAX_SCU_I2C	24
-static struct i2c_board_info *i2c_devs[MAX_SCU_I2C];
-static int i2c_bus[MAX_SCU_I2C];
-static int i2c_next_dev;
-
-static void __init intel_scu_device_register(struct platform_device *pdev)
-{
-	if (ipc_next_dev == MAX_IPCDEVS)
-		pr_err("too many SCU IPC devices");
-	else
-		ipc_devs[ipc_next_dev++] = pdev;
-}
-
-static void __init intel_scu_spi_device_register(struct spi_board_info *sdev)
-{
-	struct spi_board_info *new_dev;
-
-	if (spi_next_dev == MAX_SCU_SPI) {
-		pr_err("too many SCU SPI devices");
-		return;
-	}
-
-	new_dev = kzalloc(sizeof(*sdev), GFP_KERNEL);
-	if (!new_dev) {
-		pr_err("failed to alloc mem for delayed spi dev %s\n",
-			sdev->modalias);
-		return;
-	}
-	memcpy(new_dev, sdev, sizeof(*sdev));
-
-	spi_devs[spi_next_dev++] = new_dev;
-}
-
-static void __init intel_scu_i2c_device_register(int bus,
-						struct i2c_board_info *idev)
-{
-	struct i2c_board_info *new_dev;
-
-	if (i2c_next_dev == MAX_SCU_I2C) {
-		pr_err("too many SCU I2C devices");
-		return;
-	}
-
-	new_dev = kzalloc(sizeof(*idev), GFP_KERNEL);
-	if (!new_dev) {
-		pr_err("failed to alloc mem for delayed i2c dev %s\n",
-			idev->type);
-		return;
-	}
-	memcpy(new_dev, idev, sizeof(*idev));
-
-	i2c_bus[i2c_next_dev] = bus;
-	i2c_devs[i2c_next_dev++] = new_dev;
-}
-
-BLOCKING_NOTIFIER_HEAD(intel_scu_notifier);
-EXPORT_SYMBOL_GPL(intel_scu_notifier);
-
-/* Called by IPC driver */
-void intel_scu_devices_create(void)
-{
-	int i;
-
-	for (i = 0; i < ipc_next_dev; i++)
-		platform_device_add(ipc_devs[i]);
-
-	for (i = 0; i < spi_next_dev; i++)
-		spi_register_board_info(spi_devs[i], 1);
-
-	for (i = 0; i < i2c_next_dev; i++) {
-		struct i2c_adapter *adapter;
-		struct i2c_client *client;
-
-		adapter = i2c_get_adapter(i2c_bus[i]);
-		if (adapter) {
-			client = i2c_new_device(adapter, i2c_devs[i]);
-			if (!client)
-				pr_err("can't create i2c device %s\n",
-					i2c_devs[i]->type);
-		} else
-			i2c_register_board_info(i2c_bus[i], i2c_devs[i], 1);
-	}
-	intel_scu_notifier_post(SCU_AVAILABLE, NULL);
-}
-EXPORT_SYMBOL_GPL(intel_scu_devices_create);
-
-/* Called by IPC driver */
-void intel_scu_devices_destroy(void)
-{
-	int i;
-
-	intel_scu_notifier_post(SCU_DOWN, NULL);
-
-	for (i = 0; i < ipc_next_dev; i++)
-		platform_device_del(ipc_devs[i]);
-}
-EXPORT_SYMBOL_GPL(intel_scu_devices_destroy);
-
-static void __init install_irq_resource(struct platform_device *pdev, int irq)
-{
-	/* Single threaded */
-	static struct resource __initdata res = {
-		.name = "IRQ",
-		.flags = IORESOURCE_IRQ,
-	};
-	res.start = irq;
-	platform_device_add_resources(pdev, &res, 1);
-}
-
-static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
-					struct devs_id *dev)
-{
-	struct platform_device *pdev;
-	void *pdata = NULL;
-
-	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
-		pentry->name, pentry->irq);
-	pdata = dev->get_platform_data(pentry);
-
-	pdev = platform_device_alloc(pentry->name, 0);
-	if (pdev == NULL) {
-		pr_err("out of memory for SFI platform device '%s'.\n",
-			pentry->name);
-		return;
-	}
-	install_irq_resource(pdev, pentry->irq);
-
-	pdev->dev.platform_data = pdata;
-	platform_device_add(pdev);
-}
-
-static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
-					struct devs_id *dev)
-{
-	struct spi_board_info spi_info;
-	void *pdata = NULL;
-
-	memset(&spi_info, 0, sizeof(spi_info));
-	strncpy(spi_info.modalias, pentry->name, SFI_NAME_LEN);
-	spi_info.irq = ((pentry->irq == (u8)0xff) ? 0 : pentry->irq);
-	spi_info.bus_num = pentry->host_num;
-	spi_info.chip_select = pentry->addr;
-	spi_info.max_speed_hz = pentry->max_freq;
-	pr_debug("SPI bus=%d, name=%16.16s, irq=0x%2x, max_freq=%d, cs=%d\n",
-		spi_info.bus_num,
-		spi_info.modalias,
-		spi_info.irq,
-		spi_info.max_speed_hz,
-		spi_info.chip_select);
-
-	pdata = dev->get_platform_data(&spi_info);
-
-	spi_info.platform_data = pdata;
-	if (dev->delay)
-		intel_scu_spi_device_register(&spi_info);
-	else
-		spi_register_board_info(&spi_info, 1);
-}
-
-static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
-					struct devs_id *dev)
-{
-	struct i2c_board_info i2c_info;
-	void *pdata = NULL;
-
-	memset(&i2c_info, 0, sizeof(i2c_info));
-	strncpy(i2c_info.type, pentry->name, SFI_NAME_LEN);
-	i2c_info.irq = ((pentry->irq == (u8)0xff) ? 0 : pentry->irq);
-	i2c_info.addr = pentry->addr;
-	pr_debug("I2C bus = %d, name = %16.16s, irq = 0x%2x, addr = 0x%x\n",
-		pentry->host_num,
-		i2c_info.type,
-		i2c_info.irq,
-		i2c_info.addr);
-	pdata = dev->get_platform_data(&i2c_info);
-	i2c_info.platform_data = pdata;
-
-	if (dev->delay)
-		intel_scu_i2c_device_register(pentry->host_num, &i2c_info);
-	else
-		i2c_register_board_info(pentry->host_num, &i2c_info, 1);
-}
-
 static void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
 				struct devs_id *dev)
 {
@@ -934,89 +568,6 @@ static void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
 	intel_scu_device_register(pdev);
 }
 
-static struct devs_id __init *get_device_id(u8 type, char *name)
-{
-	struct devs_id *dev = device_ids;
-
-	if (device_ids == NULL)
-		return NULL;
-
-	while (dev->name[0]) {
-		if (dev->type == type &&
-			!strncmp(dev->name, name, SFI_NAME_LEN)) {
-			return dev;
-		}
-		dev++;
-	}
-
-	return NULL;
-}
-
-static int __init sfi_parse_devs(struct sfi_table_header *table)
-{
-	struct sfi_table_simple *sb;
-	struct sfi_device_table_entry *pentry;
-	struct devs_id *dev = NULL;
-	int num, i;
-	int ioapic;
-	struct io_apic_irq_attr irq_attr;
-
-	sb = (struct sfi_table_simple *)table;
-	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_device_table_entry);
-	pentry = (struct sfi_device_table_entry *)sb->pentry;
-
-	for (i = 0; i < num; i++, pentry++) {
-		int irq = pentry->irq;
-
-		if (irq != (u8)0xff) { /* native RTE case */
-			/* these SPI2 devices are not exposed to system as PCI
-			 * devices, but they have separate RTE entry in IOAPIC
-			 * so we have to enable them one by one here
-			 */
-			ioapic = mp_find_ioapic(irq);
-			irq_attr.ioapic = ioapic;
-			irq_attr.ioapic_pin = irq;
-			irq_attr.trigger = 1;
-			irq_attr.polarity = 1;
-			io_apic_set_pci_routing(NULL, irq, &irq_attr);
-		} else
-			irq = 0; /* No irq */
-
-		dev = get_device_id(pentry->type, pentry->name);
-
-		if ((dev == NULL) || (dev->get_platform_data == NULL))
-			continue;
-
-		if (dev->device_handler) {
-			dev->device_handler(pentry, dev);
-		} else {
-			switch (pentry->type) {
-			case SFI_DEV_TYPE_IPC:
-				sfi_handle_ipc_dev(pentry, dev);
-				break;
-			case SFI_DEV_TYPE_SPI:
-				sfi_handle_spi_dev(pentry, dev);
-				break;
-			case SFI_DEV_TYPE_I2C:
-				sfi_handle_i2c_dev(pentry, dev);
-				break;
-			case SFI_DEV_TYPE_UART:
-			case SFI_DEV_TYPE_HSI:
-			default:
-				break;
-			}
-		}
-	}
-	return 0;
-}
-
-static int __init intel_mid_platform_init(void)
-{
-	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio);
-	sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_devs);
-	return 0;
-}
-arch_initcall(intel_mid_platform_init);
 
 /*
  * we will search these buttons in SFI GPIO table (by name)
@@ -1078,4 +629,4 @@ static int __init pb_keys_init(void)
 	}
 	return 0;
 }
-late_initcall(pb_keys_init);
+late_initcall(pb_keys_init);
\ No newline at end of file
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
new file mode 100644
index 0000000..2f8196d
--- /dev/null
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -0,0 +1,485 @@
+/*
+ * intel_mid_sfi.c: Intel MID SFI initialization code
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/sfi.h>
+#include <linux/intel_pmic_gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/i2c.h>
+#include <linux/skbuff.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/mmc/core.h>
+#include <linux/mmc/card.h>
+#include <linux/blkdev.h>
+
+#include <asm/setup.h>
+#include <asm/mpspec_def.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
+#include <asm/io_apic.h>
+#include <asm/intel-mid.h>
+#include <asm/intel_mid_vrtc.h>
+#include <asm/io.h>
+#include <asm/i8259.h>
+#include <asm/intel_scu_ipc.h>
+#include <asm/apb_timer.h>
+#include <asm/reboot.h>
+#include "intel_mid_weak_decls.h"
+
+#define	SFI_SIG_OEM0	"OEM0"
+#define MAX_IPCDEVS	24
+#define MAX_SCU_SPI	24
+#define MAX_SCU_I2C	24
+
+static struct platform_device *ipc_devs[MAX_IPCDEVS];
+static struct spi_board_info *spi_devs[MAX_SCU_SPI];
+static struct i2c_board_info *i2c_devs[MAX_SCU_I2C];
+static struct sfi_gpio_table_entry *gpio_table;
+static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
+static int ipc_next_dev;
+static int spi_next_dev;
+static int i2c_next_dev;
+static int i2c_bus[MAX_SCU_I2C];
+static int gpio_num_entry;
+static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
+int sfi_mrtc_num;
+int sfi_mtimer_num;
+
+struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
+EXPORT_SYMBOL_GPL(sfi_mrtc_array);
+
+struct blocking_notifier_head intel_scu_notifier =
+			BLOCKING_NOTIFIER_INIT(intel_scu_notifier);
+EXPORT_SYMBOL_GPL(intel_scu_notifier);
+
+/* parse all the mtimer info to a static mtimer array */
+int __init sfi_parse_mtmr(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_timer_table_entry *pentry;
+	struct mpc_intsrc mp_irq;
+	int totallen;
+
+	sb = (struct sfi_table_simple *)table;
+	if (!sfi_mtimer_num) {
+		sfi_mtimer_num = SFI_GET_NUM_ENTRIES(sb,
+					struct sfi_timer_table_entry);
+		pentry = (struct sfi_timer_table_entry *) sb->pentry;
+		totallen = sfi_mtimer_num * sizeof(*pentry);
+		memcpy(sfi_mtimer_array, pentry, totallen);
+	}
+
+	pr_debug("SFI MTIMER info (num = %d):\n", sfi_mtimer_num);
+	pentry = sfi_mtimer_array;
+	for (totallen = 0; totallen < sfi_mtimer_num; totallen++, pentry++) {
+		pr_debug("timer[%d]: paddr = 0x%08x, freq = %dHz, irq = %d\n",
+			totallen, (u32)pentry->phys_addr,
+			pentry->freq_hz, pentry->irq);
+			if (!pentry->irq)
+				continue;
+			mp_irq.type = MP_INTSRC;
+			mp_irq.irqtype = mp_INT;
+/* triggering mode edge bit 2-3, active high polarity bit 0-1 */
+			mp_irq.irqflag = 5;
+			mp_irq.srcbus = MP_BUS_ISA;
+			mp_irq.srcbusirq = pentry->irq;	/* IRQ */
+			mp_irq.dstapic = MP_APIC_ALL;
+			mp_irq.dstirq = pentry->irq;
+			mp_save_irq(&mp_irq);
+	}
+
+	return 0;
+}
+
+struct sfi_timer_table_entry *sfi_get_mtmr(int hint)
+{
+	int i;
+	if (hint < sfi_mtimer_num) {
+		if (!sfi_mtimer_usage[hint]) {
+			pr_debug("hint taken for timer %d irq %d\n",
+				hint, sfi_mtimer_array[hint].irq);
+			sfi_mtimer_usage[hint] = 1;
+			return &sfi_mtimer_array[hint];
+		}
+	}
+	/* take the first timer available */
+	for (i = 0; i < sfi_mtimer_num;) {
+		if (!sfi_mtimer_usage[i]) {
+			sfi_mtimer_usage[i] = 1;
+			return &sfi_mtimer_array[i];
+		}
+		i++;
+	}
+	return NULL;
+}
+
+void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr)
+{
+	int i;
+	for (i = 0; i < sfi_mtimer_num;) {
+		if (mtmr->irq == sfi_mtimer_array[i].irq) {
+			sfi_mtimer_usage[i] = 0;
+			return;
+		}
+		i++;
+	}
+}
+
+/* parse all the mrtc info to a global mrtc array */
+int __init sfi_parse_mrtc(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_rtc_table_entry *pentry;
+	struct mpc_intsrc mp_irq;
+
+	int totallen;
+
+	sb = (struct sfi_table_simple *)table;
+	if (!sfi_mrtc_num) {
+		sfi_mrtc_num = SFI_GET_NUM_ENTRIES(sb,
+						struct sfi_rtc_table_entry);
+		pentry = (struct sfi_rtc_table_entry *)sb->pentry;
+		totallen = sfi_mrtc_num * sizeof(*pentry);
+		memcpy(sfi_mrtc_array, pentry, totallen);
+	}
+
+	pr_debug("SFI RTC info (num = %d):\n", sfi_mrtc_num);
+	pentry = sfi_mrtc_array;
+	for (totallen = 0; totallen < sfi_mrtc_num; totallen++, pentry++) {
+		pr_debug("RTC[%d]: paddr = 0x%08x, irq = %d\n",
+			totallen, (u32)pentry->phys_addr, pentry->irq);
+		mp_irq.type = MP_INTSRC;
+		mp_irq.irqtype = mp_INT;
+		mp_irq.irqflag = 0xf;	/* level trigger and active low */
+		mp_irq.srcbus = MP_BUS_ISA;
+		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
+		mp_irq.dstapic = MP_APIC_ALL;
+		mp_irq.dstirq = pentry->irq;
+		mp_save_irq(&mp_irq);
+	}
+	return 0;
+}
+
+
+/*
+ * Parsing GPIO table first, since the DEVS table will need this table
+ * to map the pin name to the actual pin.
+ */
+static int __init sfi_parse_gpio(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_gpio_table_entry *pentry;
+	int num, i;
+
+	if (gpio_table)
+		return 0;
+	sb = (struct sfi_table_simple *)table;
+	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
+	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
+
+	gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
+	if (!gpio_table)
+		return -1;
+	memcpy(gpio_table, pentry, num * sizeof(*pentry));
+	gpio_num_entry = num;
+
+	pr_debug("GPIO pin info:\n");
+	for (i = 0; i < num; i++, pentry++)
+		pr_debug("info[%2d]: controller = %16.16s, pin_name = %16.16s,"
+		" pin = %d\n", i,
+			pentry->controller_name,
+			pentry->pin_name,
+			pentry->pin_no);
+	return 0;
+}
+
+int get_gpio_by_name(const char *name)
+{
+	struct sfi_gpio_table_entry *pentry = gpio_table;
+	int i;
+
+	if (!pentry)
+		return -1;
+	for (i = 0; i < gpio_num_entry; i++, pentry++) {
+		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
+			return pentry->pin_no;
+	}
+	return -1;
+}
+
+void __init intel_scu_device_register(struct platform_device *pdev)
+{
+	if (ipc_next_dev == MAX_IPCDEVS)
+		pr_err("too many SCU IPC devices");
+	else
+		ipc_devs[ipc_next_dev++] = pdev;
+}
+
+static void __init intel_scu_spi_device_register(struct spi_board_info *sdev)
+{
+	struct spi_board_info *new_dev;
+
+	if (spi_next_dev == MAX_SCU_SPI) {
+		pr_err("too many SCU SPI devices");
+		return;
+	}
+
+	new_dev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	if (!new_dev) {
+		pr_err("failed to alloc mem for delayed spi dev %s\n",
+			sdev->modalias);
+		return;
+	}
+	memcpy(new_dev, sdev, sizeof(*sdev));
+
+	spi_devs[spi_next_dev++] = new_dev;
+}
+
+static void __init intel_scu_i2c_device_register(int bus,
+						struct i2c_board_info *idev)
+{
+	struct i2c_board_info *new_dev;
+
+	if (i2c_next_dev == MAX_SCU_I2C) {
+		pr_err("too many SCU I2C devices");
+		return;
+	}
+
+	new_dev = kzalloc(sizeof(*idev), GFP_KERNEL);
+	if (!new_dev) {
+		pr_err("failed to alloc mem for delayed i2c dev %s\n",
+			idev->type);
+		return;
+	}
+	memcpy(new_dev, idev, sizeof(*idev));
+
+	i2c_bus[i2c_next_dev] = bus;
+	i2c_devs[i2c_next_dev++] = new_dev;
+}
+
+/* Called by IPC driver */
+void intel_scu_devices_create(void)
+{
+	int i;
+
+	for (i = 0; i < ipc_next_dev; i++)
+		platform_device_add(ipc_devs[i]);
+
+	for (i = 0; i < spi_next_dev; i++)
+		spi_register_board_info(spi_devs[i], 1);
+
+	for (i = 0; i < i2c_next_dev; i++) {
+		struct i2c_adapter *adapter;
+		struct i2c_client *client;
+
+		adapter = i2c_get_adapter(i2c_bus[i]);
+		if (adapter) {
+			client = i2c_new_device(adapter, i2c_devs[i]);
+			if (!client)
+				pr_err("can't create i2c device %s\n",
+					i2c_devs[i]->type);
+		} else
+			i2c_register_board_info(i2c_bus[i], i2c_devs[i], 1);
+	}
+	intel_scu_notifier_post(SCU_AVAILABLE, NULL);
+}
+EXPORT_SYMBOL_GPL(intel_scu_devices_create);
+
+/* Called by IPC driver */
+void intel_scu_devices_destroy(void)
+{
+	int i;
+
+	intel_scu_notifier_post(SCU_DOWN, NULL);
+
+	for (i = 0; i < ipc_next_dev; i++)
+		platform_device_del(ipc_devs[i]);
+}
+EXPORT_SYMBOL_GPL(intel_scu_devices_destroy);
+
+static void __init install_irq_resource(struct platform_device *pdev, int irq)
+{
+	/* Single threaded */
+	static struct resource res __initdata = {
+		.name = "IRQ",
+		.flags = IORESOURCE_IRQ,
+	};
+	res.start = irq;
+	platform_device_add_resources(pdev, &res, 1);
+}
+
+static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
+					struct devs_id *dev)
+{
+	struct platform_device *pdev;
+	void *pdata = NULL;
+
+	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
+		pentry->name, pentry->irq);
+	pdata = dev->get_platform_data(pentry);
+
+	pdev = platform_device_alloc(pentry->name, 0);
+	if (pdev == NULL) {
+		pr_err("out of memory for SFI platform device '%s'.\n",
+			pentry->name);
+		return;
+	}
+	install_irq_resource(pdev, pentry->irq);
+
+	pdev->dev.platform_data = pdata;
+	platform_device_add(pdev);
+}
+
+static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
+					struct devs_id *dev)
+{
+	struct spi_board_info spi_info;
+	void *pdata = NULL;
+
+	memset(&spi_info, 0, sizeof(spi_info));
+	strncpy(spi_info.modalias, pentry->name, SFI_NAME_LEN);
+	spi_info.irq = ((pentry->irq == (u8)0xff) ? 0 : pentry->irq);
+	spi_info.bus_num = pentry->host_num;
+	spi_info.chip_select = pentry->addr;
+	spi_info.max_speed_hz = pentry->max_freq;
+	pr_debug("SPI bus=%d, name=%16.16s, irq=0x%2x, max_freq=%d, cs=%d\n",
+		spi_info.bus_num,
+		spi_info.modalias,
+		spi_info.irq,
+		spi_info.max_speed_hz,
+		spi_info.chip_select);
+
+	pdata = dev->get_platform_data(&spi_info);
+
+	spi_info.platform_data = pdata;
+	if (dev->delay)
+		intel_scu_spi_device_register(&spi_info);
+	else
+		spi_register_board_info(&spi_info, 1);
+}
+
+static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
+					struct devs_id *dev)
+{
+	struct i2c_board_info i2c_info;
+	void *pdata = NULL;
+
+	memset(&i2c_info, 0, sizeof(i2c_info));
+	strncpy(i2c_info.type, pentry->name, SFI_NAME_LEN);
+	i2c_info.irq = ((pentry->irq == (u8)0xff) ? 0 : pentry->irq);
+	i2c_info.addr = pentry->addr;
+	pr_debug("I2C bus = %d, name = %16.16s, irq = 0x%2x, addr = 0x%x\n",
+		pentry->host_num,
+		i2c_info.type,
+		i2c_info.irq,
+		i2c_info.addr);
+	pdata = dev->get_platform_data(&i2c_info);
+	i2c_info.platform_data = pdata;
+
+	if (dev->delay)
+		intel_scu_i2c_device_register(pentry->host_num, &i2c_info);
+	else
+		i2c_register_board_info(pentry->host_num, &i2c_info, 1);
+}
+
+static struct devs_id __init *get_device_id(u8 type, char *name)
+{
+	struct devs_id *dev = device_ids;
+
+	if (device_ids == NULL)
+		return NULL;
+
+	while (dev->name[0]) {
+		if (dev->type == type &&
+			!strncmp(dev->name, name, SFI_NAME_LEN)) {
+			return dev;
+		}
+		dev++;
+	}
+
+	return NULL;
+}
+
+static int __init sfi_parse_devs(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_device_table_entry *pentry;
+	struct devs_id *dev = NULL;
+	int num, i;
+	int ioapic;
+	struct io_apic_irq_attr irq_attr;
+
+	sb = (struct sfi_table_simple *)table;
+	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_device_table_entry);
+	pentry = (struct sfi_device_table_entry *)sb->pentry;
+
+	for (i = 0; i < num; i++, pentry++) {
+		int irq = pentry->irq;
+
+		if (irq != (u8)0xff) { /* native RTE case */
+			/* these SPI2 devices are not exposed to system as PCI
+			 * devices, but they have separate RTE entry in IOAPIC
+			 * so we have to enable them one by one here
+			 */
+			ioapic = mp_find_ioapic(irq);
+			irq_attr.ioapic = ioapic;
+			irq_attr.ioapic_pin = irq;
+			irq_attr.trigger = 1;
+			irq_attr.polarity = 1;
+			io_apic_set_pci_routing(NULL, irq, &irq_attr);
+		} else
+			irq = 0; /* No irq */
+
+		dev = get_device_id(pentry->type, pentry->name);
+
+		if ((dev == NULL) || (dev->get_platform_data == NULL))
+			continue;
+
+		if (dev->device_handler) {
+			dev->device_handler(pentry, dev);
+		} else {
+			switch (pentry->type) {
+			case SFI_DEV_TYPE_IPC:
+				sfi_handle_ipc_dev(pentry, dev);
+				break;
+			case SFI_DEV_TYPE_SPI:
+				sfi_handle_spi_dev(pentry, dev);
+				break;
+			case SFI_DEV_TYPE_I2C:
+				sfi_handle_i2c_dev(pentry, dev);
+				break;
+			case SFI_DEV_TYPE_UART:
+			case SFI_DEV_TYPE_HSI:
+			default:
+				break;
+			}
+		}
+	}
+	return 0;
+}
+
+static int __init intel_mid_platform_init(void)
+{
+	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio);
+	sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_devs);
+	return 0;
+}
+arch_initcall(intel_mid_platform_init);
