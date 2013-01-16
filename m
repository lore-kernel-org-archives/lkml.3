Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3APP6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:58:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab3APP56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:57:58 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 009/222] usb: gadget: phonet: free requests in pn_bind()'s error path
Date: Wed, 16 Jan 2013 13:53:29 -0200
Message-Id: <1358351822-7675-10-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit d0eca719dd11ad0619e8dd6a1f3eceb95b0216dd upstream.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/gadget/f_phonet.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_phonet.c b/drivers/usb/gadget/f_phonet.c
index 965a629..16512f9 100644
--- a/drivers/usb/gadget/f_phonet.c
+++ b/drivers/usb/gadget/f_phonet.c
@@ -531,7 +531,7 @@ int pn_bind(struct usb_configuration *c, struct usb_function *f)
 
 		req = usb_ep_alloc_request(fp->out_ep, GFP_KERNEL);
 		if (!req)
-			goto err;
+			goto err_req;
 
 		req->complete = pn_rx_complete;
 		fp->out_reqv[i] = req;
@@ -540,14 +540,18 @@ int pn_bind(struct usb_configuration *c, struct usb_function *f)
 	/* Outgoing USB requests */
 	fp->in_req = usb_ep_alloc_request(fp->in_ep, GFP_KERNEL);
 	if (!fp->in_req)
-		goto err;
+		goto err_req;
 
 	INFO(cdev, "USB CDC Phonet function\n");
 	INFO(cdev, "using %s, OUT %s, IN %s\n", cdev->gadget->name,
 		fp->out_ep->name, fp->in_ep->name);
 	return 0;
 
+err_req:
+	for (i = 0; i < phonet_rxq_size && fp->out_reqv[i]; i++)
+		usb_ep_free_request(fp->out_ep, fp->out_reqv[i]);
 err:
+
 	if (fp->out_ep)
 		fp->out_ep->driver_data = NULL;
 	if (fp->in_ep)
-- 
1.7.9.5

