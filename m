Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbaHGMwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:52:21 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:48815 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756266AbaHGMwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:52:19 -0400
X-IronPort-AV: E=Sophos;i="5.01,818,1400018400"; 
   d="scan'208";a="88599291"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] avr32: fix error return code
Date: Thu,  7 Aug 2014 14:49:05 +0200
Message-Id: <1407415749-19978-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr>
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
 arch/avr32/boards/hammerhead/flash.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/avr32/boards/hammerhead/flash.c b/arch/avr32/boards/hammerhead/flash.c
index 776c3cb..e86280c 100644
--- a/arch/avr32/boards/hammerhead/flash.c
+++ b/arch/avr32/boards/hammerhead/flash.c
@@ -190,14 +190,19 @@ static int __init hammerhead_usbh_init(void)
 
 	/* setup gclk0 to run from osc1 */
 	gclk = clk_get(NULL, "gclk0");
-	if (IS_ERR(gclk))
+	if (IS_ERR(gclk)) {
+		ret = PTR_ERR(gclk);
 		goto err_gclk;
+	}
 
 	osc = clk_get(NULL, "osc1");
-	if (IS_ERR(osc))
+	if (IS_ERR(osc)) {
+		ret = PTR_ERR(osc);
 		goto err_osc;
+	}
 
-	if (clk_set_parent(gclk, osc)) {
+	ret = clk_set_parent(gclk, osc);
+	if (ret < 0) {
 		pr_debug("hammerhead: failed to set osc1 for USBH clock\n");
 		goto err_set_clk;
 	}

