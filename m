Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3ERCS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:18:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9220 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab3ERCQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:59 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=PDkFmWV-5QcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=LTcQBFzagl0A:10 a=-8F6hnn5AAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=0kPLrQdw3YYA:10 a=dCG4ZZArJvYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021649.801782113@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [ 050/136 ] ALSA: usb-audio: Fix autopm error during probing
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0050-ALSA-usb-audio-Fix-autopm-error-during-probing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 60af3d037eb8c670dcce31401501d1271e7c5d95 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/card.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index b3f5ad4..aa25e04 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -619,7 +619,9 @@ int snd_usb_autoresume(struct snd_usb_audio *chip)
 	int err = -ENODEV;
 
 	down_read(&chip->shutdown_rwsem);
-	if (!chip->shutdown && !chip->probing)
+	if (chip->probing)
+		err = 0;
+	else if (!chip->shutdown)
 		err = usb_autopm_get_interface(chip->pm_intf);
 	up_read(&chip->shutdown_rwsem);
 
-- 
1.7.10.4


