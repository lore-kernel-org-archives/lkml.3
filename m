Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaFPIVC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:21:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44776 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbaFPIVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:21:00 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-7e-539ea8e9ae9b
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] usb: gadget: add claimed field in struct usb_ep
Date: Mon, 16 Jun 2014 10:20:36 +0200
Message-id: <1402906836-12733-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t9jAd1XK+YFGyzpYbOY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktHhzeye7A7rF/7hp2j74tqxg9jt/YzuTxeZNcAEsUl01K
	ak5mWWqRvl0CV0bzl+CCleIVj3/UNjC+Eepi5OSQEDCR+HP8LROELSZx4d56ti5GLg4hgUWM
	Er+aZ7FDOO1MEk2f+5lBqtgEdCS2fJ/ACGKLCAhIrH9xCayIWWALo0Tzoz+sXYwcHMICDhI/
	doaD1LAIqEp0b1vDAmLzCrhKLJp3hhVim5zEyWOTWScwci9gZFjFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJERwWz6R2MK5ssDjEKMDBqMTDO8FxXrAQa2JZcWXuIUYJDmYlEd7bi4BCvCmJ
	lVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGA0jNkQ7Se+9oG1/
	cmX2tthD7FfSdtq4TXtoN/fXr123uswcj7Xvaz13NDOI4+mmI4KLbNUesBQunC/P0/CwMmzl
	zvCT+5af7oue5SUyb2Xn7Pn/F/quiuw/0axbyMNxc9V6xmXiqhJy/z4a8No5/vqffSE/+vop
	hdgPJmtUfeXudcs2xx8/VaTEUpyRaKjFXFScCAAM7+0/BwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field allows to mark ep as claimed in more clear way. Claiming
endpoint by setting driver_data to non-null value is leaky solution
and makes code unreadable.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/epautoconf.c | 11 ++++++-----
 include/linux/usb/gadget.h      |  1 +
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index b1c5c0d..7acb933 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -54,7 +54,7 @@ ep_matches (
 	int		num_req_streams = 0;
 
 	/* endpoint already claimed? */
-	if (NULL != ep->driver_data)
+	if (ep->claimed)
 		return 0;
 
 	/* only support ep0 for portable CONTROL traffic */
@@ -241,7 +241,7 @@ find_ep (struct usb_gadget *gadget, const char *name)
  * updated with the assigned number of streams if it is
  * different from the original value. To prevent the endpoint
  * from being returned by a later autoconfig call, claim it by
- * assigning ep->driver_data to some non-null value.
+ * assigning ep->claimed to true.
  *
  * On failure, this returns a null endpoint descriptor.
  */
@@ -314,6 +314,7 @@ struct usb_ep *usb_ep_autoconfig_ss(
 found_ep:
 	ep->desc = NULL;
 	ep->comp_desc = NULL;
+	ep->claimed = true;
 	return ep;
 }
 EXPORT_SYMBOL_GPL(usb_ep_autoconfig_ss);
@@ -345,7 +346,7 @@ EXPORT_SYMBOL_GPL(usb_ep_autoconfig_ss);
  * descriptor bEndpointAddress.  For bulk endpoints, the wMaxPacket value
  * is initialized as if the endpoint were used at full speed.  To prevent
  * the endpoint from being returned by a later autoconfig call, claim it
- * by assigning ep->driver_data to some non-null value.
+ * by assigning ep->claimed to true.
  *
  * On failure, this returns a null endpoint descriptor.
  */
@@ -364,7 +365,7 @@ EXPORT_SYMBOL_GPL(usb_ep_autoconfig);
  *
  * Use this for devices where one configuration may need to assign
  * endpoint resources very differently from the next one.  It clears
- * state such as ep->driver_data and the record of assigned endpoints
+ * state such as ep->claimed and the record of assigned endpoints
  * used by usb_ep_autoconfig().
  */
 void usb_ep_autoconfig_reset (struct usb_gadget *gadget)
@@ -372,7 +373,7 @@ void usb_ep_autoconfig_reset (struct usb_gadget *gadget)
 	struct usb_ep	*ep;
 
 	list_for_each_entry (ep, &gadget->ep_list, ep_list) {
-		ep->driver_data = NULL;
+		ep->claimed = false;
 	}
 	gadget->in_epnum = 0;
 	gadget->out_epnum = 0;
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index a7ae4db..b3a9297 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -172,6 +172,7 @@ struct usb_ep {
 	const char		*name;
 	const struct usb_ep_ops	*ops;
 	struct list_head	ep_list;
+	bool			claimed;
 	unsigned		maxpacket:16;
 	unsigned		maxpacket_limit:16;
 	unsigned		max_streams:16;
-- 
1.9.1

