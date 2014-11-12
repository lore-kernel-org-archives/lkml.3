Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbaKLBZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:25:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbaKLBZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:25:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ulrich Eckhardt <uli@uli-eckhardt.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.17 120/319] media: ds3000: fix LNB supply voltage on Tevii S480 on initialization
Date: Wed, 12 Nov 2014 10:14:18 +0900
Message-Id: <20141112011012.463408627@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/ds3000.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -864,6 +864,13 @@ struct dvb_frontend *ds3000_attach(const
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


