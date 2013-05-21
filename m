Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3EUKlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:41:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:51966 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab3EUKkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:40:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="305622746"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: linux-usb@vger.kernel.org
Cc: <sarah.a.sharp@intel.com>, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: =?UTF-8?q?=5BRFC=20PATCH=20v2=201/4=5D=20usb=3A=20xhci=3A=20check=20usb2=20port=20capabilities=20before=20adding=20hw=20link=20PM=20support?=
Date: Tue, 21 May 2013 13:43:34 +0300
Message-Id: <1369133017-3035-2-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1369133017-3035-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1369133017-3035-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware link powermanagement in usb2 is a per-port capability.
Previously support for hw lpm was enabled for all ports if any usb2 port supported it.

Now instead cache the capability values and check them for each port individually

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-mem.c |   33 +++++++++++++++++++++++++++++----
 drivers/usb/host/xhci.c     |   27 ++++++++++++++++++++++++++-
 drivers/usb/host/xhci.h     |    3 +++
 3 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 965b539..5fd97d1 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1851,6 +1851,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	kfree(xhci->usb3_ports);
 	kfree(xhci->port_array);
 	kfree(xhci->rh_bw);
+	kfree(xhci->ext_caps);
 
 	xhci->page_size = 0;
 	xhci->page_shift = 0;
@@ -2038,7 +2039,7 @@ static void xhci_set_hc_event_deq(struct xhci_hcd *xhci)
 }
 
 static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
-		__le32 __iomem *addr, u8 major_revision)
+		__le32 __iomem *addr, u8 major_revision, int max_caps)
 {
 	u32 temp, port_offset, port_count;
 	int i;
@@ -2063,6 +2064,10 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 		/* WTF? "Valid values are ‘1’ to MaxPorts" */
 		return;
 
+	/* cache usb2 port capabilities */
+	if (major_revision < 0x03 && xhci->num_ext_caps < max_caps)
+		xhci->ext_caps[xhci->num_ext_caps++] = temp;
+
 	/* Check the host's USB2 LPM capability */
 	if ((xhci->hci_version == 0x96) && (major_revision != 0x03) &&
 			(temp & XHCI_L1C)) {
@@ -2120,10 +2125,11 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
  */
 static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
 {
-	__le32 __iomem *addr;
-	u32 offset;
+	__le32 __iomem *addr, *tmp_addr;
+	u32 offset, tmp_offset;
 	unsigned int num_ports;
 	int i, j, port_index;
+	int cap_count = 0;
 
 	addr = &xhci->cap_regs->hcc_params;
 	offset = XHCI_HCC_EXT_CAPS(xhci_readl(xhci, addr));
@@ -2156,13 +2162,32 @@ static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
 	 * See section 5.3.6 for offset calculation.
 	 */
 	addr = &xhci->cap_regs->hc_capbase + offset;
+
+	tmp_addr = addr;
+	tmp_offset = offset;
+
+	/* count extended protocol capability entries for later caching */
+	do {
+		u32 cap_id;
+		cap_id = xhci_readl(xhci, tmp_addr);
+		if (XHCI_EXT_CAPS_ID(cap_id) == XHCI_EXT_CAPS_PROTOCOL)
+			cap_count++;
+		tmp_offset = XHCI_EXT_CAPS_NEXT(cap_id);
+		tmp_addr += tmp_offset;
+	} while (tmp_offset);
+
+	xhci->ext_caps = kzalloc(sizeof(*xhci->ext_caps) * cap_count, flags);
+	if (!xhci->ext_caps)
+		return -ENOMEM;
+
 	while (1) {
 		u32 cap_id;
 
 		cap_id = xhci_readl(xhci, addr);
 		if (XHCI_EXT_CAPS_ID(cap_id) == XHCI_EXT_CAPS_PROTOCOL)
 			xhci_add_in_port(xhci, num_ports, addr,
-					(u8) XHCI_EXT_PORT_MAJOR(cap_id));
+					(u8) XHCI_EXT_PORT_MAJOR(cap_id),
+					cap_count);
 		offset = XHCI_EXT_CAPS_NEXT(cap_id);
 		if (!offset || (xhci->num_usb2_ports + xhci->num_usb3_ports)
 				== num_ports)
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index b4aa79d..e540a36 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4023,15 +4023,40 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 	return 0;
 }
 
+/* check if a usb2 port supports a given extened capability protocol
+ * only USB2 ports extended protocol capability values are cached.
+ * Return 1 if capability is supported
+ */
+static int xhci_check_usb2_port_capability(struct xhci_hcd *xhci, int port,
+					   unsigned capability)
+{
+	u32 port_offset, port_count;
+	int i;
+
+	for (i = 0; i < xhci->num_ext_caps; i++) {
+		if (xhci->ext_caps[i] & capability) {
+			/* port offsets starts at 1 */
+			port_offset = XHCI_EXT_PORT_OFF(xhci->ext_caps[i]) - 1;
+			port_count = XHCI_EXT_PORT_COUNT(xhci->ext_caps[i]);
+			if (port >= port_offset &&
+			    port < port_offset + port_count)
+				return 1;
+		}
+	}
+	return 0;
+}
+
 int xhci_update_device(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	int		ret;
+	int		portnum = udev->portnum - 1;
 
 	ret = xhci_usb2_software_lpm_test(hcd, udev);
 	if (!ret) {
 		xhci_dbg(xhci, "software LPM test succeed\n");
-		if (xhci->hw_lpm_support == 1) {
+		if (xhci->hw_lpm_support == 1 &&
+		    xhci_check_usb2_port_capability(xhci, portnum, XHCI_HLC)) {
 			udev->usb2_hw_lpm_capable = 1;
 			ret = xhci_set_usb2_hardware_lpm(hcd, udev, 1);
 			if (!ret)
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 29c978e..1dbc63f 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1532,6 +1532,9 @@ struct xhci_hcd {
 	unsigned		sw_lpm_support:1;
 	/* support xHCI 1.0 spec USB2 hardware LPM */
 	unsigned		hw_lpm_support:1;
+	/* cached usb2 extened protocol capabilites */
+	u32                     *ext_caps;
+	unsigned int            num_ext_caps;
 	/* Compliance Mode Recovery Data */
 	struct timer_list	comp_mode_recovery_timer;
 	u32			port_status_u0;
-- 
1.7.4.1

