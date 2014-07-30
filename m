Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaG3MPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:15:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36800 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 78/94] media: tda10071: force modulation to QPSK on DVB-S
Date: Wed, 30 Jul 2014 14:15:07 +0200
Message-Id: <aa0bb3b50855eefdfbf93e7d87999e4b7cf53390.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antti Palosaari <crope@iki.fi>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit db4175ae2095634dbecd4c847da439f9c83e1b3b upstream.

Only supported modulation for DVB-S is QPSK. Modulation parameter
contains invalid value for DVB-S on some cases, which leads driver
refusing tuning attempt. Due to that, hard code modulation to QPSK
in case of DVB-S.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb-frontends/tda10071.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 8ad3a57cf640..287b977862e2 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -667,6 +667,7 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u8 mode, rolloff, pilot, inversion, div;
+	fe_modulation_t modulation;
 
 	dev_dbg(&priv->i2c->dev, "%s: delivery_system=%d modulation=%d " \
 		"frequency=%d symbol_rate=%d inversion=%d pilot=%d " \
@@ -701,10 +702,13 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 
 	switch (c->delivery_system) {
 	case SYS_DVBS:
+		modulation = QPSK;
 		rolloff = 0;
 		pilot = 2;
 		break;
 	case SYS_DVBS2:
+		modulation = c->modulation;
+
 		switch (c->rolloff) {
 		case ROLLOFF_20:
 			rolloff = 2;
@@ -749,7 +753,7 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 
 	for (i = 0, mode = 0xff; i < ARRAY_SIZE(TDA10071_MODCOD); i++) {
 		if (c->delivery_system == TDA10071_MODCOD[i].delivery_system &&
-			c->modulation == TDA10071_MODCOD[i].modulation &&
+			modulation == TDA10071_MODCOD[i].modulation &&
 			c->fec_inner == TDA10071_MODCOD[i].fec) {
 			mode = TDA10071_MODCOD[i].val;
 			dev_dbg(&priv->i2c->dev, "%s: mode found=%02x\n",
-- 
2.0.1

