Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3BCPBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:01:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34608 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877Ab3BCO6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:23 -0500
Message-Id: <20130203144654.820169604@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 122/128] ALSA: usb - fix race in creation of M-Audio Fast track pro driver
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/quirks.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index acc12f0..e71fc8b 100644
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
 


