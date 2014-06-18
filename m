Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaFRROR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:14:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33101 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaFRROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:14:14 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: kamal.mostafa@canonical.com
Cc: perex@perex.cz, tiwai@suse.de, eldad@fogrefinery.com, clemens@ladisch.de,
        tim.gardner@canonical.com, stern@rowland.harvard.edu,
        linux@eikelenboom.it, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [Trusty][SRU][PATCH 1/1] ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined
Date: Wed, 18 Jun 2014 13:14:06 -0400
Message-Id: <e9b02dbdd0f27bfe9c324a7b05538bdc171d9b8a.1400085278.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1400085278.git.joseph.salisbury@canonical.com>
References: <cover.1400085278.git.joseph.salisbury@canonical.com>
In-Reply-To: <cover.1400085278.git.joseph.salisbury@canonical.com>
References: <cover.1400085278.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sander Eikelenboom <linux@eikelenboom.it>

BugLink: http://bugs.launchpad.net/bugs/1319457

This (widely used) construction:

if(printk_ratelimit())
	dev_dbg()

Causes the ratelimiting to spam the kernel log with the "callbacks suppressed"
message below, even while the dev_dbg it is supposed to rate limit wouldn't
print anything because DEBUG is not defined for this device.

[  533.803964] retire_playback_urb: 852 callbacks suppressed
[  538.807930] retire_playback_urb: 852 callbacks suppressed
[  543.811897] retire_playback_urb: 852 callbacks suppressed
[  548.815745] retire_playback_urb: 852 callbacks suppressed
[  553.819826] retire_playback_urb: 852 callbacks suppressed

So use dev_dbg_ratelimited() instead of this construction.

Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
(backported from commit b7a7723513dc89f83d6df13206df55d4dc26e825)
Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>

---
 sound/usb/pcm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 7bfa7a1..ede4b92 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1487,9 +1487,9 @@ static void retire_playback_urb(struct snd_usb_substream *subs,
 	 * The error should be lower than 2ms since the estimate relies
 	 * on two reads of a counter updated every ms.
 	 */
-	if (printk_ratelimit() &&
-	    abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
-		snd_printk(KERN_DEBUG "delay: estimated %d, actual %d\n",
+	if (abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
+		dev_dbg_ratelimited(&subs->dev->dev,
+			"delay: estimated %d, actual %d\n",
 			est_delay, subs->last_delay);
 
 	if (!subs->running) {
-- 
1.9.1

