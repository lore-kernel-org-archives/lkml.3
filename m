Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbaEMKrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:47:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60729 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759532AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 024/182] ALSA: hda - Fix silent speaker output due to mute LED fixup
Date: Tue, 13 May 2014 11:26:16 +0200
Message-Id: <644ea88959485e882601e44046e4077248cfe099.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_realtek.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 69ae2ef1b138..27d7af5a430b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3050,8 +3050,9 @@ static void alc269_fixup_mic_mute_hook(void *private_data, int enabled)
 
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
1.9.3

