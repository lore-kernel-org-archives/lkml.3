Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbbAPBzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:55:46 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:47426 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbbAPBzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:55:42 -0500
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        jon.nettleton@gmail.com, dsd@laptop.org, jfrederich@gmail.com,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH 1/2] staging: olpc_dcon: check for CONFIG_OLPC before calling olpc_board_at_least()
Date: Thu, 15 Jan 2015 23:54:59 -0200
Message-Id: <1421373300-13672-2-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421373300-13672-1-git-send-email-mopsfelder@gmail.com>
References: <1421373300-13672-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following error messages are thrown by sparse when CONFIG_OLPC is
not defined:

drivers/staging/olpc_dcon/olpc_dcon.c:147:17: error: undefined identifier 'olpc_board_at_least'
drivers/staging/olpc_dcon/olpc_dcon.c:208:14: error: undefined identifier 'olpc_board_at_least'

This patch fixes these errors.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/olpc_dcon/olpc_dcon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 6a9a881..3708f1e 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -144,7 +144,9 @@ power_up:
 	}
 	if (x < 0) {
 		pr_err("unable to stabilize dcon's smbus, reasserting power and praying.\n");
+#ifdef CONFIG_OLPC
 		BUG_ON(olpc_board_at_least(olpc_board(0xc2)));
+#endif
 		pm = 0;
 		olpc_ec_cmd(EC_DCON_POWER_MODE, &pm, 1, NULL, 0);
 		msleep(100);
@@ -205,8 +207,10 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 	if (dcon->asleep == sleep)
 		return;
 
+#ifdef CONFIG_OLPC
 	if (!olpc_board_at_least(olpc_board(0xc2)))
 		return;
+#endif
 
 	if (sleep) {
 		u8 pm = 0;
@@ -795,11 +799,14 @@ struct i2c_driver dcon_driver = {
 
 static int __init olpc_dcon_init(void)
 {
+#ifdef CONFIG_OLPC
 #ifdef CONFIG_FB_OLPC_DCON_1_5
 	/* XO-1.5 */
 	if (olpc_board_at_least(olpc_board(0xd0)))
 		pdata = &dcon_pdata_xo_1_5;
 #endif
+#endif
+
 #ifdef CONFIG_FB_OLPC_DCON_1
 	if (!pdata)
 		pdata = &dcon_pdata_xo_1;
-- 
2.1.0

