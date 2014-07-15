Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbaGOVbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:31:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952AbaGOVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:31:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sander Eikelenboom <linux@eikelenboom.it>, Takashi Iwai <tiwai@suse.de>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 002/198] ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined
Date: Tue, 15 Jul 2014 14:27:52 -0700
Message-Id: <1405459868-15089-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sander Eikelenboom <linux@eikelenboom.it>

commit b7a7723513dc89f83d6df13206df55d4dc26e825 upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index ca3256d..ede4b92 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1488,7 +1488,8 @@ static void retire_playback_urb(struct snd_usb_substream *subs,
 	 * on two reads of a counter updated every ms.
 	 */
 	if (abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
-		snd_printk(KERN_DEBUG "delay: estimated %d, actual %d\n",
+		dev_dbg_ratelimited(&subs->dev->dev,
+			"delay: estimated %d, actual %d\n",
 			est_delay, subs->last_delay);
 
 	if (!subs->running) {
-- 
1.9.1

