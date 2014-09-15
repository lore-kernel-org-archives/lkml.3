Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbaIOWSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:18:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51079 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758157AbaIOWSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:18:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 031/187] bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
Date: Mon, 15 Sep 2014 15:07:21 -0700
Message-Id: <1410818997-9432-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>

[ Upstream commit 5cdceab3d5e02eb69ea0f5d8fa9181800baf6f77 ]

Fix regression in bbc i2c temperature and fan control on some Sun systems
that causes the driver to refuse to load due to the bbc_i2c_bussel resource not
being present on the (second) i2c bus where the temperature sensors and fan
control are located. (The check for the number of resources was removed when
the driver was ported to a pure OF driver in mid 2008.)

Signed-off-by: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/sbus/char/bbc_envctrl.c |  6 ++++++
 drivers/sbus/char/bbc_i2c.c     | 11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/sbus/char/bbc_envctrl.c b/drivers/sbus/char/bbc_envctrl.c
index 160e751..0787b97 100644
--- a/drivers/sbus/char/bbc_envctrl.c
+++ b/drivers/sbus/char/bbc_envctrl.c
@@ -452,6 +452,9 @@ static void attach_one_temp(struct bbc_i2c_bus *bp, struct platform_device *op,
 	if (!tp)
 		return;
 
+	INIT_LIST_HEAD(&tp->bp_list);
+	INIT_LIST_HEAD(&tp->glob_list);
+
 	tp->client = bbc_i2c_attach(bp, op);
 	if (!tp->client) {
 		kfree(tp);
@@ -497,6 +500,9 @@ static void attach_one_fan(struct bbc_i2c_bus *bp, struct platform_device *op,
 	if (!fp)
 		return;
 
+	INIT_LIST_HEAD(&fp->bp_list);
+	INIT_LIST_HEAD(&fp->glob_list);
+
 	fp->client = bbc_i2c_attach(bp, op);
 	if (!fp->client) {
 		kfree(fp);
diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
index c1441ed..e0e6cd6 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -301,13 +301,18 @@ static struct bbc_i2c_bus * attach_one_i2c(struct platform_device *op, int index
 	if (!bp)
 		return NULL;
 
+	INIT_LIST_HEAD(&bp->temps);
+	INIT_LIST_HEAD(&bp->fans);
+
 	bp->i2c_control_regs = of_ioremap(&op->resource[0], 0, 0x2, "bbc_i2c_regs");
 	if (!bp->i2c_control_regs)
 		goto fail;
 
-	bp->i2c_bussel_reg = of_ioremap(&op->resource[1], 0, 0x1, "bbc_i2c_bussel");
-	if (!bp->i2c_bussel_reg)
-		goto fail;
+	if (op->num_resources == 2) {
+		bp->i2c_bussel_reg = of_ioremap(&op->resource[1], 0, 0x1, "bbc_i2c_bussel");
+		if (!bp->i2c_bussel_reg)
+			goto fail;
+	}
 
 	bp->waiting = 0;
 	init_waitqueue_head(&bp->wq);
-- 
1.9.1

