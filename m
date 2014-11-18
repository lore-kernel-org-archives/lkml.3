Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbaKRO4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:56:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144AbaKROJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:51 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>,
        Ulrich Eckhardt <uli@uli-eckhardt.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 100/206] media: ds3000: fix LNB supply voltage on Tevii S480 on initialization
Date: Tue, 18 Nov 2014 15:07:35 +0100
Message-Id: <4ccf56c9abfbdf00180257f0b5107a622740496b.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb-frontends/ds3000.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 1e344b033277..22e8c2032f6d 100644
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
2.1.3

