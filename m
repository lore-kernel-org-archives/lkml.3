Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614Ab3EFXNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:13:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760564Ab3EFXNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 060/104] ALSA: usb-audio: Fix autopm error during probing
Date: Mon,  6 May 2013 16:12:19 -0700
Message-Id: <20130506230049.781016225@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -612,7 +612,9 @@ int snd_usb_autoresume(struct snd_usb_au
 	int err = -ENODEV;
 
 	down_read(&chip->shutdown_rwsem);
-	if (!chip->shutdown && !chip->probing)
+	if (chip->probing)
+		err = 0;
+	else if (!chip->shutdown)
 		err = usb_autopm_get_interface(chip->pm_intf);
 	up_read(&chip->shutdown_rwsem);
 


