Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaFWIw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:52:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55535 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 041/111] xhci: delete endpoints from bandwidth list before freeing whole device
Date: Mon, 23 Jun 2014 10:31:16 +0200
Message-Id: <1f405c3d18c969477fa07f0f55cedd71d946e34e.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5dc2808c4729bf080487e61b80ee04e0fdb12a37 upstream.

Lists of endpoints are stored for bandwidth calculation for roothub ports.
Make sure we remove all endpoints from the list before the whole device,
containing its endpoints list_head stuctures, is freed.

This used to be done in the wrong order in xhci_mem_cleanup(),
and triggered an oops in resume from S4 (hibernate).

Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/xhci-mem.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 49b8bd063fab..4483e6a307c0 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1722,6 +1722,16 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
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
 
@@ -1757,16 +1767,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
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
-- 
2.0.0

