Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaFDXzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:55:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbaFDXXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 223/228] media: fc2580: fix tuning failure on 32-bit arch
Date: Wed,  4 Jun 2014 16:24:12 -0700
Message-Id: <20140604232355.212686922@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 8845cc6415ec28ef8d57b3fb81c75ef9bce69c5f upstream.

There was some frequency calculation overflows which caused tuning
failure on 32-bit architecture. Use 64-bit numbers where needed in
order to avoid calculation overflows.

Thanks for the Finnish person, who asked remain anonymous, reporting,
testing and suggesting the fix.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/tuners/fc2580.c      |    6 +++---
 drivers/media/tuners/fc2580_priv.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -195,7 +195,7 @@ static int fc2580_set_params(struct dvb_
 
 	f_ref = 2UL * priv->cfg->clock / r_val;
 	n_val = div_u64_rem(f_vco, f_ref, &k_val);
-	k_val_reg = 1UL * k_val * (1 << 20) / f_ref;
+	k_val_reg = div_u64(1ULL * k_val * (1 << 20), f_ref);
 
 	ret = fc2580_wr_reg(priv, 0x18, r18_val | ((k_val_reg >> 16) & 0xff));
 	if (ret < 0)
@@ -348,8 +348,8 @@ static int fc2580_set_params(struct dvb_
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x37, 1UL * priv->cfg->clock * \
-			fc2580_if_filter_lut[i].mul / 1000000000);
+	ret = fc2580_wr_reg(priv, 0x37, div_u64(1ULL * priv->cfg->clock *
+			fc2580_if_filter_lut[i].mul, 1000000000));
 	if (ret < 0)
 		goto err;
 
--- a/drivers/media/tuners/fc2580_priv.h
+++ b/drivers/media/tuners/fc2580_priv.h
@@ -22,6 +22,7 @@
 #define FC2580_PRIV_H
 
 #include "fc2580.h"
+#include <linux/math64.h>
 
 struct fc2580_reg_val {
 	u8 reg;


