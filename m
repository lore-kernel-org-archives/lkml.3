Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbaHHUo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:44:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40268 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaHHUoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:44:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 162/259] [media] tda10071: force modulation to QPSK on DVB-S
Date: Fri,  8 Aug 2014 13:39:45 -0700
Message-Id: <1407530482-4483-163-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit db4175ae2095634dbecd4c847da439f9c83e1b3b upstream.

Only supported modulation for DVB-S is QPSK. Modulation parameter
contains invalid value for DVB-S on some cases, which leads driver
refusing tuning attempt. Due to that, hard code modulation to QPSK
in case of DVB-S.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/dvb-frontends/tda10071.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 8ad3a57..287b977 100644
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
1.9.1

