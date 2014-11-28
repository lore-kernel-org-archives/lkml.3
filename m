Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaK1Nv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:51:27 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:49862 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaK1NvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:22 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/17] net2280: Improve patching of defect 7374
Date: Fri, 28 Nov 2014 14:50:57 +0100
Message-Id: <1417182662-7405-13-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once the defect 7374 is patched, there is no reason the keep reading the
idx scratch register.

Cache the content of the scratch idx register on device flag.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 153 +++++++++++++++++----------------------
 drivers/usb/gadget/udc/net2280.h |   3 +-
 2 files changed, 68 insertions(+), 88 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index ade4693..d4255f9 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -1765,76 +1765,73 @@ static void defect7374_disable_data_eps(struct net2280 *dev)
 static void defect7374_enable_data_eps_zero(struct net2280 *dev)
 {
 	u32 tmp = 0, tmp_reg;
-	u32 fsmvalue, scratch;
+	u32 scratch;
 	int i;
 	unsigned char ep_sel;
 
 	scratch = get_idx_reg(dev->regs, SCRATCH);
-	fsmvalue = scratch & (0xf << DEFECT7374_FSM_FIELD);
+
+	WARN_ON((scratch & (0xf << DEFECT7374_FSM_FIELD))
+		== DEFECT7374_FSM_SS_CONTROL_READ);
+
 	scratch &= ~(0xf << DEFECT7374_FSM_FIELD);
 
-	/*See if firmware needs to set up for workaround*/
-	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ) {
-		ep_warn(dev, "Operate Defect 7374 workaround soft this time");
-		ep_warn(dev, "It will operate on cold-reboot and SS connect");
-
-		/*GPEPs:*/
-		tmp = ((0 << ENDPOINT_NUMBER) | BIT(ENDPOINT_DIRECTION) |
-		       (2 << OUT_ENDPOINT_TYPE) | (2 << IN_ENDPOINT_TYPE) |
-		       ((dev->enhanced_mode) ?
-		       BIT(OUT_ENDPOINT_ENABLE) : BIT(ENDPOINT_ENABLE)) |
-		       BIT(IN_ENDPOINT_ENABLE));
-
-		for (i = 1; i < 5; i++)
-			writel(tmp, &dev->ep[i].cfg->ep_cfg);
-
-		/* CSRIN, PCIIN, STATIN, RCIN*/
-		tmp = ((0 << ENDPOINT_NUMBER) | BIT(ENDPOINT_ENABLE));
-		writel(tmp, &dev->dep[1].dep_cfg);
-		writel(tmp, &dev->dep[3].dep_cfg);
-		writel(tmp, &dev->dep[4].dep_cfg);
-		writel(tmp, &dev->dep[5].dep_cfg);
-
-		/*Implemented for development and debug.
-		 * Can be refined/tuned later.*/
-		for (ep_sel = 0; ep_sel <= 21; ep_sel++) {
-			/* Select an endpoint for subsequent operations: */
-			tmp_reg = readl(&dev->plregs->pl_ep_ctrl);
-			writel(((tmp_reg & ~0x1f) | ep_sel),
-			       &dev->plregs->pl_ep_ctrl);
-
-			if (ep_sel == 1) {
-				tmp =
-				    (readl(&dev->plregs->pl_ep_ctrl) |
-				     BIT(CLEAR_ACK_ERROR_CODE) | 0);
-				writel(tmp, &dev->plregs->pl_ep_ctrl);
-				continue;
-			}
+	ep_warn(dev, "Operate Defect 7374 workaround soft this time");
+	ep_warn(dev, "It will operate on cold-reboot and SS connect");
 
-			if (ep_sel == 0 || (ep_sel > 9 && ep_sel < 14) ||
-					ep_sel == 18  || ep_sel == 20)
-				continue;
+	/*GPEPs:*/
+	tmp = ((0 << ENDPOINT_NUMBER) | BIT(ENDPOINT_DIRECTION) |
+			(2 << OUT_ENDPOINT_TYPE) | (2 << IN_ENDPOINT_TYPE) |
+			((dev->enhanced_mode) ?
+			 BIT(OUT_ENDPOINT_ENABLE) : BIT(ENDPOINT_ENABLE)) |
+			BIT(IN_ENDPOINT_ENABLE));
 
-			tmp = (readl(&dev->plregs->pl_ep_cfg_4) |
-				 BIT(NON_CTRL_IN_TOLERATE_BAD_DIR) | 0);
-			writel(tmp, &dev->plregs->pl_ep_cfg_4);
+	for (i = 1; i < 5; i++)
+		writel(tmp, &dev->ep[i].cfg->ep_cfg);
 
-			tmp = readl(&dev->plregs->pl_ep_ctrl) &
-				~BIT(EP_INITIALIZED);
-			writel(tmp, &dev->plregs->pl_ep_ctrl);
+	/* CSRIN, PCIIN, STATIN, RCIN*/
+	tmp = ((0 << ENDPOINT_NUMBER) | BIT(ENDPOINT_ENABLE));
+	writel(tmp, &dev->dep[1].dep_cfg);
+	writel(tmp, &dev->dep[3].dep_cfg);
+	writel(tmp, &dev->dep[4].dep_cfg);
+	writel(tmp, &dev->dep[5].dep_cfg);
 
+	/*Implemented for development and debug.
+	 * Can be refined/tuned later.*/
+	for (ep_sel = 0; ep_sel <= 21; ep_sel++) {
+		/* Select an endpoint for subsequent operations: */
+		tmp_reg = readl(&dev->plregs->pl_ep_ctrl);
+		writel(((tmp_reg & ~0x1f) | ep_sel),
+				&dev->plregs->pl_ep_ctrl);
+
+		if (ep_sel == 1) {
+			tmp =
+				(readl(&dev->plregs->pl_ep_ctrl) |
+				 BIT(CLEAR_ACK_ERROR_CODE) | 0);
+			writel(tmp, &dev->plregs->pl_ep_ctrl);
+			continue;
 		}
 
-		/* Set FSM to focus on the first Control Read:
-		 * - Tip: Connection speed is known upon the first
-		 * setup request.*/
-		scratch |= DEFECT7374_FSM_WAITING_FOR_CONTROL_READ;
-		set_idx_reg(dev->regs, SCRATCH, scratch);
+		if (ep_sel == 0 || (ep_sel > 9 && ep_sel < 14) ||
+				ep_sel == 18  || ep_sel == 20)
+			continue;
+
+		tmp = (readl(&dev->plregs->pl_ep_cfg_4) |
+				BIT(NON_CTRL_IN_TOLERATE_BAD_DIR) | 0);
+		writel(tmp, &dev->plregs->pl_ep_cfg_4);
+
+		tmp = readl(&dev->plregs->pl_ep_ctrl) &
+			~BIT(EP_INITIALIZED);
+		writel(tmp, &dev->plregs->pl_ep_ctrl);
 
-	} else{
-		ep_warn(dev, "Defect 7374 workaround soft will NOT operate");
-		ep_warn(dev, "It will operate on cold-reboot and SS connect");
 	}
+
+	/* Set FSM to focus on the first Control Read:
+	 * - Tip: Connection speed is known upon the first
+	 * setup request.*/
+	scratch |= DEFECT7374_FSM_WAITING_FOR_CONTROL_READ;
+	set_idx_reg(dev->regs, SCRATCH, scratch);
+
 }
 
 /* keeping it simple:
@@ -1885,21 +1882,13 @@ static void usb_reset_228x(struct net2280 *dev)
 static void usb_reset_338x(struct net2280 *dev)
 {
 	u32 tmp;
-	u32 fsmvalue;
 
 	dev->gadget.speed = USB_SPEED_UNKNOWN;
 	(void)readl(&dev->usb->usbctl);
 
 	net2280_led_init(dev);
 
-	fsmvalue = get_idx_reg(dev->regs, SCRATCH) &
-			(0xf << DEFECT7374_FSM_FIELD);
-
-	/* See if firmware needs to set up for workaround: */
-	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ) {
-		ep_info(dev, "%s: Defect 7374 FsmValue 0x%08x\n", __func__,
-		     fsmvalue);
-	} else {
+	if (dev->bug7734_patched) {
 		/* disable automatic responses, and irqs */
 		writel(0, &dev->usb->stdrsp);
 		writel(0, &dev->regs->pciirqenb0);
@@ -1916,7 +1905,7 @@ static void usb_reset_338x(struct net2280 *dev)
 
 	writel(~0, &dev->regs->irqstat0), writel(~0, &dev->regs->irqstat1);
 
-	if (fsmvalue == DEFECT7374_FSM_SS_CONTROL_READ) {
+	if (dev->bug7734_patched) {
 		/* reset, and enable pci */
 		tmp = readl(&dev->regs->devinit) |
 		    BIT(PCI_ENABLE) |
@@ -1982,7 +1971,6 @@ static void usb_reinit_338x(struct net2280 *dev)
 {
 	int i;
 	u32 tmp, val;
-	u32 fsmvalue;
 	static const u32 ne[9] = { 0, 1, 2, 3, 4, 1, 2, 3, 4 };
 	static const u32 ep_reg_addr[9] = { 0x00, 0xC0, 0x00, 0xC0, 0x00,
 						0x00, 0xC0, 0x00, 0xC0 };
@@ -2020,14 +2008,7 @@ static void usb_reinit_338x(struct net2280 *dev)
 	dev->ep[0].stopped = 0;
 
 	/* Link layer set up */
-	fsmvalue = get_idx_reg(dev->regs, SCRATCH) &
-				(0xf << DEFECT7374_FSM_FIELD);
-
-	/* See if driver needs to set up for workaround: */
-	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ)
-		ep_info(dev, "%s: Defect 7374 FsmValue %08x\n",
-						__func__, fsmvalue);
-	else {
+	if (dev->bug7734_patched) {
 		tmp = readl(&dev->usb_ext->usbctl2) &
 		    ~(BIT(U1_ENABLE) | BIT(U2_ENABLE) | BIT(LTM_ENABLE));
 		writel(tmp, &dev->usb_ext->usbctl2);
@@ -2134,15 +2115,8 @@ static void ep0_start_228x(struct net2280 *dev)
 
 static void ep0_start_338x(struct net2280 *dev)
 {
-	u32 fsmvalue;
 
-	fsmvalue = get_idx_reg(dev->regs, SCRATCH) &
-			(0xf << DEFECT7374_FSM_FIELD);
-
-	if (fsmvalue != DEFECT7374_FSM_SS_CONTROL_READ)
-		ep_info(dev, "%s: Defect 7374 FsmValue %08x\n", __func__,
-		     fsmvalue);
-	else
+	if (dev->bug7734_patched)
 		writel(BIT(CLEAR_NAK_OUT_PACKETS_MODE) |
 		       BIT(SET_EP_HIDE_STATUS_PHASE),
 		       &dev->epregs[0].ep_rsp);
@@ -2230,7 +2204,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 	 */
 	net2280_led_active(dev, 1);
 
-	if (dev->quirks & PLX_SUPERSPEED)
+	if ((dev->quirks & PLX_SUPERSPEED) && !dev->bug7734_patched)
 		defect7374_enable_data_eps_zero(dev);
 
 	ep0_start(dev);
@@ -2552,6 +2526,7 @@ static void defect7374_workaround(struct net2280 *dev, struct usb_ctrlrequest r)
 		 * run after the next USB connection.
 		 */
 		scratch |= DEFECT7374_FSM_NON_SS_CONTROL_READ;
+		dev->bug7734_patched = 1;
 		goto restore_data_eps;
 	}
 
@@ -2565,6 +2540,7 @@ static void defect7374_workaround(struct net2280 *dev, struct usb_ctrlrequest r)
 		if ((state >= (ACK_GOOD_NORMAL << STATE)) &&
 			(state <= (ACK_GOOD_MORE_ACKS_TO_COME << STATE))) {
 			scratch |= DEFECT7374_FSM_SS_CONTROL_READ;
+			dev->bug7734_patched = 1;
 			break;
 		}
 
@@ -2904,7 +2880,7 @@ static void handle_stat0_irqs(struct net2280 *dev, u32 stat)
 		cpu_to_le32s(&u.raw[0]);
 		cpu_to_le32s(&u.raw[1]);
 
-		if (dev->quirks & PLX_SUPERSPEED)
+		if ((dev->quirks & PLX_SUPERSPEED) && !dev->bug7734_patched)
 			defect7374_workaround(dev, u.r);
 
 		tmp = 0;
@@ -3418,9 +3394,12 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		fsmvalue = get_idx_reg(dev->regs, SCRATCH) &
 					(0xf << DEFECT7374_FSM_FIELD);
 		/* See if firmware needs to set up for workaround: */
-		if (fsmvalue == DEFECT7374_FSM_SS_CONTROL_READ)
+		if (fsmvalue == DEFECT7374_FSM_SS_CONTROL_READ) {
+			dev->bug7734_patched = 1;
 			writel(0, &dev->usb->usbctl);
-	} else{
+		} else
+			dev->bug7734_patched = 0;
+	} else {
 		dev->enhanced_mode = 0;
 		dev->n_ep = 7;
 		/* put into initial config, link up all endpoints */
diff --git a/drivers/usb/gadget/udc/net2280.h b/drivers/usb/gadget/udc/net2280.h
index a16494a..c7c7981 100644
--- a/drivers/usb/gadget/udc/net2280.h
+++ b/drivers/usb/gadget/udc/net2280.h
@@ -165,7 +165,8 @@ struct net2280 {
 					ltm_enable:1,
 					wakeup_enable:1,
 					selfpowered:1,
-					addressed_state:1;
+					addressed_state:1,
+					bug7734_patched:1;
 	u16				chiprev;
 	int enhanced_mode;
 	int n_ep;
-- 
2.1.3

