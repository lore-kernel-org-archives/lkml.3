Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaIKNTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:19:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51492 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Christopher Alexander Tobias Schulze" <cat.schulze@alice-dsl.net>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.171064389@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 117/131] bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
index 5426682..7179f72 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -301,13 +301,18 @@ static struct bbc_i2c_bus * __init attach_one_i2c(struct platform_device *op, in
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

