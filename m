Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaHHVlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:41:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866AbaHHVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:41:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher Alexander Tobias Schulze 
	<cat.schulze@alice-dsl.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 14/17] bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
Date: Fri,  8 Aug 2014 14:35:36 -0700
Message-Id: <20140808213458.097477228@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213457.511493898@linuxfoundation.org>
References: <20140808213457.511493898@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/sbus/char/bbc_envctrl.c |    6 ++++++
 drivers/sbus/char/bbc_i2c.c     |   11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/sbus/char/bbc_envctrl.c
+++ b/drivers/sbus/char/bbc_envctrl.c
@@ -452,6 +452,9 @@ static void attach_one_temp(struct bbc_i
 	if (!tp)
 		return;
 
+	INIT_LIST_HEAD(&tp->bp_list);
+	INIT_LIST_HEAD(&tp->glob_list);
+
 	tp->client = bbc_i2c_attach(bp, op);
 	if (!tp->client) {
 		kfree(tp);
@@ -497,6 +500,9 @@ static void attach_one_fan(struct bbc_i2
 	if (!fp)
 		return;
 
+	INIT_LIST_HEAD(&fp->bp_list);
+	INIT_LIST_HEAD(&fp->glob_list);
+
 	fp->client = bbc_i2c_attach(bp, op);
 	if (!fp->client) {
 		kfree(fp);
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -300,13 +300,18 @@ static struct bbc_i2c_bus * attach_one_i
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


