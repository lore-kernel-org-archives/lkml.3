Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaEMJna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:43:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60879 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760102AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 091/182] media: m88rs2000: prevent frontend crash on continuous transponder scans
Date: Tue, 13 May 2014 11:27:23 +0200
Message-Id: <b590abe0c4ce0ea173cb97b14706381ed5db2ec7.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb-frontends/m88rs2000.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 02699c111019..acd4ff58f902 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -712,6 +712,22 @@ static int m88rs2000_get_frontend(struct dvb_frontend *fe)
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
@@ -763,6 +779,7 @@ static struct dvb_frontend_ops m88rs2000_ops = {
 
 	.set_frontend = m88rs2000_set_frontend,
 	.get_frontend = m88rs2000_get_frontend,
+	.get_tune_settings = m88rs2000_get_tune_settings,
 };
 
 struct dvb_frontend *m88rs2000_attach(const struct m88rs2000_config *config,
-- 
1.9.3

