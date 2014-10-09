Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbaJIVUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:20:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59604 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaJIVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 056/163] xhci: Fix null pointer dereference if xhci initialization fails
Date: Thu,  9 Oct 2014 14:01:21 -0700
Message-Id: <1412888588-26755-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit c207e7c50f31113c24a9f536fcab1e8a256985d7 upstream.

If xhci initialization fails before the roothub bandwidth
domains (xhci->rh_bw[i]) are allocated it will oops when
trying to access rh_bw members in xhci_mem_cleanup().

Reported-by: Manuel Reimer <manuel.reimer@gmx.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 4483e6a..837c333 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1723,7 +1723,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	}
 
 	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
-	for (i = 0; i < num_ports; i++) {
+	for (i = 0; i < num_ports && xhci->rh_bw; i++) {
 		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
 		for (j = 0; j < XHCI_MAX_INTERVAL; j++) {
 			struct list_head *ep = &bwt->interval_bw[j].endpoints;
-- 
1.9.1

