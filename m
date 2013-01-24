Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab3AXVSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:18:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:40880 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab3AXVQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:16:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 18/22] ALSA: usb-audio: Fix regression by disconnection-race-fix patch
Date: Thu, 24 Jan 2013 13:15:39 -0800
Message-Id: <20130124211510.505607351@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211504.701368763@linuxfoundation.org>
References: <20130124211504.701368763@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[NOTE: the regression below is found only in 3.2-3.4 stable trees, so
       there is no upstream commit corresponding to this patch]

The recent fix for the race at disconnection of usb-audio devices
(upstream commit 978520b7) triggers Oops when a device is unplugged
while playing on 3.2 and 3.4 kernels.  The culprit is that the
shutdown flag check was wrongly added around the urb deactivation code
snippet.  The urb deactivation code has to be performed even after the
device disconnected.  Otherwise it remains undead and pokes the wild
access in the end.

The regression fix is simply reverting the shutdown flag check in that
code.

Reported-and-tested-by: Chris J Arges <christopherarges@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/endpoint.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -148,10 +148,8 @@ void snd_usb_release_substream_urbs(stru
 	int i;
 
 	/* stop urbs (to be sure) */
-	if (!subs->stream->chip->shutdown) {
-		deactivate_urbs(subs, force, 1);
-		wait_clear_urbs(subs);
-	}
+	deactivate_urbs(subs, force, 1);
+	wait_clear_urbs(subs);
 
 	for (i = 0; i < MAX_URBS; i++)
 		release_urb_ctx(&subs->dataurb[i]);


