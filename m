Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbaEDQ4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:56:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaEDPlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 026/158] ALSA: hda - Fix silent speaker output due to mute LED fixup
Date: Sun,  4 May 2014 11:38:55 -0400
Message-Id: <20140504154033.586473215@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 415d555e6b398b00fc1733f0113065a54df9106a upstream.

The recent fixups for HP laptops to support the mute LED made the
speaker output silent on some machines.  It turned out that they use
the NID 0x18 for the speaker while it's also used for controlling the
LED via VREF bits although the current driver code blindly assumes
that such a node is a mic pin (where 0x18 is usually so).

This patch fixes the problem by only changing the VREF bits and
keeping the other pin ctl bits.

Reported-and-tested-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3212,8 +3212,9 @@ static void alc269_fixup_mic_mute_hook(v
 
 	if (spec->mute_led_polarity)
 		enabled = !enabled;
-	pinval = AC_PINCTL_IN_EN |
-		(enabled ? AC_PINCTL_VREF_HIZ : AC_PINCTL_VREF_80);
+	pinval = snd_hda_codec_get_pin_target(codec, spec->mute_led_nid);
+	pinval &= ~AC_PINCTL_VREFEN;
+	pinval |= enabled ? AC_PINCTL_VREF_HIZ : AC_PINCTL_VREF_80;
 	if (spec->mute_led_nid)
 		snd_hda_set_pin_ctl_cache(codec, spec->mute_led_nid, pinval);
 }


