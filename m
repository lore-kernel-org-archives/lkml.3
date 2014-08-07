Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaHGVBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:01:44 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:10639 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbaHGVBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:01:00 -0400
X-IronPort-AV: E=Sophos;i="5.01,820,1400018400"; 
   d="scan'208";a="88647126"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Felipe Balbi <balbi@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] usb: gadget: fix error return code
Date: Thu,  7 Aug 2014 22:57:47 +0200
Message-Id: <1407445067-4044-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a zero return value on error to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/usb/gadget/udc/fusb300_udc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/fusb300_udc.c b/drivers/usb/gadget/udc/fusb300_udc.c
index d40255f..5c5d1ad 100644
--- a/drivers/usb/gadget/udc/fusb300_udc.c
+++ b/drivers/usb/gadget/udc/fusb300_udc.c
@@ -1398,13 +1398,17 @@ static int fusb300_probe(struct platform_device *pdev)
 
 	/* initialize udc */
 	fusb300 = kzalloc(sizeof(struct fusb300), GFP_KERNEL);
-	if (fusb300 == NULL)
+	if (fusb300 == NULL) {
+		ret = -ENOMEM;
 		goto clean_up;
+	}
 
 	for (i = 0; i < FUSB300_MAX_NUM_EP; i++) {
 		_ep[i] = kzalloc(sizeof(struct fusb300_ep), GFP_KERNEL);
-		if (_ep[i] == NULL)
+		if (_ep[i] == NULL) {
+			ret = -ENOMEM;
 			goto clean_up;
+		}
 		fusb300->ep[i] = _ep[i];
 	}
 

