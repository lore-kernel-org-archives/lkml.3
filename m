Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab3HSQAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:00:17 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:19229 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab3HSQAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:00:14 -0400
X-IronPort-AV: E=Sophos;i="4.89,914,1367964000"; 
   d="scan'208";a="29764504"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Felipe Balbi <balbi@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: musb: dsps: fix devm_ioremap_resource error detection code
Date: Mon, 19 Aug 2013 18:00:08 +0200
Message-Id: <1376928009-25637-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_ioremap_resource returns an ERR_PTR value, not NULL, on failure.
Furthermore, the value returned by devm_ioremap_resource should be tested.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1;
statement S;
@@

*e = devm_ioremap_resource(...);
if (!e1) S

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/usb/musb/musb_dsps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 4ffbaac..4ad52e7 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -361,8 +361,8 @@ static int dsps_musb_init(struct musb *musb)
 		return -EINVAL;
 
 	reg_base = devm_ioremap_resource(dev, r);
-	if (!musb->ctrl_base)
-		return -EINVAL;
+	if (IS_ERR(reg_base))
+		return PTR_ERR(reg_base);
 	musb->ctrl_base = reg_base;
 
 	/* NOP driver needs change if supporting dual instance */

