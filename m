Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbaLBT4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:56:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46510 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbaLBTU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:28 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ulrich Eckhardt <uli@uli-eckhardt.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 019/121] [media] ds3000: fix LNB supply voltage on Tevii S480 on initialization
Date: Tue,  2 Dec 2014 11:18:18 -0800
Message-Id: <1417548000-1794-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/dvb-frontends/ds3000.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 1e344b0..22e8c20 100644
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
1.9.1

