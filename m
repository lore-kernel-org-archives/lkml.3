Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109AbaJTS4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:56:38 -0400
Received: from mail-bn1bon0057.outbound.protection.outlook.com ([157.56.111.57]:52928
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360AbaJTS4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:56:32 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv5 1/7] usb: dwc2: Update the gadget driver to use common dwc2_hsotg structure
Date: Mon, 20 Oct 2014 13:52:00 -0500
Message-ID: <1413831126-24193-2-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR03CA014.apcprd03.prod.outlook.com (10.141.119.24) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(51234002)(199003)(95666004)(20776003)(105586002)(88136002)(21056001)(102836001)(77096002)(97736003)(80022003)(99396003)(31966008)(107046002)(77156001)(106356001)(229853001)(81156004)(42186005)(76482002)(46102003)(66066001)(64706001)(120916001)(47776003)(53416004)(40100003)(33646002)(87976001)(93916002)(62966002)(86362001)(122386002)(19580405001)(19580395003)(50466002)(69596002)(87286001)(4396001)(104166001)(50226001)(86152002)(92726001)(92566001)(48376002)(50986999)(76176999)(85306004)(101416001)(85852003)(89996001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Adds the gadget data structure and appropriate data structure pointers
to the common dwc2_hsotg data structure. To keep the driver data
dereference code looking clean, the gadget variable declares are only available
for peripheral and dual-role mode. This is needed so that the dwc2_hsotg data
structure can be used by the hcd and gadget drivers.

Updates gadget.c to use the dwc2_hsotg data structure and gadget pointers
that have been moved into the common dwc2_hsotg structure.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
---
v5: Keep the changes to mininum and maintain hcd and gadget driver to build
    and work separately. Use IS_ENABLED() instead of #if defined
v3: Updated with paulz's suggestion to avoid double pointers.
v2: Left the function parameter name as 'hsotg' and just changed its type.
---
 drivers/usb/dwc2/core.h   | 156 ++++++++++++++++++++++++----------------------
 drivers/usb/dwc2/gadget.c | 147 +++++++++++++++++++++----------------------
 2 files changed, 155 insertions(+), 148 deletions(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index bf015ab..5412f57 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -84,7 +84,7 @@ static const char * const s3c_hsotg_supply_names[] = {
  */
 #define EP0_MPS_LIMIT   64
 
-struct s3c_hsotg;
+struct dwc2_hsotg;
 struct s3c_hsotg_req;
 
 /**
@@ -130,7 +130,7 @@ struct s3c_hsotg_req;
 struct s3c_hsotg_ep {
 	struct usb_ep           ep;
 	struct list_head        queue;
-	struct s3c_hsotg        *parent;
+	struct dwc2_hsotg       *parent;
 	struct s3c_hsotg_req    *req;
 	struct dentry           *debugfs;
 
@@ -155,67 +155,6 @@ struct s3c_hsotg_ep {
 };
 
 /**
- * struct s3c_hsotg - driver state.
- * @dev: The parent device supplied to the probe function
- * @driver: USB gadget driver
- * @phy: The otg phy transceiver structure for phy control.
- * @uphy: The otg phy transceiver structure for old USB phy control.
- * @plat: The platform specific configuration data. This can be removed once
- * all SoCs support usb transceiver.
- * @regs: The memory area mapped for accessing registers.
- * @irq: The IRQ number we are using
- * @supplies: Definition of USB power supplies
- * @phyif: PHY interface width
- * @dedicated_fifos: Set if the hardware has dedicated IN-EP fifos.
- * @num_of_eps: Number of available EPs (excluding EP0)
- * @debug_root: root directrory for debugfs.
- * @debug_file: main status file for debugfs.
- * @debug_fifo: FIFO status file for debugfs.
- * @ep0_reply: Request used for ep0 reply.
- * @ep0_buff: Buffer for EP0 reply data, if needed.
- * @ctrl_buff: Buffer for EP0 control requests.
- * @ctrl_req: Request for EP0 control packets.
- * @setup: NAK management for EP0 SETUP
- * @last_rst: Time of last reset
- * @eps: The endpoints being supplied to the gadget framework
- */
-struct s3c_hsotg {
-	struct device            *dev;
-	struct usb_gadget_driver *driver;
-	struct phy               *phy;
-	struct usb_phy           *uphy;
-	struct s3c_hsotg_plat    *plat;
-
-	spinlock_t              lock;
-
-	void __iomem            *regs;
-	int                     irq;
-	struct clk              *clk;
-
-	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
-
-	u32                     phyif;
-	int			fifo_mem;
-	unsigned int            dedicated_fifos:1;
-	unsigned char           num_of_eps;
-	u32			fifo_map;
-
-	struct dentry           *debug_root;
-	struct dentry           *debug_file;
-	struct dentry           *debug_fifo;
-
-	struct usb_request      *ep0_reply;
-	struct usb_request      *ctrl_req;
-	u8                      ep0_buff[8];
-	u8                      ctrl_buff[8];
-
-	struct usb_gadget       gadget;
-	unsigned int            setup;
-	unsigned long           last_rst;
-	struct s3c_hsotg_ep     *eps;
-};
-
-/**
  * struct s3c_hsotg_req - data transfer request
  * @req: The USB gadget request
  * @queue: The list of requests for the endpoint this is queued for.
@@ -229,6 +168,7 @@ struct s3c_hsotg_req {
 	unsigned char           mapped;
 };
 
+#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
 #define call_gadget(_hs, _entry) \
 do { \
 	if ((_hs)->gadget.speed != USB_SPEED_UNKNOWN && \
@@ -238,6 +178,9 @@ do { \
 		spin_lock(&_hs->lock); \
 	} \
 } while (0)
+#else
+#define call_gadget(_hs, _entry)	do {} while (0)
+#endif
 
 struct dwc2_hsotg;
 struct dwc2_host_chan;
@@ -495,11 +438,13 @@ struct dwc2_hw_params {
  * struct dwc2_hsotg - Holds the state of the driver, including the non-periodic
  * and periodic schedules
  *
+ * These are common for both host and peripheral modes:
+ *
  * @dev:                The struct device pointer
  * @regs:		Pointer to controller regs
- * @core_params:        Parameters that define how the core should be configured
  * @hw_params:          Parameters that were autodetected from the
  *                      hardware registers
+ * @core_params:	Parameters that define how the core should be configured
  * @op_state:           The operational State, during transitions (a_host=>
  *                      a_peripheral and b_device=>b_host) this may not match
  *                      the core, but allows the software to determine
@@ -508,6 +453,8 @@ struct dwc2_hw_params {
  *                      - USB_DR_MODE_PERIPHERAL
  *                      - USB_DR_MODE_HOST
  *                      - USB_DR_MODE_OTG
+ * @lock:		Spinlock that protects all the driver data structures
+ * @priv:		Stores a pointer to the struct usb_hcd
  * @queuing_high_bandwidth: True if multiple packets of a high-bandwidth
  *                      transfer are in process of being queued
  * @srp_success:        Stores status of SRP request in the case of a FS PHY
@@ -517,6 +464,9 @@ struct dwc2_hw_params {
  *                      interrupt
  * @wkp_timer:          Timer object for handling Wakeup Detected interrupt
  * @lx_state:           Lx state of connected device
+ *
+ * These are for host mode:
+ *
  * @flags:              Flags for handling root port state changes
  * @non_periodic_sched_inactive: Inactive QHs in the non-periodic schedule.
  *                      Transfers associated with these QHs are not currently
@@ -585,11 +535,31 @@ struct dwc2_hw_params {
  * @status_buf_dma:     DMA address for status_buf
  * @start_work:         Delayed work for handling host A-cable connection
  * @reset_work:         Delayed work for handling a port reset
- * @lock:               Spinlock that protects all the driver data structures
- * @priv:               Stores a pointer to the struct usb_hcd
  * @otg_port:           OTG port number
  * @frame_list:         Frame list
  * @frame_list_dma:     Frame list DMA address
+ *
+ * These are for peripheral mode:
+ *
+ * @driver:             USB gadget driver
+ * @phy:                The otg phy transceiver structure for phy control.
+ * @uphy:               The otg phy transceiver structure for old USB phy control.
+ * @plat:               The platform specific configuration data. This can be removed once
+ *                      all SoCs support usb transceiver.
+ * @supplies:           Definition of USB power supplies
+ * @phyif:              PHY interface width
+ * @dedicated_fifos:    Set if the hardware has dedicated IN-EP fifos.
+ * @num_of_eps:         Number of available EPs (excluding EP0)
+ * @debug_root:         Root directrory for debugfs.
+ * @debug_file:         Main status file for debugfs.
+ * @debug_fifo:         FIFO status file for debugfs.
+ * @ep0_reply:          Request used for ep0 reply.
+ * @ep0_buff:           Buffer for EP0 reply data, if needed.
+ * @ctrl_buff:          Buffer for EP0 control requests.
+ * @ctrl_req:           Request for EP0 control packets.
+ * @setup:              NAK management for EP0 SETUP
+ * @last_rst:           Time of last reset
+ * @eps:                The endpoints being supplied to the gadget framework
  */
 struct dwc2_hsotg {
 	struct device *dev;
@@ -601,6 +571,9 @@ struct dwc2_hsotg {
 	enum usb_otg_state op_state;
 	enum usb_dr_mode dr_mode;
 
+	spinlock_t lock;
+	void *priv;
+
 	unsigned int queuing_high_bandwidth:1;
 	unsigned int srp_success:1;
 
@@ -609,6 +582,14 @@ struct dwc2_hsotg {
 	struct timer_list wkp_timer;
 	enum dwc2_lx_state lx_state;
 
+	/* DWC OTG HW Release versions */
+#define DWC2_CORE_REV_2_71a	0x4f54271a
+#define DWC2_CORE_REV_2_90a	0x4f54290a
+#define DWC2_CORE_REV_2_92a	0x4f54292a
+#define DWC2_CORE_REV_2_94a	0x4f54294a
+#define DWC2_CORE_REV_3_00a	0x4f54300a
+
+#if IS_ENABLED(CONFIG_USB_DWC2_HOST) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
 	union dwc2_hcd_internal_flags {
 		u32 d32;
 		struct {
@@ -655,19 +636,10 @@ struct dwc2_hsotg {
 
 	struct delayed_work start_work;
 	struct delayed_work reset_work;
-	spinlock_t lock;
-	void *priv;
 	u8 otg_port;
 	u32 *frame_list;
 	dma_addr_t frame_list_dma;
 
-	/* DWC OTG HW Release versions */
-#define DWC2_CORE_REV_2_71a	0x4f54271a
-#define DWC2_CORE_REV_2_90a	0x4f54290a
-#define DWC2_CORE_REV_2_92a	0x4f54292a
-#define DWC2_CORE_REV_2_94a	0x4f54294a
-#define DWC2_CORE_REV_3_00a	0x4f54300a
-
 #ifdef DEBUG
 	u32 frrem_samples;
 	u64 frrem_accum;
@@ -686,6 +658,40 @@ struct dwc2_hsotg {
 	u32 hfnum_other_samples_b;
 	u64 hfnum_other_frrem_accum_b;
 #endif
+#endif /* CONFIG_USB_DWC2_HOST || CONFIG_USB_DWC2_DUAL_ROLE */
+
+#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
+	/* Gadget structures */
+	struct usb_gadget_driver *driver;
+	struct phy *phy;
+	struct usb_phy *uphy;
+	struct s3c_hsotg_plat *plat;
+
+	int	irq;
+	struct clk *clk;
+
+	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
+
+	u32 phyif;
+	int fifo_mem;
+	unsigned int dedicated_fifos:1;
+	unsigned char num_of_eps;
+	u32 fifo_map;
+
+	struct dentry *debug_root;
+	struct dentry *debug_file;
+	struct dentry *debug_fifo;
+
+	struct usb_request *ep0_reply;
+	struct usb_request *ctrl_req;
+	u8 ep0_buff[8];
+	u8 ctrl_buff[8];
+
+	struct usb_gadget gadget;
+	unsigned int setup;
+	unsigned long last_rst;
+	struct s3c_hsotg_ep *eps;
+#endif /* CONFIG_USB_DWC2_PERIPHERAL || CONFIG_USB_DWC2_DUAL_ROLE */
 };
 
 /* Reasons for halting a host channel */
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 7b5856f..6611ea3 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -36,6 +36,7 @@
 #include <linux/platform_data/s3c-hsotg.h>
 
 #include "core.h"
+#include "hw.h"
 
 /* conversion functions */
 static inline struct s3c_hsotg_req *our_req(struct usb_request *req)
@@ -48,9 +49,9 @@ static inline struct s3c_hsotg_ep *our_ep(struct usb_ep *ep)
 	return container_of(ep, struct s3c_hsotg_ep, ep);
 }
 
-static inline struct s3c_hsotg *to_hsotg(struct usb_gadget *gadget)
+static inline struct dwc2_hsotg *to_hsotg(struct usb_gadget *gadget)
 {
-	return container_of(gadget, struct s3c_hsotg, gadget);
+	return container_of(gadget, struct dwc2_hsotg, gadget);
 }
 
 static inline void __orr32(void __iomem *ptr, u32 val)
@@ -64,7 +65,7 @@ static inline void __bic32(void __iomem *ptr, u32 val)
 }
 
 /* forward decleration of functions */
-static void s3c_hsotg_dump(struct s3c_hsotg *hsotg);
+static void s3c_hsotg_dump(struct dwc2_hsotg *hsotg);
 
 /**
  * using_dma - return the DMA status of the driver.
@@ -85,7 +86,7 @@ static void s3c_hsotg_dump(struct s3c_hsotg *hsotg);
  *
  * Until this issue is sorted out, we always return 'false'.
  */
-static inline bool using_dma(struct s3c_hsotg *hsotg)
+static inline bool using_dma(struct dwc2_hsotg *hsotg)
 {
 	return false;	/* support is not complete */
 }
@@ -95,7 +96,7 @@ static inline bool using_dma(struct s3c_hsotg *hsotg)
  * @hsotg: The device state
  * @ints: A bitmask of the interrupts to enable
  */
-static void s3c_hsotg_en_gsint(struct s3c_hsotg *hsotg, u32 ints)
+static void s3c_hsotg_en_gsint(struct dwc2_hsotg *hsotg, u32 ints)
 {
 	u32 gsintmsk = readl(hsotg->regs + GINTMSK);
 	u32 new_gsintmsk;
@@ -113,7 +114,7 @@ static void s3c_hsotg_en_gsint(struct s3c_hsotg *hsotg, u32 ints)
  * @hsotg: The device state
  * @ints: A bitmask of the interrupts to enable
  */
-static void s3c_hsotg_disable_gsint(struct s3c_hsotg *hsotg, u32 ints)
+static void s3c_hsotg_disable_gsint(struct dwc2_hsotg *hsotg, u32 ints)
 {
 	u32 gsintmsk = readl(hsotg->regs + GINTMSK);
 	u32 new_gsintmsk;
@@ -134,7 +135,7 @@ static void s3c_hsotg_disable_gsint(struct s3c_hsotg *hsotg, u32 ints)
  * Set or clear the mask for an individual endpoint's interrupt
  * request.
  */
-static void s3c_hsotg_ctrl_epint(struct s3c_hsotg *hsotg,
+static void s3c_hsotg_ctrl_epint(struct dwc2_hsotg *hsotg,
 				 unsigned int ep, unsigned int dir_in,
 				 unsigned int en)
 {
@@ -159,7 +160,7 @@ static void s3c_hsotg_ctrl_epint(struct s3c_hsotg *hsotg,
  * s3c_hsotg_init_fifo - initialise non-periodic FIFOs
  * @hsotg: The device instance.
  */
-static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_init_fifo(struct dwc2_hsotg *hsotg)
 {
 	unsigned int ep;
 	unsigned int addr;
@@ -283,7 +284,7 @@ static inline int is_ep_periodic(struct s3c_hsotg_ep *hs_ep)
  * This is the reverse of s3c_hsotg_map_dma(), called for the completion
  * of a request to ensure the buffer is ready for access by the caller.
  */
-static void s3c_hsotg_unmap_dma(struct s3c_hsotg *hsotg,
+static void s3c_hsotg_unmap_dma(struct dwc2_hsotg *hsotg,
 				struct s3c_hsotg_ep *hs_ep,
 				struct s3c_hsotg_req *hs_req)
 {
@@ -312,7 +313,7 @@ static void s3c_hsotg_unmap_dma(struct s3c_hsotg *hsotg,
  *
  * This routine is only needed for PIO
  */
-static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
+static int s3c_hsotg_write_fifo(struct dwc2_hsotg *hsotg,
 				struct s3c_hsotg_ep *hs_ep,
 				struct s3c_hsotg_req *hs_req)
 {
@@ -517,7 +518,7 @@ static unsigned get_ep_limit(struct s3c_hsotg_ep *hs_ep)
  * Start the given request running by setting the endpoint registers
  * appropriately, and writing any data to the FIFOs.
  */
-static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
+static void s3c_hsotg_start_req(struct dwc2_hsotg *hsotg,
 				struct s3c_hsotg_ep *hs_ep,
 				struct s3c_hsotg_req *hs_req,
 				bool continuing)
@@ -707,7 +708,7 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
  * DMA memory, then we map the memory and mark our request to allow us to
  * cleanup on completion.
  */
-static int s3c_hsotg_map_dma(struct s3c_hsotg *hsotg,
+static int s3c_hsotg_map_dma(struct dwc2_hsotg *hsotg,
 			     struct s3c_hsotg_ep *hs_ep,
 			     struct usb_request *req)
 {
@@ -736,7 +737,7 @@ static int s3c_hsotg_ep_queue(struct usb_ep *ep, struct usb_request *req,
 {
 	struct s3c_hsotg_req *hs_req = our_req(req);
 	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
-	struct s3c_hsotg *hs = hs_ep->parent;
+	struct dwc2_hsotg *hs = hs_ep->parent;
 	bool first;
 
 	dev_dbg(hs->dev, "%s: req %p: %d@%p, noi=%d, zero=%d, snok=%d\n",
@@ -768,7 +769,7 @@ static int s3c_hsotg_ep_queue_lock(struct usb_ep *ep, struct usb_request *req,
 			      gfp_t gfp_flags)
 {
 	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
-	struct s3c_hsotg *hs = hs_ep->parent;
+	struct dwc2_hsotg *hs = hs_ep->parent;
 	unsigned long flags = 0;
 	int ret = 0;
 
@@ -799,7 +800,7 @@ static void s3c_hsotg_complete_oursetup(struct usb_ep *ep,
 					struct usb_request *req)
 {
 	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
-	struct s3c_hsotg *hsotg = hs_ep->parent;
+	struct dwc2_hsotg *hsotg = hs_ep->parent;
 
 	dev_dbg(hsotg->dev, "%s: ep %p, req %p\n", __func__, ep, req);
 
@@ -814,7 +815,7 @@ static void s3c_hsotg_complete_oursetup(struct usb_ep *ep,
  * Convert the given wIndex into a pointer to an driver endpoint
  * structure, or return NULL if it is not a valid endpoint.
  */
-static struct s3c_hsotg_ep *ep_from_windex(struct s3c_hsotg *hsotg,
+static struct s3c_hsotg_ep *ep_from_windex(struct dwc2_hsotg *hsotg,
 					   u32 windex)
 {
 	struct s3c_hsotg_ep *ep = &hsotg->eps[windex & 0x7F];
@@ -843,7 +844,7 @@ static struct s3c_hsotg_ep *ep_from_windex(struct s3c_hsotg *hsotg,
  * Create a request and queue it on the given endpoint. This is useful as
  * an internal method of sending replies to certain control requests, etc.
  */
-static int s3c_hsotg_send_reply(struct s3c_hsotg *hsotg,
+static int s3c_hsotg_send_reply(struct dwc2_hsotg *hsotg,
 				struct s3c_hsotg_ep *ep,
 				void *buff,
 				int length)
@@ -884,7 +885,7 @@ static int s3c_hsotg_send_reply(struct s3c_hsotg *hsotg,
  * @hsotg: The device state
  * @ctrl: USB control request
  */
-static int s3c_hsotg_process_req_status(struct s3c_hsotg *hsotg,
+static int s3c_hsotg_process_req_status(struct dwc2_hsotg *hsotg,
 					struct usb_ctrlrequest *ctrl)
 {
 	struct s3c_hsotg_ep *ep0 = &hsotg->eps[0];
@@ -955,7 +956,7 @@ static struct s3c_hsotg_req *get_ep_head(struct s3c_hsotg_ep *hs_ep)
  * @hsotg: The device state
  * @ctrl: USB control request
  */
-static int s3c_hsotg_process_req_feature(struct s3c_hsotg *hsotg,
+static int s3c_hsotg_process_req_feature(struct dwc2_hsotg *hsotg,
 					 struct usb_ctrlrequest *ctrl)
 {
 	struct s3c_hsotg_ep *ep0 = &hsotg->eps[0];
@@ -1028,8 +1029,8 @@ static int s3c_hsotg_process_req_feature(struct s3c_hsotg *hsotg,
 	return 1;
 }
 
-static void s3c_hsotg_enqueue_setup(struct s3c_hsotg *hsotg);
-static void s3c_hsotg_disconnect(struct s3c_hsotg *hsotg);
+static void s3c_hsotg_enqueue_setup(struct dwc2_hsotg *hsotg);
+static void s3c_hsotg_disconnect(struct dwc2_hsotg *hsotg);
 
 /**
  * s3c_hsotg_stall_ep0 - stall ep0
@@ -1037,7 +1038,7 @@ static void s3c_hsotg_disconnect(struct s3c_hsotg *hsotg);
  *
  * Set stall for ep0 as response for setup request.
  */
-static void s3c_hsotg_stall_ep0(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_stall_ep0(struct dwc2_hsotg *hsotg)
 {
 	struct s3c_hsotg_ep *ep0 = &hsotg->eps[0];
 	u32 reg;
@@ -1076,7 +1077,7 @@ static void s3c_hsotg_stall_ep0(struct s3c_hsotg *hsotg)
  * needs to work out what to do next (and whether to pass it on to the
  * gadget driver).
  */
-static void s3c_hsotg_process_control(struct s3c_hsotg *hsotg,
+static void s3c_hsotg_process_control(struct dwc2_hsotg *hsotg,
 				      struct usb_ctrlrequest *ctrl)
 {
 	struct s3c_hsotg_ep *ep0 = &hsotg->eps[0];
@@ -1161,7 +1162,7 @@ static void s3c_hsotg_complete_setup(struct usb_ep *ep,
 				     struct usb_request *req)
 {
 	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
-	struct s3c_hsotg *hsotg = hs_ep->parent;
+	struct dwc2_hsotg *hsotg = hs_ep->parent;
 
 	if (req->status < 0) {
 		dev_dbg(hsotg->dev, "%s: failed %d\n", __func__, req->status);
@@ -1183,7 +1184,7 @@ static void s3c_hsotg_complete_setup(struct usb_ep *ep,
  * Enqueue a request on EP0 if necessary to received any SETUP packets
  * received from the host.
  */
-static void s3c_hsotg_enqueue_setup(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_enqueue_setup(struct dwc2_hsotg *hsotg)
 {
 	struct usb_request *req = hsotg->ctrl_req;
 	struct s3c_hsotg_req *hs_req = our_req(req);
@@ -1226,7 +1227,7 @@ static void s3c_hsotg_enqueue_setup(struct s3c_hsotg *hsotg)
  *
  * Note, expects the ep to already be locked as appropriate.
  */
-static void s3c_hsotg_complete_request(struct s3c_hsotg *hsotg,
+static void s3c_hsotg_complete_request(struct dwc2_hsotg *hsotg,
 				       struct s3c_hsotg_ep *hs_ep,
 				       struct s3c_hsotg_req *hs_req,
 				       int result)
@@ -1291,7 +1292,7 @@ static void s3c_hsotg_complete_request(struct s3c_hsotg *hsotg,
  * endpoint, so sort out whether we need to read the data into a request
  * that has been made for that endpoint.
  */
-static void s3c_hsotg_rx_data(struct s3c_hsotg *hsotg, int ep_idx, int size)
+static void s3c_hsotg_rx_data(struct dwc2_hsotg *hsotg, int ep_idx, int size)
 {
 	struct s3c_hsotg_ep *hs_ep = &hsotg->eps[ep_idx];
 	struct s3c_hsotg_req *hs_req = hs_ep->req;
@@ -1356,7 +1357,7 @@ static void s3c_hsotg_rx_data(struct s3c_hsotg *hsotg, int ep_idx, int size)
  * currently believed that we do not need to wait for any space in
  * the TxFIFO.
  */
-static void s3c_hsotg_send_zlp(struct s3c_hsotg *hsotg,
+static void s3c_hsotg_send_zlp(struct dwc2_hsotg *hsotg,
 			       struct s3c_hsotg_req *req)
 {
 	u32 ctrl;
@@ -1398,7 +1399,7 @@ static void s3c_hsotg_send_zlp(struct s3c_hsotg *hsotg,
  * transfer for an OUT endpoint has been completed, either by a short
  * packet or by the finish of a transfer.
  */
-static void s3c_hsotg_handle_outdone(struct s3c_hsotg *hsotg,
+static void s3c_hsotg_handle_outdone(struct dwc2_hsotg *hsotg,
 				     int epnum, bool was_setup)
 {
 	u32 epsize = readl(hsotg->regs + DOEPTSIZ(epnum));
@@ -1471,7 +1472,7 @@ static void s3c_hsotg_handle_outdone(struct s3c_hsotg *hsotg,
  *
  * Return the current frame number
  */
-static u32 s3c_hsotg_read_frameno(struct s3c_hsotg *hsotg)
+static u32 s3c_hsotg_read_frameno(struct dwc2_hsotg *hsotg)
 {
 	u32 dsts;
 
@@ -1498,7 +1499,7 @@ static u32 s3c_hsotg_read_frameno(struct s3c_hsotg *hsotg)
  * as the actual data should be sent to the memory directly and we turn
  * on the completion interrupts to get notifications of transfer completion.
  */
-static void s3c_hsotg_handle_rx(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_handle_rx(struct dwc2_hsotg *hsotg)
 {
 	u32 grxstsr = readl(hsotg->regs + GRXSTSP);
 	u32 epnum, status, size;
@@ -1590,7 +1591,7 @@ static u32 s3c_hsotg_ep0_mps(unsigned int mps)
  * Configure the maximum packet size for the given endpoint, updating
  * the hardware control registers to reflect this.
  */
-static void s3c_hsotg_set_ep_maxpacket(struct s3c_hsotg *hsotg,
+static void s3c_hsotg_set_ep_maxpacket(struct dwc2_hsotg *hsotg,
 				       unsigned int ep, unsigned int mps)
 {
 	struct s3c_hsotg_ep *hs_ep = &hsotg->eps[ep];
@@ -1645,7 +1646,7 @@ bad_mps:
  * @hsotg: The driver state
  * @idx: The index for the endpoint (0..15)
  */
-static void s3c_hsotg_txfifo_flush(struct s3c_hsotg *hsotg, unsigned int idx)
+static void s3c_hsotg_txfifo_flush(struct dwc2_hsotg *hsotg, unsigned int idx)
 {
 	int timeout;
 	int val;
@@ -1681,7 +1682,7 @@ static void s3c_hsotg_txfifo_flush(struct s3c_hsotg *hsotg, unsigned int idx)
  * Check to see if there is a request that has data to send, and if so
  * make an attempt to write data into the FIFO.
  */
-static int s3c_hsotg_trytx(struct s3c_hsotg *hsotg,
+static int s3c_hsotg_trytx(struct dwc2_hsotg *hsotg,
 			   struct s3c_hsotg_ep *hs_ep)
 {
 	struct s3c_hsotg_req *hs_req = hs_ep->req;
@@ -1714,7 +1715,7 @@ static int s3c_hsotg_trytx(struct s3c_hsotg *hsotg,
  * An IN transfer has been completed, update the transfer's state and then
  * call the relevant completion routines.
  */
-static void s3c_hsotg_complete_in(struct s3c_hsotg *hsotg,
+static void s3c_hsotg_complete_in(struct dwc2_hsotg *hsotg,
 				  struct s3c_hsotg_ep *hs_ep)
 {
 	struct s3c_hsotg_req *hs_req = hs_ep->req;
@@ -1791,7 +1792,7 @@ static void s3c_hsotg_complete_in(struct s3c_hsotg *hsotg,
  *
  * Process and clear any interrupt pending for an individual endpoint
  */
-static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
+static void s3c_hsotg_epint(struct dwc2_hsotg *hsotg, unsigned int idx,
 			    int dir_in)
 {
 	struct s3c_hsotg_ep *hs_ep = &hsotg->eps[idx];
@@ -1916,7 +1917,7 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
  * Handle updating the device settings after the enumeration phase has
  * been completed.
  */
-static void s3c_hsotg_irq_enumdone(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_irq_enumdone(struct dwc2_hsotg *hsotg)
 {
 	u32 dsts = readl(hsotg->regs + DSTS);
 	int ep0_mps = 0, ep_mps = 8;
@@ -1993,7 +1994,7 @@ static void s3c_hsotg_irq_enumdone(struct s3c_hsotg *hsotg)
  * Go through the requests on the given endpoint and mark them
  * completed with the given result code.
  */
-static void kill_all_requests(struct s3c_hsotg *hsotg,
+static void kill_all_requests(struct dwc2_hsotg *hsotg,
 			      struct s3c_hsotg_ep *ep,
 			      int result, bool force)
 {
@@ -2027,7 +2028,7 @@ static void kill_all_requests(struct s3c_hsotg *hsotg,
  * transactions and signal the gadget driver that this
  * has happened.
  */
-static void s3c_hsotg_disconnect(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_disconnect(struct dwc2_hsotg *hsotg)
 {
 	unsigned ep;
 
@@ -2042,7 +2043,7 @@ static void s3c_hsotg_disconnect(struct s3c_hsotg *hsotg)
  * @hsotg: The device state:
  * @periodic: True if this is a periodic FIFO interrupt
  */
-static void s3c_hsotg_irq_fifoempty(struct s3c_hsotg *hsotg, bool periodic)
+static void s3c_hsotg_irq_fifoempty(struct dwc2_hsotg *hsotg, bool periodic)
 {
 	struct s3c_hsotg_ep *ep;
 	int epno, ret;
@@ -2076,7 +2077,7 @@ static void s3c_hsotg_irq_fifoempty(struct s3c_hsotg *hsotg, bool periodic)
  *
  * Issue a soft reset to the core, and await the core finishing it.
  */
-static int s3c_hsotg_corereset(struct s3c_hsotg *hsotg)
+static int s3c_hsotg_corereset(struct dwc2_hsotg *hsotg)
 {
 	int timeout;
 	u32 grstctl;
@@ -2124,7 +2125,7 @@ static int s3c_hsotg_corereset(struct s3c_hsotg *hsotg)
  *
  * Issue a soft reset to the core, and await the core finishing it.
  */
-static void s3c_hsotg_core_init(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_core_init(struct dwc2_hsotg *hsotg)
 {
 	s3c_hsotg_corereset(hsotg);
 
@@ -2258,7 +2259,7 @@ static void s3c_hsotg_core_init(struct s3c_hsotg *hsotg)
  */
 static irqreturn_t s3c_hsotg_irq(int irq, void *pw)
 {
-	struct s3c_hsotg *hsotg = pw;
+	struct dwc2_hsotg *hsotg = pw;
 	int retry_count = 8;
 	u32 gintsts;
 	u32 gintmsk;
@@ -2450,7 +2451,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 			       const struct usb_endpoint_descriptor *desc)
 {
 	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
-	struct s3c_hsotg *hsotg = hs_ep->parent;
+	struct dwc2_hsotg *hsotg = hs_ep->parent;
 	unsigned long flags;
 	int index = hs_ep->index;
 	u32 epctrl_reg;
@@ -2590,7 +2591,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 static int s3c_hsotg_ep_disable(struct usb_ep *ep)
 {
 	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
-	struct s3c_hsotg *hsotg = hs_ep->parent;
+	struct dwc2_hsotg *hsotg = hs_ep->parent;
 	int dir_in = hs_ep->dir_in;
 	int index = hs_ep->index;
 	unsigned long flags;
@@ -2655,7 +2656,7 @@ static int s3c_hsotg_ep_dequeue(struct usb_ep *ep, struct usb_request *req)
 {
 	struct s3c_hsotg_req *hs_req = our_req(req);
 	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
-	struct s3c_hsotg *hs = hs_ep->parent;
+	struct dwc2_hsotg *hs = hs_ep->parent;
 	unsigned long flags;
 
 	dev_dbg(hs->dev, "ep_dequeue(%p,%p)\n", ep, req);
@@ -2681,7 +2682,7 @@ static int s3c_hsotg_ep_dequeue(struct usb_ep *ep, struct usb_request *req)
 static int s3c_hsotg_ep_sethalt(struct usb_ep *ep, int value)
 {
 	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
-	struct s3c_hsotg *hs = hs_ep->parent;
+	struct dwc2_hsotg *hs = hs_ep->parent;
 	int index = hs_ep->index;
 	u32 epreg;
 	u32 epctl;
@@ -2745,7 +2746,7 @@ static int s3c_hsotg_ep_sethalt(struct usb_ep *ep, int value)
 static int s3c_hsotg_ep_sethalt_lock(struct usb_ep *ep, int value)
 {
 	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
-	struct s3c_hsotg *hs = hs_ep->parent;
+	struct dwc2_hsotg *hs = hs_ep->parent;
 	unsigned long flags = 0;
 	int ret = 0;
 
@@ -2774,7 +2775,7 @@ static struct usb_ep_ops s3c_hsotg_ep_ops = {
  * A wrapper for platform code responsible for controlling
  * low-level USB code
  */
-static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_phy_enable(struct dwc2_hsotg *hsotg)
 {
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
 
@@ -2797,7 +2798,7 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
  * A wrapper for platform code responsible for controlling
  * low-level USB code
  */
-static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_phy_disable(struct dwc2_hsotg *hsotg)
 {
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
 
@@ -2815,7 +2816,7 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
  * s3c_hsotg_init - initalize the usb core
  * @hsotg: The driver state
  */
-static void s3c_hsotg_init(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_init(struct dwc2_hsotg *hsotg)
 {
 	/* unmask subset of endpoint interrupts */
 
@@ -2865,7 +2866,7 @@ static void s3c_hsotg_init(struct s3c_hsotg *hsotg)
 static int s3c_hsotg_udc_start(struct usb_gadget *gadget,
 			   struct usb_gadget_driver *driver)
 {
-	struct s3c_hsotg *hsotg = to_hsotg(gadget);
+	struct dwc2_hsotg *hsotg = to_hsotg(gadget);
 	int ret;
 
 	if (!hsotg) {
@@ -2921,7 +2922,7 @@ err:
 static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 			  struct usb_gadget_driver *driver)
 {
-	struct s3c_hsotg *hsotg = to_hsotg(gadget);
+	struct dwc2_hsotg *hsotg = to_hsotg(gadget);
 	unsigned long flags = 0;
 	int ep;
 
@@ -2941,7 +2942,8 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 
-	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
+	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
+				hsotg->supplies);
 
 	clk_disable(hsotg->clk);
 
@@ -2968,7 +2970,7 @@ static int s3c_hsotg_gadget_getframe(struct usb_gadget *gadget)
  */
 static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 {
-	struct s3c_hsotg *hsotg = to_hsotg(gadget);
+	struct dwc2_hsotg *hsotg = to_hsotg(gadget);
 	unsigned long flags = 0;
 
 	dev_dbg(hsotg->dev, "%s: is_on: %d\n", __func__, is_on);
@@ -3006,7 +3008,7 @@ static const struct usb_gadget_ops s3c_hsotg_gadget_ops = {
  * creation) to give to the gadget driver. Setup the endpoint name, any
  * direction information and other state that may be required.
  */
-static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
+static void s3c_hsotg_initep(struct dwc2_hsotg *hsotg,
 				       struct s3c_hsotg_ep *hs_ep,
 				       int epnum)
 {
@@ -3055,7 +3057,7 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
  *
  * Read the USB core HW configuration registers
  */
-static void s3c_hsotg_hw_cfg(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_hw_cfg(struct dwc2_hsotg *hsotg)
 {
 	u32 cfg2, cfg3, cfg4;
 	/* check hardware configuration */
@@ -3079,7 +3081,7 @@ static void s3c_hsotg_hw_cfg(struct s3c_hsotg *hsotg)
  * s3c_hsotg_dump - dump state of the udc
  * @param: The device state
  */
-static void s3c_hsotg_dump(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_dump(struct dwc2_hsotg *hsotg)
 {
 #ifdef DEBUG
 	struct device *dev = hsotg->dev;
@@ -3138,7 +3140,7 @@ static void s3c_hsotg_dump(struct s3c_hsotg *hsotg)
  */
 static int state_show(struct seq_file *seq, void *v)
 {
-	struct s3c_hsotg *hsotg = seq->private;
+	struct dwc2_hsotg *hsotg = seq->private;
 	void __iomem *regs = hsotg->regs;
 	int idx;
 
@@ -3208,7 +3210,7 @@ static const struct file_operations state_fops = {
  */
 static int fifo_show(struct seq_file *seq, void *v)
 {
-	struct s3c_hsotg *hsotg = seq->private;
+	struct dwc2_hsotg *hsotg = seq->private;
 	void __iomem *regs = hsotg->regs;
 	u32 val;
 	int idx;
@@ -3264,7 +3266,7 @@ static const char *decode_direction(int is_in)
 static int ep_show(struct seq_file *seq, void *v)
 {
 	struct s3c_hsotg_ep *ep = seq->private;
-	struct s3c_hsotg *hsotg = ep->parent;
+	struct dwc2_hsotg *hsotg = ep->parent;
 	struct s3c_hsotg_req *req;
 	void __iomem *regs = hsotg->regs;
 	int index = ep->index;
@@ -3341,7 +3343,7 @@ static const struct file_operations ep_fops = {
  * with the same name as the device itself, in case we end up
  * with multiple blocks in future systems.
  */
-static void s3c_hsotg_create_debug(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_create_debug(struct dwc2_hsotg *hsotg)
 {
 	struct dentry *root;
 	unsigned epidx;
@@ -3387,7 +3389,7 @@ static void s3c_hsotg_create_debug(struct s3c_hsotg *hsotg)
  *
  * Cleanup (remove) the debugfs files for use on module exit.
  */
-static void s3c_hsotg_delete_debug(struct s3c_hsotg *hsotg)
+static void s3c_hsotg_delete_debug(struct dwc2_hsotg *hsotg)
 {
 	unsigned epidx;
 
@@ -3405,7 +3407,6 @@ static void s3c_hsotg_delete_debug(struct s3c_hsotg *hsotg)
  * s3c_hsotg_probe - probe function for hsotg driver
  * @pdev: The platform information for the driver
  */
-
 static int s3c_hsotg_probe(struct platform_device *pdev)
 {
 	struct s3c_hsotg_plat *plat = dev_get_platdata(&pdev->dev);
@@ -3413,13 +3414,13 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	struct usb_phy *uphy;
 	struct device *dev = &pdev->dev;
 	struct s3c_hsotg_ep *eps;
-	struct s3c_hsotg *hsotg;
+	struct dwc2_hsotg *hsotg;
 	struct resource *res;
 	int epnum;
 	int ret;
 	int i;
 
-	hsotg = devm_kzalloc(&pdev->dev, sizeof(struct s3c_hsotg), GFP_KERNEL);
+	hsotg = devm_kzalloc(&pdev->dev, sizeof(struct dwc2_hsotg), GFP_KERNEL);
 	if (!hsotg)
 		return -ENOMEM;
 
@@ -3500,7 +3501,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(hsotg->supplies),
 				 hsotg->supplies);
 	if (ret) {
-		dev_err(dev, "failed to request supplies: %d\n", ret);
+		dev_err(hsotg->dev, "failed to request supplies: %d\n", ret);
 		goto err_clk;
 	}
 
@@ -3508,7 +3509,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 				    hsotg->supplies);
 
 	if (ret) {
-		dev_err(hsotg->dev, "failed to enable supplies: %d\n", ret);
+		dev_err(dev, "failed to enable supplies: %d\n", ret);
 		goto err_supplies;
 	}
 
@@ -3571,13 +3572,13 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	ret = regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
 				    hsotg->supplies);
 	if (ret) {
-		dev_err(hsotg->dev, "failed to disable supplies: %d\n", ret);
+		dev_err(&pdev->dev, "failed to disable supplies: %d\n", ret);
 		goto err_ep_mem;
 	}
 
 	s3c_hsotg_phy_disable(hsotg);
 
-	ret = usb_add_gadget_udc(&pdev->dev, &hsotg->gadget);
+	ret = usb_add_gadget_udc(dev, &hsotg->gadget);
 	if (ret)
 		goto err_ep_mem;
 
@@ -3603,7 +3604,7 @@ err_clk:
  */
 static int s3c_hsotg_remove(struct platform_device *pdev)
 {
-	struct s3c_hsotg *hsotg = platform_get_drvdata(pdev);
+	struct dwc2_hsotg *hsotg = platform_get_drvdata(pdev);
 
 	usb_del_gadget_udc(&hsotg->gadget);
 
@@ -3621,7 +3622,7 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
 
 static int s3c_hsotg_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct s3c_hsotg *hsotg = platform_get_drvdata(pdev);
+	struct dwc2_hsotg *hsotg = platform_get_drvdata(pdev);
 	unsigned long flags;
 	int ret = 0;
 
@@ -3650,7 +3651,7 @@ static int s3c_hsotg_suspend(struct platform_device *pdev, pm_message_t state)
 
 static int s3c_hsotg_resume(struct platform_device *pdev)
 {
-	struct s3c_hsotg *hsotg = platform_get_drvdata(pdev);
+	struct dwc2_hsotg *hsotg = platform_get_drvdata(pdev);
 	unsigned long flags;
 	int ret = 0;
 
-- 
2.0.3

