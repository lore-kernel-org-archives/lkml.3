Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3EJOVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57178 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755319Ab3EJOV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.755488966@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [057/118] ALSA: usb-audio: Fix autopm error during probing
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 60af3d037eb8c670dcce31401501d1271e7c5d95 upstream.

We've got strange errors in get_ctl_value() in mixer.c during
probing, e.g. on Hercules RMX2 DJ Controller:

  ALSA mixer.c:352 cannot get ctl value: req = 0x83, wValue = 0x201, wIndex = 0xa00, type = 4
  ALSA mixer.c:352 cannot get ctl value: req = 0x83, wValue = 0x200, wIndex = 0xa00, type = 4
  ....

It turned out that the culprit is autopm: snd_usb_autoresume() returns
-ENODEV when called during card->probing = 1.

Since the call itself during card->probing = 1 is valid, let's fix the
return value of snd_usb_autoresume() as success.

Reported-and-tested-by: Daniel Schürmann <daschuer@mixxx.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/card.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -611,7 +611,9 @@ int snd_usb_autoresume(struct snd_usb_au
 	int err = -ENODEV;
 
 	down_read(&chip->shutdown_rwsem);
-	if (!chip->shutdown && !chip->probing)
+	if (chip->probing)
+		err = 0;
+	else if (!chip->shutdown)
 		err = usb_autopm_get_interface(chip->pm_intf);
 	up_read(&chip->shutdown_rwsem);
 

