Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab3BCO6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:58:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34626 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076Ab3BCO60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:26 -0500
Message-Id: <20130203144655.107207701@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Takashi Iwai <tiwai@suse.de>
Subject: [ 125/128] ALSA: usb-audio: Fix regression by disconnection-race-fix  patch
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/endpoint.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 24c5114..9ab2b3e 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -148,10 +148,8 @@ void snd_usb_release_substream_urbs(struct snd_usb_substream *subs, int force)
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


