Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3AXDem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:34:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44452 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3AXDbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 68/74] ALSA: usb - fix race in creation of M-Audio Fast track pro driver
Date: Thu, 24 Jan 2013 01:27:20 -0200
Message-Id: <1358998046-613-69-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit b98ae2729dea161edc96c9d177459b6c28bcbba5 upstream.

A patch in the 3.2 kernel caused regression with hotplugging the
M-Audio Fast track pro, or sound after suspend. I don't have the
device so I haven't done a full analysis, but it seems userspace
(both udev and pulseaudio) got confused when a card was created,
immediately destroyed, and then created again.

However, at least one person in the bug report (martin djfun)
reports that this patch resolves the issue for him. It also leaves
a message in the log:
"snd-usb-audio: probe of 1-1.1:1.1 failed with error -5" which is
a bit misleading. It is better than non-working audio, but maybe
there's a more elegant solution?

BugLink: https://bugs.launchpad.net/bugs/1095315
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/usb/quirks.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 2781726..c46171a 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -387,11 +387,13 @@ static int snd_usb_fasttrackpro_boot_quirk(struct usb_device *dev)
 		 * rules
 		 */
 		err = usb_driver_set_configuration(dev, 2);
-		if (err < 0) {
+		if (err < 0)
 			snd_printdd("error usb_driver_set_configuration: %d\n",
 				    err);
-			return -ENODEV;
-		}
+		/* Always return an error, so that we stop creating a device
+		   that will just be destroyed and recreated with a new
+		   configuration */
+		return -ENODEV;
 	} else
 		snd_printk(KERN_INFO "usb-audio: Fast Track Pro config OK\n");
 
-- 
1.7.9.5

