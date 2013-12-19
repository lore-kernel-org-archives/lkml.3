Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3LSMTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:19:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45147 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab3LSL6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 149/208] [media] af9033: fix broken I2C
Date: Thu, 19 Dec 2013 11:54:07 +0000
Message-Id: <1387454106-19326-150-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit d18a88b1f535d627412b2a265d71b2f7d464860e upstream.

Driver did not work anymore since I2C has gone broken due
to recent commit:
commit 37ebaf6891ee81687bb558e8375c0712d8264ed8
[media] dvb-frontends: Don't use dynamic static allocation

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-frontends/af9033.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 30ee590..65728c2 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -170,18 +170,18 @@ static int af9033_rd_reg_mask(struct af9033_state *state, u32 reg, u8 *val,
 static int af9033_wr_reg_val_tab(struct af9033_state *state,
 		const struct reg_val *tab, int tab_len)
 {
+#define MAX_TAB_LEN 212
 	int ret, i, j;
-	u8 buf[MAX_XFER_SIZE];
+	u8 buf[1 + MAX_TAB_LEN];
+
+	dev_dbg(&state->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
 
 	if (tab_len > sizeof(buf)) {
-		dev_warn(&state->i2c->dev,
-			 "%s: i2c wr len=%d is too big!\n",
-			 KBUILD_MODNAME, tab_len);
+		dev_warn(&state->i2c->dev, "%s: tab len %d is too big\n",
+				KBUILD_MODNAME, tab_len);
 		return -EINVAL;
 	}
 
-	dev_dbg(&state->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
-
 	for (i = 0, j = 0; i < tab_len; i++) {
 		buf[j] = tab[i].val;
 
-- 
1.8.3.2

