Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaIKMmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:42:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51651 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755442AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        "Antti Palosaari" <crope@iki.fi>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.525606601@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 007/131] [media] tda10071: force modulation to QPSK on
 DVB-S
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit db4175ae2095634dbecd4c847da439f9c83e1b3b upstream.

Only supported modulation for DVB-S is QPSK. Modulation parameter
contains invalid value for DVB-S on some cases, which leads driver
refusing tuning attempt. Due to that, hard code modulation to QPSK
in case of DVB-S.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/tda10071.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb/frontends/tda10071.c
+++ b/drivers/media/dvb/frontends/tda10071.c
@@ -644,6 +644,7 @@ static int tda10071_set_frontend(struct
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u8 mode, rolloff, pilot, inversion, div;
+	fe_modulation_t modulation;
 
 	dbg("%s: delivery_system=%d modulation=%d frequency=%d " \
 		"symbol_rate=%d inversion=%d pilot=%d rolloff=%d", __func__,
@@ -677,10 +678,13 @@ static int tda10071_set_frontend(struct
 
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
@@ -722,7 +726,7 @@ static int tda10071_set_frontend(struct
 
 	for (i = 0, mode = 0xff; i < ARRAY_SIZE(TDA10071_MODCOD); i++) {
 		if (c->delivery_system == TDA10071_MODCOD[i].delivery_system &&
-			c->modulation == TDA10071_MODCOD[i].modulation &&
+			modulation == TDA10071_MODCOD[i].modulation &&
 			c->fec_inner == TDA10071_MODCOD[i].fec) {
 			mode = TDA10071_MODCOD[i].val;
 			dbg("%s: mode found=%02x", __func__, mode);

