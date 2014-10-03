Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbaJCW5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:57:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbaJCWYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Manuel Reimer <manuel.reimer@gmx.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.10 052/143] xhci: Fix null pointer dereference if xhci initialization fails
Date: Fri,  3 Oct 2014 14:34:07 -0700
Message-Id: <20141003213316.045521778@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit c207e7c50f31113c24a9f536fcab1e8a256985d7 upstream.

If xhci initialization fails before the roothub bandwidth
domains (xhci->rh_bw[i]) are allocated it will oops when
trying to access rh_bw members in xhci_mem_cleanup().

Reported-by: Manuel Reimer <manuel.reimer@gmx.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1795,7 +1795,7 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 	}
 
 	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
-	for (i = 0; i < num_ports; i++) {
+	for (i = 0; i < num_ports && xhci->rh_bw; i++) {
 		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
 		for (j = 0; j < XHCI_MAX_INTERVAL; j++) {
 			struct list_head *ep = &bwt->interval_bw[j].endpoints;


