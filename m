Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaAGNQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:16:46 -0500
Received: from [85.220.129.32] ([85.220.129.32]:56453 "EHLO smtp1-3.goneo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaAGNQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:16:39 -0500
X-Greylist: delayed 639 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 08:16:39 EST
X-Spam-Flag: NO
X-Spam-Score: -2.777
From: Lars Poeschel <poeschel@lemonage.de>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: [RFC DO NOT MERGE] tty: n_gsm: support buggy modem
Date: Tue, 07 Jan 2014 14:05:26 +0100
Message-ID: <4386658.RncifLMAGy@lem-wkst-02>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

This is obiviously a bad patch. Do not merge it!
I have a GSM Modem (Quectel M95 Revision: M95AR01A11) that I have a problem
with when using the n_gsm mux line discipline. After attaching the line
discipline and opening a muxed channel, the open never returns. The
problem is that the tty code waits for the TIOCM_CD flag to be set. According
to the 3GPP TS 07.10 specification the modem can set this virtual flag by
setting the DV bit in it's modem status control message. My modem sends the
modem status command, but this DV bit is not set. With this patch the modem
and the whole mux is working fine. Another way makeing all this work is
setting the carrier_raised function to NULL. The tty code assumes that
everything is alright then.
My question is: What could be the best way to support this modem in mailine
kernel ? I do not see a way to detect this buggy modem inside the line
discipline and use this patch's method as a work around then. But the
detection would only be possible using AT command before the line discipline
is attached or using the muxed channel after the mux is set up.

Thanks,
Lars
---
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c0f76da..a1a6f57 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1061,6 +1061,7 @@ static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
 		mlines |= TIOCM_RI;
 	if (modem & MDM_DV)
 		mlines |= TIOCM_CD;
+	mlines |= TIOCM_CD;
 
 	/* Carrier drop -> hangup */
 	if (tty) {

