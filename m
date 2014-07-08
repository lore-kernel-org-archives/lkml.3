Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaGHTLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:11:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54309 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755802AbaGHTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Ville =?UTF-8?Q?Syrj=C3=A4l=C3=A4?=" <ville.syrjala@linux.intel.com>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.870157017@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 048/125] xhci: delete endpoints from bandwidth list
 before freeing whole device
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 5dc2808c4729bf080487e61b80ee04e0fdb12a37 upstream.

Lists of endpoints are stored for bandwidth calculation for roothub ports.
Make sure we remove all endpoints from the list before the whole device,
containing its endpoints list_head stuctures, is freed.

This used to be done in the wrong order in xhci_mem_cleanup(),
and triggered an oops in resume from S4 (hibernate).

Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-mem.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1722,6 +1722,16 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 		kfree(cur_cd);
 	}
 
+	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
+	for (i = 0; i < num_ports; i++) {
+		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
+		for (j = 0; j < XHCI_MAX_INTERVAL; j++) {
+			struct list_head *ep = &bwt->interval_bw[j].endpoints;
+			while (!list_empty(ep))
+				list_del_init(ep->next);
+		}
+	}
+
 	for (i = 1; i < MAX_HC_SLOTS; ++i)
 		xhci_free_virt_device(xhci, i);
 
@@ -1762,16 +1772,6 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 	if (!xhci->rh_bw)
 		goto no_bw;
 
-	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
-	for (i = 0; i < num_ports; i++) {
-		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
-		for (j = 0; j < XHCI_MAX_INTERVAL; j++) {
-			struct list_head *ep = &bwt->interval_bw[j].endpoints;
-			while (!list_empty(ep))
-				list_del_init(ep->next);
-		}
-	}
-
 	for (i = 0; i < num_ports; i++) {
 		struct xhci_tt_bw_info *tt, *n;
 		list_for_each_entry_safe(tt, n, &xhci->rh_bw[i].tts, tt_list) {

