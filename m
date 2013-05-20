Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3ETLV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:21:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab3ETKwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 025/115] ALSA: usb-audio: Fix autopm error during probing
Date: Mon, 20 May 2013 11:50:25 +0100
Message-Id: <1369047116-9378-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/card.c | 4 +++-
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
1.8.1.2

