Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaHFUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:16:27 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:40882 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbaHFUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:15:28 -0400
X-IronPort-AV: E=Sophos;i="5.01,813,1400018400"; 
   d="scan'208";a="88519529"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mfd: menelaus: fix error return code
Date: Wed,  6 Aug 2014 22:12:16 +0200
Message-Id: <1407355938-10932-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a zero return value on error to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
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
 drivers/mfd/menelaus.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 5e2667a..16070d8 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1240,8 +1240,10 @@ static int menelaus_probe(struct i2c_client *client,
 	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
 
 	val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
-	if (val < 0)
+	if (val < 0) {
+		err = val;
 		goto fail;
+	}
 	if (val & (1 << 7))
 		menelaus->vcore_hw_mode = 1;
 	else

