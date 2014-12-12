Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556AbaLLGft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:35:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51938 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759318AbaLLGQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        "Ulrich Eckhardt" <uli@uli-eckhardt.de>,
        "Ulrich Eckhardt" <uli-lirc@uli-eckhardt.de>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.776866069@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 100/164] [media] ds3000: fix LNB supply voltage on
 Tevii S480 on initialization
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/ds3000.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -925,6 +925,13 @@ struct dvb_frontend *ds3000_attach(const
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

