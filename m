Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbaEBPvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:51:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44318 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbaEBPqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 120/151] ALSA: hda - Fix silent speaker output due to mute LED fixup
Date: Fri,  2 May 2014 08:38:28 -0700
Message-Id: <1399045139-4531-121-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 331ede8..0080bee 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3157,8 +3157,9 @@ static void alc269_fixup_mic_mute_hook(void *private_data, int enabled)
 
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
-- 
1.9.1

