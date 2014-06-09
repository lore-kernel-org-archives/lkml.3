Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaFIJ00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:26:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755187AbaFIJ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:23 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 140/146] media: fc2580: fix tuning failure on 32-bit arch
Date: Mon,  9 Jun 2014 10:51:15 +0200
Message-Id: <cd6cf23615d40bf7f2f54df2f42adddbd9a24792.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antti Palosaari <crope@iki.fi>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8845cc6415ec28ef8d57b3fb81c75ef9bce69c5f upstream.

There was some frequency calculation overflows which caused tuning
failure on 32-bit architecture. Use 64-bit numbers where needed in
order to avoid calculation overflows.

Thanks for the Finnish person, who asked remain anonymous, reporting,
testing and suggesting the fix.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/tuners/fc2580.c      | 6 +++---
 drivers/media/tuners/fc2580_priv.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 3aecaf465094..f0c9c42867de 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -195,7 +195,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 
 	f_ref = 2UL * priv->cfg->clock / r_val;
 	n_val = div_u64_rem(f_vco, f_ref, &k_val);
-	k_val_reg = 1UL * k_val * (1 << 20) / f_ref;
+	k_val_reg = div_u64(1ULL * k_val * (1 << 20), f_ref);
 
 	ret = fc2580_wr_reg(priv, 0x18, r18_val | ((k_val_reg >> 16) & 0xff));
 	if (ret < 0)
@@ -348,8 +348,8 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x37, 1UL * priv->cfg->clock * \
-			fc2580_if_filter_lut[i].mul / 1000000000);
+	ret = fc2580_wr_reg(priv, 0x37, div_u64(1ULL * priv->cfg->clock *
+			fc2580_if_filter_lut[i].mul, 1000000000));
 	if (ret < 0)
 		goto err;
 
diff --git a/drivers/media/tuners/fc2580_priv.h b/drivers/media/tuners/fc2580_priv.h
index be38a9e637e0..646c99452136 100644
--- a/drivers/media/tuners/fc2580_priv.h
+++ b/drivers/media/tuners/fc2580_priv.h
@@ -22,6 +22,7 @@
 #define FC2580_PRIV_H
 
 #include "fc2580.h"
+#include <linux/math64.h>
 
 struct fc2580_reg_val {
 	u8 reg;
-- 
1.9.3

