Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaHUMGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:06:13 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:59479 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481AbaHUMGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:06:10 -0400
X-IronPort-AV: E=Sophos;i="5.01,908,1400018400"; 
   d="scan'208";a="90261824"
Date: Thu, 21 Aug 2014 07:06:06 -0500 (CDT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Lee Jones <lee.jones@linaro.org>
cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: menelaus: fix error return code
In-Reply-To: <20140821082605.GS4266@lee--X1>
Message-ID: <alpine.DEB.2.10.1408210705250.2534@hadrien>
References: <1407355938-10932-2-git-send-email-Julia.Lawall@lip6.fr> <20140821082605.GS4266@lee--X1>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a zero return value on error to a negative one, as returned
elsewhere in the function.

Additionally, converted 1 << 7 to BIT(7) at the suggestion of Lee Jones.

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
v2: Drop the name "val" and use BIT(7).

 drivers/mfd/menelaus.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 5e2667a..dd3e28d 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1186,7 +1186,7 @@ static int menelaus_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
 	struct menelaus_chip	*menelaus;
-	int			rev = 0, val;
+	int			rev = 0;
 	int			err = 0;
 	struct menelaus_platform_data *menelaus_pdata =
 					dev_get_platdata(&client->dev);
@@ -1239,10 +1239,10 @@ static int menelaus_probe(struct i2c_client *client,

 	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);

-	val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
-	if (val < 0)
+	err = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
+	if (err < 0)
 		goto fail;
-	if (val & (1 << 7))
+	if (err & BIT(7))
 		menelaus->vcore_hw_mode = 1;
 	else
 		menelaus->vcore_hw_mode = 0;
