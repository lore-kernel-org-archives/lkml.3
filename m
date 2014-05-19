Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaESEgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:36:01 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14034 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbaESEcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:32:52 -0400
X-IronPort-AV: E=Sophos;i="4.98,865,1392159600"; 
   d="scan'208";a="74474217"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Felipe Balbi <balbi@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/13] usb: gadget: make return of 0 explicit
Date: Mon, 19 May 2014 06:31:07 +0200
Message-Id: <1400473875-22228-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete unnecessary local variable whose value is always 0 and that hides
the fact that the result is always 0.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression ret;
expression e;
position p;
@@

-ret = 0;
... when != ret = e
return 
- ret
+ 0
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/usb/gadget/composite.c |    6 ++----
 drivers/usb/gadget/dummy_hcd.c |    4 +---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 042c66b..f801519 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1312,9 +1312,7 @@ static void fill_ext_compat(struct usb_configuration *c, u8 *buf)
 static int count_ext_prop(struct usb_configuration *c, int interface)
 {
 	struct usb_function *f;
-	int j, res;
-
-	res = 0;
+	int j;
 
 	f = c->interface[interface];
 	for (j = 0; j < f->os_desc_n; ++j) {
@@ -1326,7 +1324,7 @@ static int count_ext_prop(struct usb_configuration *c, int interface)
 		if (d && d->ext_compat_id)
 			return d->ext_prop_count;
 	}
-	return res;
+	return 0;
 }
 
 static int len_ext_prop(struct usb_configuration *c, int interface)
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 8c06430..2b54955 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -561,7 +561,6 @@ static int dummy_disable(struct usb_ep *_ep)
 	struct dummy_ep		*ep;
 	struct dummy		*dum;
 	unsigned long		flags;
-	int			retval;
 
 	ep = usb_ep_to_dummy_ep(_ep);
 	if (!_ep || !ep->desc || _ep->name == ep0name)
@@ -571,12 +570,11 @@ static int dummy_disable(struct usb_ep *_ep)
 	spin_lock_irqsave(&dum->lock, flags);
 	ep->desc = NULL;
 	ep->stream_en = 0;
-	retval = 0;
 	nuke(dum, ep);
 	spin_unlock_irqrestore(&dum->lock, flags);
 
 	dev_dbg(udc_dev(dum), "disabled %s\n", _ep->name);
-	return retval;
+	return 0;
 }
 
 static struct usb_request *dummy_alloc_request(struct usb_ep *_ep,

