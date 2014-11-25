Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaKYLZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:25:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbaKYKmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 126/254] [media] m88ts2022: fix 32bit overflow on filter calc
Date: Tue, 25 Nov 2014 10:37:56 +0000
Message-Id: <1416912004-5928-127-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit f538e085138e519e25ae0828bd6c6e7492ce8ca4 upstream.

Maximum satellite symbol rate used is 45000000Sps which overflows
when multiplied by 135. As final calculation result is fraction,
we could use mult_frac macro in order to keep calculation inside
32 bit number limits and prevent overflow.

Original bug and fix was provided by Nibble Max. I decided to
implement it differently as it is now.

Reported-by: Nibble Max <nibble.max@gmail.com>
Tested-by: Nibble Max <nibble.max@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/tuners/m88ts2022.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index 40c42dec721b..7a62097aa9ea 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -314,7 +314,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	div_min = gdiv28 * 78 / 100;
 	div_max = clamp_val(div_max, 0U, 63U);
 
-	f_3db_hz = c->symbol_rate * 135UL / 200UL;
+	f_3db_hz = mult_frac(c->symbol_rate, 135, 200);
 	f_3db_hz +=  2000000U + (frequency_offset_khz * 1000U);
 	f_3db_hz = clamp(f_3db_hz, 7000000U, 40000000U);
 
-- 
2.1.0

