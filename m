Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaEZUVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:21:41 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64194 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaEZUVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:21:39 -0400
Date: Tue, 27 May 2014 01:51:31 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Anatolij Gustschin <agust@denx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] powerpc: Introduce the use of the managed version of kzalloc
Message-ID: <20140526202130.GA16360@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfree in probe function.

The following Coccinelle semantic patch was used for making the change:

@platform@
identifier p, probefn, removefn;
@@
struct platform_driver p = {
  .probe = probefn,
  .remove = removefn,
};

@prb@
identifier platform.probefn, pdev;
expression e, e1, e2;
@@
probefn(struct platform_device *pdev, ...) {
  <+...
- e = kzalloc(e1, e2)
+ e = devm_kzalloc(&pdev->dev, e1, e2)
  ...
?-kfree(e);
  ...+>
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Not compile tested
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 6929982..37343a6 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -724,7 +724,7 @@ static int mpc52xx_gpt_probe(struct platform_device *ofdev)
 {
 	struct mpc52xx_gpt_priv *gpt;
 
-	gpt = kzalloc(sizeof *gpt, GFP_KERNEL);
+	gpt = devm_kzalloc(&ofdev->dev, sizeof *gpt, GFP_KERNEL);
 	if (!gpt)
 		return -ENOMEM;
 
@@ -732,10 +732,8 @@ static int mpc52xx_gpt_probe(struct platform_device *ofdev)
 	gpt->dev = &ofdev->dev;
 	gpt->ipb_freq = mpc5xxx_get_bus_frequency(ofdev->dev.of_node);
 	gpt->regs = of_iomap(ofdev->dev.of_node, 0);
-	if (!gpt->regs) {
-		kfree(gpt);
+	if (!gpt->regs)
 		return -ENOMEM;
-	}
 
 	dev_set_drvdata(&ofdev->dev, gpt);
 
-- 
1.9.1

