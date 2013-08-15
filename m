Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657Ab3HOTkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:40:15 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:37082 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434Ab3HOTkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:40:12 -0400
From: Jens Frederich <jfrederich@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dsd@laptop.org, jon.nettleton@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jens Frederich <jfrederich@gmail.com>
Subject: [PATCH 3/3] Staging: olpc_dcon: more big endian conformity
Date: Thu, 15 Aug 2013 21:40:01 +0200
Message-Id: <1376595601-8361-1-git-send-email-jfrederich@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using an int which is casted to unsigned char as inbuf is messy.
The code won't work on big endian systems.  The patch should fix
this.

Signed-off-by: Jens Frederich <jfrederich@gmail.com>

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 5ca4fa4..198595e 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -122,12 +122,13 @@ err:
 static int dcon_bus_stabilize(struct dcon_priv *dcon, int is_powered_down)
 {
 	unsigned long timeout;
+	u8 pm;
 	int x;
 
 power_up:
 	if (is_powered_down) {
-		x = 1;
-		x = olpc_ec_cmd(EC_DCON_POWER_MODE, (u8 *)&x, 1, NULL, 0);
+		pm = 1;
+		x = olpc_ec_cmd(EC_DCON_POWER_MODE, &pm, 1, NULL, 0);
 		if (x) {
 			pr_warn("unable to force dcon to power up: %d!\n", x);
 			return x;
@@ -144,8 +145,8 @@ power_up:
 	if (x < 0) {
 		pr_err("unable to stabilize dcon's smbus, reasserting power and praying.\n");
 		BUG_ON(olpc_board_at_least(olpc_board(0xc2)));
-		x = 0;
-		olpc_ec_cmd(EC_DCON_POWER_MODE, (u8 *)&x, 1, NULL, 0);
+		pm = 0;
+		olpc_ec_cmd(EC_DCON_POWER_MODE, &pm, 1, NULL, 0);
 		msleep(100);
 		is_powered_down = 1;
 		goto power_up;	/* argh, stupid hardware.. */
@@ -208,8 +209,8 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 		return;
 
 	if (sleep) {
-		x = 0;
-		x = olpc_ec_cmd(EC_DCON_POWER_MODE, (u8 *)&x, 1, NULL, 0);
+		u8 pm = 0;
+		x = olpc_ec_cmd(EC_DCON_POWER_MODE, &pm, 1, NULL, 0);
 		if (x)
 			pr_warn("unable to force dcon to power down: %d!\n", x);
 		else
-- 
1.7.9.5

