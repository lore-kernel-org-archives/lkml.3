Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3LCTrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:47:09 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65507 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3LCTrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:47:04 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] staging: octeon-usb: Probe via device tree populated platform device.
Date: Tue,  3 Dec 2013 11:46:52 -0800
Message-Id: <1386100012-6077-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386100012-6077-1-git-send-email-ddaney.cavm@gmail.com>
References: <1386100012-6077-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Extract clocking parameters from the device tree, and remove now dead
code and types.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c | 273 ++++++++++++++------------------
 1 file changed, 116 insertions(+), 157 deletions(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index d118952..c53499a 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -275,13 +275,6 @@ enum cvmx_usb_pipe_flags {
  */
 #define MAX_TRANSFER_PACKETS	((1<<10)-1)
 
-enum {
-	USB_CLOCK_TYPE_REF_12,
-	USB_CLOCK_TYPE_REF_24,
-	USB_CLOCK_TYPE_REF_48,
-	USB_CLOCK_TYPE_CRYSTAL_12,
-};
-
 /**
  * Logical transactions may take numerous low level
  * transactions, especially when splits are concerned. This
@@ -471,19 +464,6 @@ struct octeon_hcd {
 /* Returns the IO address to push/pop stuff data from the FIFOs */
 #define USB_FIFO_ADDRESS(channel, usb_index) (CVMX_USBCX_GOTGCTL(usb_index) + ((channel)+1)*0x1000)
 
-static int octeon_usb_get_clock_type(void)
-{
-	switch (cvmx_sysinfo_get()->board_type) {
-	case CVMX_BOARD_TYPE_BBGW_REF:
-	case CVMX_BOARD_TYPE_LANAI2_A:
-	case CVMX_BOARD_TYPE_LANAI2_U:
-	case CVMX_BOARD_TYPE_LANAI2_G:
-	case CVMX_BOARD_TYPE_UBNT_E100:
-		return USB_CLOCK_TYPE_CRYSTAL_12;
-	}
-	return USB_CLOCK_TYPE_REF_48;
-}
-
 /**
  * Read a USB 32bit CSR. It performs the necessary address swizzle
  * for 32bit CSRs and logs the value in a readable format if
@@ -582,37 +562,6 @@ static inline int __cvmx_usb_get_data_pid(struct cvmx_usb_pipe *pipe)
 		return 0; /* Data0 */
 }
 
-
-/**
- * Return the number of USB ports supported by this Octeon
- * chip. If the chip doesn't support USB, or is not supported
- * by this API, a zero will be returned. Most Octeon chips
- * support one usb port, but some support two ports.
- * cvmx_usb_initialize() must be called on independent
- * struct cvmx_usb_state.
- *
- * Returns: Number of port, zero if usb isn't supported
- */
-static int cvmx_usb_get_num_ports(void)
-{
-	int arch_ports = 0;
-
-	if (OCTEON_IS_MODEL(OCTEON_CN56XX))
-		arch_ports = 1;
-	else if (OCTEON_IS_MODEL(OCTEON_CN52XX))
-		arch_ports = 2;
-	else if (OCTEON_IS_MODEL(OCTEON_CN50XX))
-		arch_ports = 1;
-	else if (OCTEON_IS_MODEL(OCTEON_CN31XX))
-		arch_ports = 1;
-	else if (OCTEON_IS_MODEL(OCTEON_CN30XX))
-		arch_ports = 1;
-	else
-		arch_ports = 0;
-
-	return arch_ports;
-}
-
 /**
  * Initialize a USB port for use. This must be called before any
  * other access to the Octeon USB port is made. The port starts
@@ -628,41 +577,16 @@ static int cvmx_usb_get_num_ports(void)
  * Returns: 0 or a negative error code.
  */
 static int cvmx_usb_initialize(struct cvmx_usb_state *usb,
-			       int usb_port_number)
+			       int usb_port_number,
+			       enum cvmx_usb_initialize_flags flags)
 {
 	union cvmx_usbnx_clk_ctl usbn_clk_ctl;
 	union cvmx_usbnx_usbp_ctl_status usbn_usbp_ctl_status;
-	enum cvmx_usb_initialize_flags flags = 0;
 	int i;
 
 	/* At first allow 0-1 for the usb port number */
 	if ((usb_port_number < 0) || (usb_port_number > 1))
 		return -EINVAL;
-	/* For all chips except 52XX there is only one port */
-	if (!OCTEON_IS_MODEL(OCTEON_CN52XX) && (usb_port_number > 0))
-		return -EINVAL;
-	/* Try to determine clock type automatically */
-	if (octeon_usb_get_clock_type() == USB_CLOCK_TYPE_CRYSTAL_12) {
-		/* Only 12 MHZ crystals are supported */
-		flags |= CVMX_USB_INITIALIZE_FLAGS_CLOCK_XO_XI;
-	} else {
-		flags |= CVMX_USB_INITIALIZE_FLAGS_CLOCK_XO_GND;
-
-		switch (octeon_usb_get_clock_type()) {
-		case USB_CLOCK_TYPE_REF_12:
-			flags |= CVMX_USB_INITIALIZE_FLAGS_CLOCK_12MHZ;
-			break;
-		case USB_CLOCK_TYPE_REF_24:
-			flags |= CVMX_USB_INITIALIZE_FLAGS_CLOCK_24MHZ;
-			break;
-		case USB_CLOCK_TYPE_REF_48:
-			flags |= CVMX_USB_INITIALIZE_FLAGS_CLOCK_48MHZ;
-			break;
-		default:
-			return -EINVAL;
-			break;
-		}
-	}
 
 	memset(usb, 0, sizeof(*usb));
 	usb->init_flags = flags;
@@ -3431,7 +3355,6 @@ static int octeon_usb_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	return 0;
 }
 
-
 static const struct hc_driver octeon_hc_driver = {
 	.description		= "Octeon USB",
 	.product_desc		= "Octeon Host Controller",
@@ -3448,15 +3371,74 @@ static const struct hc_driver octeon_hc_driver = {
 	.hub_control		= octeon_usb_hub_control,
 };
 
-
-static int octeon_usb_driver_probe(struct device *dev)
+static int octeon_usb_probe(struct platform_device *pdev)
 {
 	int status;
-	int usb_num = to_platform_device(dev)->id;
-	int irq = platform_get_irq(to_platform_device(dev), 0);
+	int initialize_flags;
+	int usb_num;
+	struct resource *res_mem;
+	struct device_node *usbn_node;
+	int irq = platform_get_irq(pdev, 0);
+	struct device *dev = &pdev->dev;
 	struct octeon_hcd *priv;
 	struct usb_hcd *hcd;
 	unsigned long flags;
+	u32 clock_rate = 48000000;
+	bool is_crystal_clock = false;
+	const char *clock_type;
+	int i;
+
+	if (dev->of_node == NULL) {
+		dev_err(dev, "Error: empty of_node\n");
+		return -ENXIO;
+	}
+	usbn_node = dev->of_node->parent;
+
+	i = of_property_read_u32(usbn_node,
+				 "refclk-frequency", &clock_rate);
+	if (i) {
+		dev_err(dev, "No USBN \"refclk-frequency\"\n");
+		return -ENXIO;
+	}
+	switch (clock_rate) {
+	case 12000000:
+		initialize_flags = CVMX_USB_INITIALIZE_FLAGS_CLOCK_12MHZ;
+		break;
+	case 24000000:
+		initialize_flags = CVMX_USB_INITIALIZE_FLAGS_CLOCK_24MHZ;
+		break;
+	case 48000000:
+		initialize_flags = CVMX_USB_INITIALIZE_FLAGS_CLOCK_48MHZ;
+		break;
+	default:
+		dev_err(dev, "Illebal USBN \"refclk-frequency\" %u\n", clock_rate);
+		return -ENXIO;
+
+	}
+
+	i = of_property_read_string(usbn_node,
+				    "refclk-type", &clock_type);
+
+	if (!i && strcmp("crystal", clock_type) == 0)
+		is_crystal_clock = true;
+
+	if (is_crystal_clock)
+		initialize_flags |= CVMX_USB_INITIALIZE_FLAGS_CLOCK_XO_XI;
+	else
+		initialize_flags |= CVMX_USB_INITIALIZE_FLAGS_CLOCK_XO_GND;
+
+	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res_mem == NULL) {
+		dev_err(dev, "found no memory resource\n");
+		return -ENXIO;
+	}
+	usb_num = (res_mem->start >> 44) & 1;
+
+	if (irq < 0) {
+		/* Defective device tree, but we know how to fix it. */
+		irq_hw_number_t hwirq = usb_num ? (1 << 6) + 17 : 56;
+		irq = irq_create_mapping(NULL, hwirq);
+	}
 
 	/*
 	 * Set the DMA mask to 64bits so we get buffers already translated for
@@ -3465,6 +3447,26 @@ static int octeon_usb_driver_probe(struct device *dev)
 	dev->coherent_dma_mask = ~0;
 	dev->dma_mask = &dev->coherent_dma_mask;
 
+	/*
+	 * Only cn52XX and cn56XX have DWC_OTG USB hardware and the
+	 * IOB priority registers.  Under heavy network load USB
+	 * hardware can be starved by the IOB causing a crash.  Give
+	 * it a priority boost if it has been waiting more than 400
+	 * cycles to avoid this situation.
+	 *
+	 * Testing indicates that a cnt_val of 8192 is not sufficient,
+	 * but no failures are seen with 4096.  We choose a value of
+	 * 400 to give a safety factor of 10.
+	 */
+	if (OCTEON_IS_MODEL(OCTEON_CN52XX) || OCTEON_IS_MODEL(OCTEON_CN56XX)) {
+		union cvmx_iob_n2c_l2c_pri_cnt pri_cnt;
+
+		pri_cnt.u64 = 0;
+		pri_cnt.s.cnt_enb = 1;
+		pri_cnt.s.cnt_val = 400;
+		cvmx_write_csr(CVMX_IOB_N2C_L2C_PRI_CNT, pri_cnt.u64);
+	}
+
 	hcd = usb_create_hcd(&octeon_hc_driver, dev, dev_name(dev));
 	if (!hcd) {
 		dev_dbg(dev, "Failed to allocate memory for HCD\n");
@@ -3478,7 +3480,7 @@ static int octeon_usb_driver_probe(struct device *dev)
 	tasklet_init(&priv->dequeue_tasklet, octeon_usb_urb_dequeue_work, (unsigned long)priv);
 	INIT_LIST_HEAD(&priv->dequeue_list);
 
-	status = cvmx_usb_initialize(&priv->usb, usb_num);
+	status = cvmx_usb_initialize(&priv->usb, usb_num, initialize_flags);
 	if (status) {
 		dev_dbg(dev, "USB initialization failed with %d\n", status);
 		kfree(hcd);
@@ -3492,21 +3494,22 @@ static int octeon_usb_driver_probe(struct device *dev)
 	cvmx_usb_poll(&priv->usb);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	status = usb_add_hcd(hcd, irq, IRQF_SHARED);
+	status = usb_add_hcd(hcd, irq, 0);
 	if (status) {
 		dev_dbg(dev, "USB add HCD failed with %d\n", status);
 		kfree(hcd);
 		return -1;
 	}
 
-	dev_dbg(dev, "Registered HCD for port %d on irq %d\n", usb_num, irq);
+	dev_info(dev, "Registered HCD for port %d on irq %d\n", usb_num, irq);
 
 	return 0;
 }
 
-static int octeon_usb_driver_remove(struct device *dev)
+static int octeon_usb_remove(struct platform_device *pdev)
 {
 	int status;
+	struct device *dev = &pdev->dev;
 	struct usb_hcd *hcd = dev_get_drvdata(dev);
 	struct octeon_hcd *priv = hcd_to_octeon(hcd);
 	unsigned long flags;
@@ -3524,85 +3527,41 @@ static int octeon_usb_driver_remove(struct device *dev)
 	return 0;
 }
 
-static struct device_driver octeon_usb_driver = {
-	.name	= "OcteonUSB",
-	.bus	= &platform_bus_type,
-	.probe	= octeon_usb_driver_probe,
-	.remove	= octeon_usb_driver_remove,
+static struct of_device_id octeon_usb_match[] = {
+	{
+		.compatible = "cavium,octeon-5750-usbc",
+	},
+	{},
 };
 
+static struct platform_driver octeon_usb_driver = {
+	.driver = {
+		.name       = "OcteonUSB",
+		.owner		= THIS_MODULE,
+		.of_match_table = octeon_usb_match,
+	},
+	.probe      = octeon_usb_probe,
+	.remove     = octeon_usb_remove,
+};
 
-#define MAX_USB_PORTS   10
-static struct platform_device *pdev_glob[MAX_USB_PORTS];
-static int octeon_usb_registered;
-static int __init octeon_usb_module_init(void)
+static int __init octeon_usb_driver_init(void)
 {
-	int num_devices = cvmx_usb_get_num_ports();
-	int device;
-
-	if (usb_disabled() || num_devices == 0)
-		return -ENODEV;
-
-	if (driver_register(&octeon_usb_driver))
-		return -ENOMEM;
-
-	octeon_usb_registered = 1;
-
-	/*
-	 * Only cn52XX and cn56XX have DWC_OTG USB hardware and the
-	 * IOB priority registers.  Under heavy network load USB
-	 * hardware can be starved by the IOB causing a crash.  Give
-	 * it a priority boost if it has been waiting more than 400
-	 * cycles to avoid this situation.
-	 *
-	 * Testing indicates that a cnt_val of 8192 is not sufficient,
-	 * but no failures are seen with 4096.  We choose a value of
-	 * 400 to give a safety factor of 10.
-	 */
-	if (OCTEON_IS_MODEL(OCTEON_CN52XX) || OCTEON_IS_MODEL(OCTEON_CN56XX)) {
-		union cvmx_iob_n2c_l2c_pri_cnt pri_cnt;
-
-		pri_cnt.u64 = 0;
-		pri_cnt.s.cnt_enb = 1;
-		pri_cnt.s.cnt_val = 400;
-		cvmx_write_csr(CVMX_IOB_N2C_L2C_PRI_CNT, pri_cnt.u64);
-	}
-
-	for (device = 0; device < num_devices; device++) {
-		struct resource irq_resource;
-		struct platform_device *pdev;
-		memset(&irq_resource, 0, sizeof(irq_resource));
-		irq_resource.start = (device == 0) ? OCTEON_IRQ_USB0 : OCTEON_IRQ_USB1;
-		irq_resource.end = irq_resource.start;
-		irq_resource.flags = IORESOURCE_IRQ;
-		pdev = platform_device_register_simple((char *)octeon_usb_driver.  name, device, &irq_resource, 1);
-		if (IS_ERR(pdev)) {
-			driver_unregister(&octeon_usb_driver);
-			octeon_usb_registered = 0;
-			return PTR_ERR(pdev);
-		}
-		if (device < MAX_USB_PORTS)
-			pdev_glob[device] = pdev;
+	if (usb_disabled())
+		return 0;
 
-	}
-	return 0;
+	return platform_driver_register(&octeon_usb_driver);
 }
+module_init(octeon_usb_driver_init);
 
-static void __exit octeon_usb_module_cleanup(void)
+static void __exit octeon_usb_driver_exit(void)
 {
-	int i;
+	if (usb_disabled())
+		return;
 
-	for (i = 0; i < MAX_USB_PORTS; i++)
-		if (pdev_glob[i]) {
-			platform_device_unregister(pdev_glob[i]);
-			pdev_glob[i] = NULL;
-		}
-	if (octeon_usb_registered)
-		driver_unregister(&octeon_usb_driver);
+	platform_driver_unregister(&octeon_usb_driver);
 }
+module_exit(octeon_usb_driver_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Cavium Networks <support@caviumnetworks.com>");
-MODULE_DESCRIPTION("Cavium Networks Octeon USB Host driver.");
-module_init(octeon_usb_module_init);
-module_exit(octeon_usb_module_cleanup);
+MODULE_AUTHOR("Cavium, Inc. <support@cavium.com>");
+MODULE_DESCRIPTION("Cavium Inc. OCTEON USB Host driver.");
-- 
1.7.11.7

