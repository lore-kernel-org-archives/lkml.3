Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaEBPnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:43:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44003 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaEBPn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:43:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 026/151] [media] m88rs2000: prevent frontend crash on continuous transponder scans
Date: Fri,  2 May 2014 08:36:54 -0700
Message-Id: <1399045139-4531-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/dvb-frontends/m88rs2000.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 5b3b1d3..c7a1c8e 100644
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
1.9.1

