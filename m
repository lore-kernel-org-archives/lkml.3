Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbaEDQb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:31:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaEDPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 115/158] media: m88rs2000: prevent frontend crash on continuous transponder scans
Date: Sun,  4 May 2014 11:40:24 -0400
Message-Id: <20140504154045.636835677@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 8272d0a0c0d374a01721e579df6e8add5577132b upstream.

Add m88rs2000_get_tune_settings, min delay of 2000 ms on symbol
rate more than 3000000 and delay of 3000ms less than this.

Adding min delay prevents crashing the frontend on continuous
transponder scans. Other dvb_frontend_tune_settings remain as default.

This makes very little time difference to good channel scans, but slows down
the set frontend where lock can never be achieved i.e. DVB-S2.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/m88rs2000.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -715,6 +715,22 @@ static int m88rs2000_get_frontend(struct
 	return 0;
 }
 
+static int m88rs2000_get_tune_settings(struct dvb_frontend *fe,
+	struct dvb_frontend_tune_settings *tune)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	if (c->symbol_rate > 3000000)
+		tune->min_delay_ms = 2000;
+	else
+		tune->min_delay_ms = 3000;
+
+	tune->step_size = c->symbol_rate / 16000;
+	tune->max_drift = c->symbol_rate / 2000;
+
+	return 0;
+}
+
 static int m88rs2000_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct m88rs2000_state *state = fe->demodulator_priv;
@@ -766,6 +782,7 @@ static struct dvb_frontend_ops m88rs2000
 
 	.set_frontend = m88rs2000_set_frontend,
 	.get_frontend = m88rs2000_get_frontend,
+	.get_tune_settings = m88rs2000_get_tune_settings,
 };
 
 struct dvb_frontend *m88rs2000_attach(const struct m88rs2000_config *config,


