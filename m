Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaHIQke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 12:40:34 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33287 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaHIQkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 12:40:33 -0400
Date: Sat, 9 Aug 2014 22:10:27 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] mfd: menelaus: remove null pointer dereference
Message-ID: <20140809164027.GA20561@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If vtg is NULL, it is not possible to access its mode_reg field. At all
sites where the static function menelaus_set_voltage is called, the first
argument is the address of a structure defined in the file. So, the null
test is unnecessary and is removed. Also, a label is done away with.

This problem was found using the following Coccinelle semantic match:

// <smpl>
@@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

* if (E == NULL)
{
  ... when != if (E == NULL) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Not compile tested.
 drivers/mfd/menelaus.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 5e2667a..18ff56f 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -466,8 +466,6 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
 	struct i2c_client *c = the_menelaus->client;
 
 	mutex_lock(&the_menelaus->lock);
-	if (!vtg)
-		goto set_voltage;
 
 	ret = menelaus_read_reg(vtg->vtg_reg);
 	if (ret < 0)
@@ -482,7 +480,6 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
 	ret = menelaus_write_reg(vtg->vtg_reg, val);
 	if (ret < 0)
 		goto out;
-set_voltage:
 	ret = menelaus_write_reg(vtg->mode_reg, mode);
 out:
 	mutex_unlock(&the_menelaus->lock);
-- 
1.9.1

