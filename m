Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaLZOmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:42:46 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17526 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbaLZOm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:28 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895459"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/27] xhci-mem: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:40 +0100
Message-Id: <1419604558-29743-10-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a call to init_timer and accompanying intializations of
the timer's data and function fields to a call to setup_timer.

A simplified version of the semantic match that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression t,f,d;
@@

-init_timer(&t);
+setup_timer(&t,f,d);
-t.data = d;
-t.function = f;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/usb/host/xhci-mem.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 5cb3d7a..e72265c 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -833,9 +833,8 @@ void xhci_free_stream_info(struct xhci_hcd *xhci,
 static void xhci_init_endpoint_timer(struct xhci_hcd *xhci,
 		struct xhci_virt_ep *ep)
 {
-	init_timer(&ep->stop_cmd_timer);
-	ep->stop_cmd_timer.data = (unsigned long) ep;
-	ep->stop_cmd_timer.function = xhci_stop_endpoint_command_watchdog;
+	setup_timer(&ep->stop_cmd_timer, xhci_stop_endpoint_command_watchdog,
+		    (unsigned long)ep);
 	ep->xhci = xhci;
 }
 
@@ -2509,9 +2508,8 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	xhci_print_ir_set(xhci, 0);
 
 	/* init command timeout timer */
-	init_timer(&xhci->cmd_timer);
-	xhci->cmd_timer.data = (unsigned long) xhci;
-	xhci->cmd_timer.function = xhci_handle_command_timeout;
+	setup_timer(&xhci->cmd_timer, xhci_handle_command_timeout,
+		    (unsigned long)xhci);
 
 	/*
 	 * XXX: Might need to set the Interrupter Moderation Register to

