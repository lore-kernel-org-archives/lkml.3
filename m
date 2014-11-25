Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbaKYMHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:07:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaKYKkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ulrich Eckhardt <uli@uli-eckhardt.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 007/254] [media] ds3000: fix LNB supply voltage on Tevii S480 on initialization
Date: Tue, 25 Nov 2014 10:35:57 +0000
Message-Id: <1416912004-5928-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>

commit 8c5bcded11cb607b1bb5920de3b9c882136d27db upstream.

The Tevii S480 outputs 18V on startup for the LNB supply voltage and does not
automatically power down. This blocks other receivers connected
to a satellite channel router (EN50494), since the receivers can not send the
required DiSEqC sequences when the Tevii card is connected to a the same SCR.

This patch switches off the LNB supply voltage on initialization of the frontend.

[mchehab@osg.samsung.com: add a comment about why we're explicitly
 turning off voltage at device init]
Signed-off-by: Ulrich Eckhardt <uli@uli-eckhardt.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-frontends/ds3000.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 335daeff91b9..9d0d0347758f 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -864,6 +864,13 @@ struct dvb_frontend *ds3000_attach(const struct ds3000_config *config,
 	memcpy(&state->frontend.ops, &ds3000_ops,
 			sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
+
+	/*
+	 * Some devices like T480 starts with voltage on. Be sure
+	 * to turn voltage off during init, as this can otherwise
+	 * interfere with Unicable SCR systems.
+	 */
+	ds3000_set_voltage(&state->frontend, SEC_VOLTAGE_OFF);
 	return &state->frontend;
 
 error3:
-- 
2.1.0

