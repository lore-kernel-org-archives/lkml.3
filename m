Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaDXLrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:47:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46363 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaDXIwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 029/182] usb: dwc3: fix randconfig build errors
Date: Thu, 24 Apr 2014 09:49:14 +0100
Message-Id: <1398329507-5911-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 610183051d8f9421f138c4203ca894387f9f8839 upstream.

commit 388e5c5 (usb: dwc3: remove dwc3 dependency
on host AND gadget.) created the possibility for
host-only and peripheral-only dwc3 builds but
left a possible randconfig build error when host-only
builds are selected.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: backported to 3.11:
  - dropped references to dwc3_gadget_get_link_state() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/core.h   | 30 ++++++++++++++++++++++++++++++
 drivers/usb/dwc3/gadget.h | 12 ------------
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 7ab3c99..c3cdb84 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -877,6 +877,19 @@ union dwc3_event {
 	struct dwc3_event_gevt		gevt;
 };
 
+/**
+ * struct dwc3_gadget_ep_cmd_params - representation of endpoint command
+ * parameters
+ * @param2: third parameter
+ * @param1: second parameter
+ * @param0: first parameter
+ */
+struct dwc3_gadget_ep_cmd_params {
+	u32	param2;
+	u32	param1;
+	u32	param0;
+};
+
 /*
  * DWC3 Features to be used as Driver Data
  */
@@ -902,11 +915,28 @@ static inline void dwc3_host_exit(struct dwc3 *dwc)
 #if IS_ENABLED(CONFIG_USB_DWC3_GADGET) || IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE)
 int dwc3_gadget_init(struct dwc3 *dwc);
 void dwc3_gadget_exit(struct dwc3 *dwc);
+int dwc3_gadget_set_test_mode(struct dwc3 *dwc, int mode);
+int dwc3_gadget_set_link_state(struct dwc3 *dwc, enum dwc3_link_state state);
+int dwc3_send_gadget_ep_cmd(struct dwc3 *dwc, unsigned ep,
+		unsigned cmd, struct dwc3_gadget_ep_cmd_params *params);
+int dwc3_send_gadget_generic_command(struct dwc3 *dwc, int cmd, u32 param);
 #else
 static inline int dwc3_gadget_init(struct dwc3 *dwc)
 { return 0; }
 static inline void dwc3_gadget_exit(struct dwc3 *dwc)
 { }
+static inline int dwc3_gadget_set_test_mode(struct dwc3 *dwc, int mode)
+{ return 0; }
+static inline int dwc3_gadget_set_link_state(struct dwc3 *dwc,
+		enum dwc3_link_state state)
+{ return 0; }
+
+static inline int dwc3_send_gadget_ep_cmd(struct dwc3 *dwc, unsigned ep,
+		unsigned cmd, struct dwc3_gadget_ep_cmd_params *params)
+{ return 0; }
+static inline int dwc3_send_gadget_generic_command(struct dwc3 *dwc,
+		int cmd, u32 param)
+{ return 0; }
 #endif
 
 /* power management interface */
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index 99e6d72..dca9b77 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -76,12 +76,6 @@ struct dwc3;
 /* DEPXFERCFG parameter 0 */
 #define DWC3_DEPXFERCFG_NUM_XFER_RES(n)	((n) & 0xffff)
 
-struct dwc3_gadget_ep_cmd_params {
-	u32	param2;
-	u32	param1;
-	u32	param0;
-};
-
 /* -------------------------------------------------------------------------- */
 
 #define to_dwc3_request(r)	(container_of(r, struct dwc3_request, request))
@@ -105,9 +99,6 @@ static inline void dwc3_gadget_move_request_queued(struct dwc3_request *req)
 void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
 		int status);
 
-int dwc3_gadget_set_test_mode(struct dwc3 *dwc, int mode);
-int dwc3_gadget_set_link_state(struct dwc3 *dwc, enum dwc3_link_state state);
-
 void dwc3_ep0_interrupt(struct dwc3 *dwc,
 		const struct dwc3_event_depevt *event);
 void dwc3_ep0_out_start(struct dwc3 *dwc);
@@ -115,9 +106,6 @@ int dwc3_gadget_ep0_set_halt(struct usb_ep *ep, int value);
 int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 		gfp_t gfp_flags);
 int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value);
-int dwc3_send_gadget_ep_cmd(struct dwc3 *dwc, unsigned ep,
-		unsigned cmd, struct dwc3_gadget_ep_cmd_params *params);
-int dwc3_send_gadget_generic_command(struct dwc3 *dwc, int cmd, u32 param);
 
 /**
  * dwc3_gadget_ep_get_transfer_index - Gets transfer index from HW
-- 
1.9.1

