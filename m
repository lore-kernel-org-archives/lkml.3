Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaKGQzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:55:35 -0500
Received: from mail-bn1on0079.outbound.protection.outlook.com ([157.56.110.79]:3175
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751833AbaKGQzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:55:31 -0500
From: <tthayer@opensource.altera.com>
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@opensource.altera.com>,
        <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>
Subject: [PATCHv4 4/5] edac: altera: Add Altera L2 Cache and OCRAM EDAC Support
Date: Fri, 7 Nov 2014 10:54:21 -0600
Message-ID: <1415379263-12391-5-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415379263-12391-1-git-send-email-tthayer@opensource.altera.com>
References: <1415379263-12391-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: GRUPR80CA004.lamprd80.prod.outlook.com (10.242.28.14) To
 BN1PR03MB121.namprd03.prod.outlook.com (10.255.201.16)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB121;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(95666004)(76176999)(19580405001)(19580395003)(102836001)(40100003)(105586002)(106356001)(21056001)(107046002)(81156004)(77096003)(97736003)(101416001)(33646002)(62966003)(50226001)(4396001)(69596002)(48376002)(86152002)(93916002)(92566001)(77156002)(92726001)(86362001)(104166001)(2201001)(31966008)(20776003)(99396003)(64706001)(53416004)(120916001)(89996001)(42186005)(47776003)(50986999)(229853001)(66066001)(50466002)(88136002)(122386002)(46102003)(87286001)(87976001)(1121002)(921003)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB121;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

Adding L2 Cache and On-Chip RAM EDAC support for the
Altera SoCs using the EDAC device  model. The SDRAM
controller is using the Memory Controller model.

The SDRAM ECC is a separate Kconfig option because:
1) the SDRAM preparation can take almost 2 seconds on boot and some
customers need a faster boot time.
2) the SDRAM has an ECC initialization dependency on the preloader
which is outside the kernel. It is desirable to be able to turn the
SDRAM on & off separately.

Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
---
v2: Fix L2 dependency comments.

v3: Move OCRAM and L2 cache EDAC functions into altera_edac.c
    instead of separate files.

v4: Change mask defines to use BIT().
    Fix comment style to agree with kernel coding style.
    Better printk description for read != write in trigger.
    Remove SysFS debugging message.
    Better dci->mod_name
    Move gen_pool pointer assignment to end of function.
    Invert logic to reduce indent in ocram depenency check.
    Change from dev_err() to edac_printk()
    Replace magic numbers with defines & comments.
    Improve error injection test.
    Change Makefile intermediary name to altr (from alt)
---
 drivers/edac/Kconfig       |   14 ++
 drivers/edac/Makefile      |    5 +-
 drivers/edac/altera_edac.c |  481 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 498 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 1719975..b145a52 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -385,4 +385,18 @@ config EDAC_ALTERA_MC
 	  preloader must initialize the SDRAM before loading
 	  the kernel.
 
+config EDAC_ALTERA_L2C
+	bool "Altera L2 Cache EDAC"
+	depends on EDAC_MM_EDAC=y && ARCH_SOCFPGA && CACHE_L2X0
+	help
+	  Support for error detection and correction on the
+	  Altera L2 cache Memory for Altera SoCs.
+
+config EDAC_ALTERA_OCRAM
+	bool "Altera On-Chip RAM EDAC"
+	depends on EDAC_MM_EDAC=y && ARCH_SOCFPGA && SRAM && GENERIC_ALLOCATOR
+	help
+	  Support for error detection and correction on the
+	  Altera On-Chip RAM Memory for Altera SoCs.
+
 endif # EDAC
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 359aa49..20e9b6f 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -66,4 +66,7 @@ obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
 obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
 obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
 
-obj-$(CONFIG_EDAC_ALTERA_MC)		+= altera_edac.o
+altr_edac-y				:= altera_edac.o
+obj-$(CONFIG_EDAC_ALTERA_MC)		+= altr_edac.o
+obj-$(CONFIG_EDAC_ALTERA_L2C)		+= altr_edac.o
+obj-$(CONFIG_EDAC_ALTERA_OCRAM)		+= altr_edac.o
diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index 3c4929f..1655dd3 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -17,8 +17,10 @@
  * Adapted from the highbank_mc_edac driver.
  */
 
+#include <asm/cacheflush.h>
 #include <linux/ctype.h>
 #include <linux/edac.h>
+#include <linux/genalloc.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mfd/syscon.h>
@@ -33,6 +35,7 @@
 
 #define EDAC_MOD_STR		"altera_edac"
 #define EDAC_VERSION		"1"
+#define EDAC_DEVICE		"ALTR_MEM"
 
 /* SDRAM Controller CtrlCfg Register */
 #define CTLCFG_OFST             0x00
@@ -107,6 +110,35 @@ struct altr_sdram_mc_data {
 	struct regmap *mc_vbase;
 };
 
+/************************** EDAC Device Defines **************************/
+
+/* OCRAM ECC Management Group Defines */
+#define ALTR_MAN_GRP_OCRAM_ECC_OFFSET   0x04
+#define ALTR_OCR_ECC_EN_MASK            BIT(0)
+#define ALTR_OCR_ECC_INJS_MASK          BIT(1)
+#define ALTR_OCR_ECC_INJD_MASK          BIT(2)
+#define ALTR_OCR_ECC_SERR_MASK          BIT(3)
+#define ALTR_OCR_ECC_DERR_MASK          BIT(4)
+
+/* MPU L2 Register Defines */
+#define ALTR_MPUL2_CONTROL_OFFSET       0x100
+#define ALTR_MPUL2_CTL_CACHE_EN_MASK    BIT(0)
+
+/* L2 ECC Management Group Defines */
+#define ALTR_MAN_GRP_L2_ECC_OFFSET      0x00
+#define ALTR_L2_ECC_EN_MASK             BIT(0)
+#define ALTR_L2_ECC_INJS_MASK           BIT(1)
+#define ALTR_L2_ECC_INJD_MASK           BIT(2)
+
+#define ALTR_UE_TRIGGER_CHAR            'U'   /* Trigger for UE */
+#define ALTR_TRIGGER_READ_WRD_CNT       16    /* Line size x 2 */
+#define ALTR_TRIG_OCRAM_BYTE_SIZE       128   /* Line size x 4 */
+#define ALTR_TRIG_L2C_BYTE_SIZE         4096  /* Full Page */
+
+/*********************** EDAC Memory Controller Functions ****************/
+
+/* The SDRAM controller uses the EDAC Memory Controller framework.       */
+
 static irqreturn_t altr_sdram_mc_err_handler(int irq, void *dev_id)
 {
 	struct mem_ctl_info *mci = dev_id;
@@ -405,6 +437,453 @@ static struct platform_driver altr_sdram_edac_driver = {
 
 module_platform_driver(altr_sdram_edac_driver);
 
+/************************* EDAC Device Functions *************************/
+
+/*
+ * EDAC Device Functions (shared between various IPs).
+ * The discrete memories use the EDAC Device framework. The probe
+ * and error handling functions are very similar between memories
+ * so they are shared. The memory allocation and free for EDAC trigger
+ * testing are different for each memory.
+ */
+
+const struct edac_device_prv_data ocramecc_data;
+const struct edac_device_prv_data l2ecc_data;
+
+struct edac_device_prv_data {
+	int (*setup)(struct platform_device *pdev, void __iomem *base);
+	int ce_clear_mask;
+	int ue_clear_mask;
+#ifdef CONFIG_EDAC_DEBUG
+	struct edac_dev_sysfs_attribute *eccmgr_sysfs_attr;
+	void * (*alloc_mem)(size_t size, void **other);
+	void (*free_mem)(void *p, size_t size, void *other);
+	int ecc_enable_mask;
+	int ce_set_mask;
+	int ue_set_mask;
+	int trig_alloc_sz;
+#endif
+};
+
+struct altr_edac_device_dev {
+	void __iomem *base;
+	int sb_irq;
+	int db_irq;
+	const struct edac_device_prv_data *data;
+	char *edac_dev_name;
+};
+
+static irqreturn_t altr_edac_device_handler(int irq, void *dev_id)
+{
+	struct edac_device_ctl_info *dci = dev_id;
+	struct altr_edac_device_dev *drvdata = dci->pvt_info;
+	const struct edac_device_prv_data *priv = drvdata->data;
+
+	if (irq == drvdata->sb_irq) {
+		if (priv->ce_clear_mask)
+			writel(priv->ce_clear_mask, drvdata->base);
+		edac_device_handle_ce(dci, 0, 0, drvdata->edac_dev_name);
+	}
+	if (irq == drvdata->db_irq) {
+		if (priv->ue_clear_mask)
+			writel(priv->ue_clear_mask, drvdata->base);
+		edac_device_handle_ue(dci, 0, 0, drvdata->edac_dev_name);
+		panic("\nEDAC:ECC_DEVICE[Uncorrectable errors]\n");
+	}
+
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_EDAC_DEBUG
+ssize_t altr_edac_device_trig(struct edac_device_ctl_info *edac_dci,
+			      const char *buffer, size_t count)
+{
+	u32 *ptemp, i, error_mask;
+	int result = 0;
+	unsigned long flags;
+	struct altr_edac_device_dev *drvdata = edac_dci->pvt_info;
+	const struct edac_device_prv_data *priv = drvdata->data;
+	void *generic_ptr = edac_dci->dev;
+
+	if (!priv->alloc_mem)
+		return -ENOMEM;
+
+	/*
+	 * Note that generic_ptr is initialized to the device * but in
+	 * some alloc_functions, this is overridden and returns data.
+	 */
+	ptemp = priv->alloc_mem(priv->trig_alloc_sz, &generic_ptr);
+	if (!ptemp) {
+		edac_printk(KERN_ERR, EDAC_DEVICE,
+			    "Inject: Buffer Allocation error\n");
+		return -ENOMEM;
+	}
+
+	if (buffer[0] == ALTR_UE_TRIGGER_CHAR)
+		error_mask = priv->ue_set_mask;
+	else
+		error_mask = priv->ce_set_mask;
+
+	edac_printk(KERN_ALERT, EDAC_DEVICE,
+		    "Trigger Error Mask (0x%X)\n", error_mask);
+
+	local_irq_save(flags);
+	/* write ECC corrupted data out. */
+	for (i = 0; i < (priv->trig_alloc_sz/sizeof(*ptemp)); i++) {
+		/* Read data so we're in the correct state */
+		rmb();
+		if (ACCESS_ONCE(ptemp[i]))
+			result = -1;
+		/* Toggle Error bit (it is latched), leave ECC enabled */
+		writel(error_mask, drvdata->base);
+		writel(priv->ecc_enable_mask, drvdata->base);
+		ptemp[i] = i;
+	}
+	/* Ensure it has been written out */
+	wmb();
+	local_irq_restore(flags);
+
+	if (result)
+		edac_printk(KERN_ERR, EDAC_DEVICE, "Mem Not Cleared\n");
+
+	/* Read out written data. ECC error caused here */
+	for (i = 0; i < ALTR_TRIGGER_READ_WRD_CNT; i++)
+		if (ACCESS_ONCE(ptemp[i]) != i)
+			edac_printk(KERN_ERR, EDAC_DEVICE,
+				    "Read doesn't match written data\n");
+
+	if (priv->free_mem)
+		priv->free_mem(ptemp, priv->trig_alloc_sz, generic_ptr);
+
+	return count;
+}
+
+static void altr_set_sysfs_attr(struct edac_device_ctl_info *edac_dci,
+				const struct edac_device_prv_data *priv)
+{
+	struct edac_dev_sysfs_attribute *ecc_attr = priv->eccmgr_sysfs_attr;
+
+	if (ecc_attr)
+		edac_dci->sysfs_attributes = ecc_attr;
+}
+#else
+static void altr_set_sysfs_attr(struct edac_device_ctl_info *edac_dci,
+				const struct edac_device_prv_data *priv)
+{}
+#endif	/* #ifdef CONFIG_EDAC_DEBUG */
+
+static const struct of_device_id altr_edac_device_of_match[] = {
+#ifdef CONFIG_EDAC_ALTERA_L2C
+	{ .compatible = "altr,l2-edac", .data = (void *)&l2ecc_data },
+#endif
+#ifdef CONFIG_EDAC_ALTERA_OCRAM
+	{ .compatible = "altr,ocram-edac", .data = (void *)&ocramecc_data },
+#endif
+	{},
+};
+MODULE_DEVICE_TABLE(of, altr_edac_device_of_match);
+
+/*
+ * altr_edac_device_probe()
+ *	This is a generic EDAC device driver that will support
+ *	various Altera memory devices such as the L2 cache ECC and
+ *	OCRAM ECC as well as the memories for other peripherals.
+ *	Module specific initialization is done by passing the
+ *	function index in the device tree.
+ */
+static int altr_edac_device_probe(struct platform_device *pdev)
+{
+	struct edac_device_ctl_info *dci;
+	struct altr_edac_device_dev *drvdata;
+	struct resource *r;
+	int res = 0;
+	struct device_node *np = pdev->dev.of_node;
+	char *ecc_name = (char *)np->name;
+	static int dev_instance;
+
+	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL))
+		return -ENOMEM;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		edac_printk(KERN_ERR, EDAC_DEVICE,
+			    "Unable to get mem resource\n");
+		return -ENODEV;
+	}
+
+	if (!devm_request_mem_region(&pdev->dev, r->start, resource_size(r),
+				     dev_name(&pdev->dev))) {
+		edac_printk(KERN_ERR, EDAC_DEVICE,
+			    "%s:Error requesting mem region\n", ecc_name);
+		return -EBUSY;
+	}
+
+	dci = edac_device_alloc_ctl_info(sizeof(*drvdata), ecc_name,
+					 1, ecc_name, 1, 0, NULL, 0,
+					 dev_instance++);
+
+	if (!dci)
+		return -ENOMEM;
+
+	drvdata = dci->pvt_info;
+	dci->dev = &pdev->dev;
+	platform_set_drvdata(pdev, dci);
+	drvdata->edac_dev_name = ecc_name;
+
+	drvdata->base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
+	if (!drvdata->base) {
+		edac_printk(KERN_ERR, EDAC_DEVICE,
+			    "%s:Unable to map regs\n", ecc_name);
+		goto err;
+	}
+
+	/* Get driver specific data for this EDAC device */
+	drvdata->data = of_match_node(altr_edac_device_of_match, np)->data;
+
+	/* Check specific dependencies for the module */
+	if (drvdata->data->setup) {
+		res = drvdata->data->setup(pdev, drvdata->base);
+		if (res < 0)
+			goto err;
+	}
+
+	drvdata->sb_irq = platform_get_irq(pdev, 0);
+	res = devm_request_irq(&pdev->dev, drvdata->sb_irq,
+			       altr_edac_device_handler,
+			       0, dev_name(&pdev->dev), dci);
+	if (res < 0)
+		goto err;
+
+	drvdata->db_irq = platform_get_irq(pdev, 1);
+	res = devm_request_irq(&pdev->dev, drvdata->db_irq,
+			       altr_edac_device_handler,
+			       0, dev_name(&pdev->dev), dci);
+	if (res < 0)
+		goto err;
+
+	dci->mod_name = "Altera EDAC Memory";
+	dci->dev_name = drvdata->edac_dev_name;
+
+	altr_set_sysfs_attr(dci, drvdata->data);
+
+	if (edac_device_add_device(dci))
+		goto err;
+
+	devres_close_group(&pdev->dev, NULL);
+
+	return 0;
+err:
+	devres_release_group(&pdev->dev, NULL);
+	edac_device_free_ctl_info(dci);
+
+	return res;
+}
+
+static int altr_edac_device_remove(struct platform_device *pdev)
+{
+	struct edac_device_ctl_info *dci = platform_get_drvdata(pdev);
+
+	edac_device_del_device(&pdev->dev);
+	edac_device_free_ctl_info(dci);
+
+	return 0;
+}
+
+static struct platform_driver altr_edac_device_driver = {
+	.probe =  altr_edac_device_probe,
+	.remove = altr_edac_device_remove,
+	.driver = {
+		.name = "altr_edac_device",
+		.of_match_table = altr_edac_device_of_match,
+	},
+};
+module_platform_driver(altr_edac_device_driver);
+
+/*********************** OCRAM EDAC Device Functions *********************/
+
+#ifdef CONFIG_EDAC_ALTERA_OCRAM
+
+#ifdef CONFIG_EDAC_DEBUG
+static void *ocram_alloc_mem(size_t size, void **other)
+{
+	struct device_node *np;
+	struct gen_pool *gp;
+	void *sram_addr;
+
+	np = of_find_compatible_node(NULL, NULL, "altr,ocram-edac");
+	if (!np)
+		return NULL;
+
+	gp = of_get_named_gen_pool(np, "iram", 0);
+	if (!gp)
+		return NULL;
+
+	sram_addr = (void *)gen_pool_alloc(gp, size);
+	if (!sram_addr)
+		return NULL;
+
+	memset(sram_addr, 0, size);
+	wmb();	/* Ensure data is written out */
+
+	*other = gp;
+
+	return sram_addr;
+}
+
+static void ocram_free_mem(void *p, size_t size, void *other)
+{
+	gen_pool_free((struct gen_pool *)other, (u32)p, size);
+}
+
+static struct edac_dev_sysfs_attribute altr_ocr_sysfs_attributes[] = {
+	{
+		.attr = { .name = "altr_ocram_trigger",
+			  .mode = (S_IRUGO | S_IWUSR) },
+		.show = NULL,
+		.store = altr_edac_device_trig
+	},
+	{
+		.attr = {.name = NULL }
+	}
+};
+#endif	/* #ifdef CONFIG_EDAC_DEBUG */
+
+/*
+ * altr_ocram_dependencies()
+ *	Test for OCRAM cache ECC dependencies upon entry because
+ *	platform specific startup should have initialized the
+ *	On-Chip RAM memory and enabled the ECC.
+ *	Can't turn on ECC here because accessing un-initialized
+ *	memory will cause CE/UE errors possibly causing an ABORT.
+ */
+static int altr_ocram_dependencies(struct platform_device *pdev,
+				   void __iomem *base)
+{
+	u32 control;
+
+	control = readl(base) & ALTR_OCR_ECC_EN_MASK;
+	if (control)
+		return 0;
+
+	edac_printk(KERN_ERR, EDAC_DEVICE,
+		    "OCRAM: No ECC present or ECC disabled.\n");
+	return -ENODEV;
+}
+
+const struct edac_device_prv_data ocramecc_data = {
+	.setup = altr_ocram_dependencies,
+	.ce_clear_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_SERR_MASK),
+	.ue_clear_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_DERR_MASK),
+#ifdef CONFIG_EDAC_DEBUG
+	.eccmgr_sysfs_attr = altr_ocr_sysfs_attributes,
+	.alloc_mem = ocram_alloc_mem,
+	.free_mem = ocram_free_mem,
+	.ecc_enable_mask = ALTR_OCR_ECC_EN_MASK,
+	.ce_set_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_INJS_MASK),
+	.ue_set_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_INJD_MASK),
+	.trig_alloc_sz = ALTR_TRIG_OCRAM_BYTE_SIZE,
+#endif
+};
+
+#endif	/* #ifdef CONFIG_EDAC_ALTERA_OCRAM */
+
+/********************* L2 Cache EDAC Device Functions ********************/
+
+#ifdef CONFIG_EDAC_ALTERA_L2C
+
+#ifdef CONFIG_EDAC_DEBUG
+static void *l2_alloc_mem(size_t size, void **other)
+{
+	struct device *dev = *other;
+	void *ptemp = devm_kzalloc(dev, size, GFP_KERNEL);
+
+	if (!ptemp)
+		return NULL;
+
+	/* Make sure everything is written out */
+	wmb();
+	flush_cache_all();
+
+	return ptemp;
+}
+
+static void l2_free_mem(void *p, size_t size, void *other)
+{
+	struct device *dev = other;
+
+	if (dev && p)
+		devm_kfree(dev, p);
+}
+
+static struct edac_dev_sysfs_attribute altr_l2_sysfs_attributes[] = {
+	{
+		.attr = { .name = "altr_l2_trigger",
+			  .mode = (S_IRUGO | S_IWUSR) },
+		.show = NULL,
+		.store = altr_edac_device_trig
+	},
+	{
+		.attr = {.name = NULL }
+	}
+};
+#endif	/* #ifdef CONFIG_EDAC_DEBUG */
+
+/*
+ * altr_l2_dependencies()
+ *	Test for L2 cache ECC dependencies upon entry because
+ *	platform specific startup should have initialized the L2
+ *	memory and enabled the ECC.
+ *	Can't turn on ECC here because accessing un-initialized
+ *	memory will cause CE/UE errors possibly causing an ABORT.
+ *	Bail if ECC is not on.
+ *	Test For 1) L2 ECC is enabled and 2) L2 Cache is enabled.
+ */
+static int altr_l2_dependencies(struct platform_device *pdev,
+				void __iomem *base)
+{
+	u32 control;
+	struct regmap *l2_vbase;
+
+	control = readl(base) & ALTR_L2_ECC_EN_MASK;
+	if (!control) {
+		edac_printk(KERN_ERR, EDAC_DEVICE,
+			    "L2: No ECC present, or ECC disabled\n");
+		return -ENODEV;
+	}
+
+	l2_vbase = syscon_regmap_lookup_by_compatible("arm,pl310-cache");
+	if (IS_ERR(l2_vbase)) {
+		edac_printk(KERN_ERR, EDAC_DEVICE,
+			    "L2:regmap for arm,pl310-cache lookup failed.\n");
+		return -ENODEV;
+	}
+
+	regmap_read(l2_vbase, ALTR_MPUL2_CONTROL_OFFSET, &control);
+	if (!(control & ALTR_MPUL2_CTL_CACHE_EN_MASK)) {
+		edac_printk(KERN_ERR, EDAC_DEVICE, "L2: Cache disabled\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+const struct edac_device_prv_data l2ecc_data = {
+	.setup = altr_l2_dependencies,
+	.ce_clear_mask = 0,
+	.ue_clear_mask = 0,
+#ifdef CONFIG_EDAC_DEBUG
+	.eccmgr_sysfs_attr = altr_l2_sysfs_attributes,
+	.alloc_mem = l2_alloc_mem,
+	.free_mem = l2_free_mem,
+	.ecc_enable_mask = ALTR_L2_ECC_EN_MASK,
+	.ce_set_mask = (ALTR_L2_ECC_EN_MASK | ALTR_L2_ECC_INJS_MASK),
+	.ue_set_mask = (ALTR_L2_ECC_EN_MASK | ALTR_L2_ECC_INJD_MASK),
+	.trig_alloc_sz = ALTR_TRIG_L2C_BYTE_SIZE,
+#endif
+};
+
+#endif	/* #ifdef CONFIG_EDAC_ALTERA_L2C */
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Thor Thayer");
-MODULE_DESCRIPTION("EDAC Driver for Altera SDRAM Controller");
+MODULE_DESCRIPTION("EDAC Driver for Altera Memories");
-- 
1.7.9.5

