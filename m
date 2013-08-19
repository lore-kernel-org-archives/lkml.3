Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab3HSLrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:47:46 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:8765 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286Ab3HSLro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:47:44 -0400
X-IronPort-AV: E=Sophos;i="4.89,913,1367964000"; 
   d="scan'208";a="24235116"
Date: Mon, 19 Aug 2013 13:47:23 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: =?ISO-8859-15?Q?Svenning_S=F8rensen?= <sss@secomea.dk>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Felipe Balbi <balbi@ti.com>,
        kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6 v2] usb: musb: dsps: simplify
 platform_get_resource_byname/devm_ioremap_resource
In-Reply-To: <5211FED3.4090102@secomea.dk>
Message-ID: <alpine.DEB.2.02.1308191346390.2313@hadrien>
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr> <1376902316-18520-5-git-send-email-Julia.Lawall@lip6.fr> <5211FED3.4090102@secomea.dk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1786006515-1376912843=:2313"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1786006515-1376912843=:2313
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource_byname when the value is passed to
devm_ioremap_resource.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,e,e1;
expression ret != 0;
identifier l;
@@

  res = platform_get_resource_byname(...);
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  e = devm_ioremap_resource(e1, res);
// </smpl>

This patch also adjusts the error-handling code on the call to
devm_ioremap_resource to check the right value, noticed by Svenning Sørensen.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
v2: Fixed the bug on the test of the result of devm_ioremap_resource

 drivers/usb/musb/musb_dsps.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 4ffbaac..e60be6f 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -357,12 +357,9 @@ static int dsps_musb_init(struct musb *musb)
 	u32 rev, val;

 	r = platform_get_resource_byname(parent, IORESOURCE_MEM, "control");
-	if (!r)
-		return -EINVAL;
-
 	reg_base = devm_ioremap_resource(dev, r);
-	if (!musb->ctrl_base)
-		return -EINVAL;
+        if (IS_ERR(reg_base))
+		return PTR_ERR(reg_base);
 	musb->ctrl_base = reg_base;

 	/* NOP driver needs change if supporting dual instance */
--8323329-1786006515-1376912843=:2313--
