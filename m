Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3LRVNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:13:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3LRVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3.12 074/118] media: af9033: fix broken I2C
Date: Wed, 18 Dec 2013 13:11:51 -0800
Message-Id: <20131218211221.545746069@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit d18a88b1f535d627412b2a265d71b2f7d464860e upstream.

Driver did not work anymore since I2C has gone broken due
to recent commit:
commit 37ebaf6891ee81687bb558e8375c0712d8264ed8
[media] dvb-frontends: Don't use dynamic static allocation

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/af9033.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -170,18 +170,18 @@ static int af9033_rd_reg_mask(struct af9
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
 


