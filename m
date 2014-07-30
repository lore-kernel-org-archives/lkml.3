Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaG3B65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:58:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaG3BuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.15 05/37] media: tda10071: force modulation to QPSK on DVB-S
Date: Tue, 29 Jul 2014 18:48:41 -0700
Message-Id: <20140730014827.873796384@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit db4175ae2095634dbecd4c847da439f9c83e1b3b upstream.

Only supported modulation for DVB-S is QPSK. Modulation parameter
contains invalid value for DVB-S on some cases, which leads driver
refusing tuning attempt. Due to that, hard code modulation to QPSK
in case of DVB-S.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/tda10071.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -668,6 +668,7 @@ static int tda10071_set_frontend(struct
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u8 mode, rolloff, pilot, inversion, div;
+	fe_modulation_t modulation;
 
 	dev_dbg(&priv->i2c->dev,
 			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
@@ -702,10 +703,13 @@ static int tda10071_set_frontend(struct
 
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
@@ -750,7 +754,7 @@ static int tda10071_set_frontend(struct
 
 	for (i = 0, mode = 0xff; i < ARRAY_SIZE(TDA10071_MODCOD); i++) {
 		if (c->delivery_system == TDA10071_MODCOD[i].delivery_system &&
-			c->modulation == TDA10071_MODCOD[i].modulation &&
+			modulation == TDA10071_MODCOD[i].modulation &&
 			c->fec_inner == TDA10071_MODCOD[i].fec) {
 			mode = TDA10071_MODCOD[i].val;
 			dev_dbg(&priv->i2c->dev, "%s: mode found=%02x\n",


