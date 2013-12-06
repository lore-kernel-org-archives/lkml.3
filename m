Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab3LFOSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:18:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161141Ab3LFNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 031/272] ALSA: hda - Fix unbalanced runtime PM notification at resume
Date: Fri,  6 Dec 2013 12:55:20 +0000
Message-Id: <1386334761-25517-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0fc28fc030a85aa3d6d14e9e9fca0c8237c9ffb5 upstream.

When a codec is resumed, it keeps the power on while the resuming
phase via hda_keep_power_on(), then turns down via
snd_hda_power_down().  At that point, snd_hda_power_down() notifies
the power down to the controller, and this may confuse the refcount if
the codec was already powered up before the resume.

In the end result, the controller goes to runtime suspend even before
the codec is kicked off to the power save, and the communication
stalls happens.

The fix is to add the power-up notification together with
hda_keep_power_on(), and clears the flag appropriately.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_codec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 7c9e7dc..96ef7c2 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3931,6 +3931,10 @@ static void hda_call_codec_resume(struct hda_codec *codec)
 	 * in the resume / power-save sequence
 	 */
 	hda_keep_power_on(codec);
+	if (codec->pm_down_notified) {
+		codec->pm_down_notified = 0;
+		hda_call_pm_notify(codec->bus, true);
+	}
 	hda_set_power_state(codec, AC_PWRST_D0);
 	restore_shutup_pins(codec);
 	hda_exec_init_verbs(codec);
-- 
1.8.3.2

