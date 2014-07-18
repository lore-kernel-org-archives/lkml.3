Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030544AbaGRNKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:10:30 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17496 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030524AbaGRNKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sander Eikelenboom <linux@eikelenboom.it>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 124/170] ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined
Date: Fri, 18 Jul 2014 14:12:09 +0200
Message-Id: <1a1f70e6a5e3ee078abc55189f6d585644aab619.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sander Eikelenboom <linux@eikelenboom.it>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b7a7723513dc89f83d6df13206df55d4dc26e825 upstream.

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/usb/pcm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index d59e0c1a3e20..98ca3540514f 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1491,9 +1491,9 @@ static void retire_playback_urb(struct snd_usb_substream *subs,
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
2.0.0

