Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3ASBec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:34:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:56348 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab3ASBRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, CAI Qian <caiqian@redhat.com>
Subject: [ 13/33] ALSA: usb - fix race in creation of M-Audio Fast track pro driver
Date: Fri, 18 Jan 2013 17:16:38 -0800
Message-Id: <20130119010350.319267874@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Cc: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -387,11 +387,13 @@ static int snd_usb_fasttrackpro_boot_qui
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
 


