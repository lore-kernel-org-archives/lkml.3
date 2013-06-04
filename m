Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab3FDXZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:25:38 -0400
Received: from 1wt.eu ([62.212.114.60]:35195 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab3FDWlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:01 -0400
Message-Id: <20130604172132.053535597@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Jonathan Nieder <jrnieder@gmail.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 042/184] ALSA: hda - Add a pin-fix for FSC Amilo Pi1505
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

FSC Amilo Pi 1505 has a buggy BIOS and doesn't set up the HP and
speaker pins properly.  Add the pinfix entry for that.

Reference: Novell bnc#557403
   https://bugzilla.novell.com/show_bug.cgi?id=557403

[2.6.32: additional background from Jonathan below]
> Hi Willy,
>
> Please consider
>
>   cfc9b06f0bef ALSA: hda - Add a pin-fix for FSC Amilo Pi1505
>
> for application to the 2.6.32.y tree.  Without this patch, the Amilo
> Pi 1505's internal speaker is silent unless a jack is plugged into its
> headphone jack.
>
> Jose Manuel Castroagudin noticed[1] that 2.6.30 is not affected, so
> this seems to be a regression.
>
> The patch was applied upstream during the 2.6.33 merge window, where
> it worked.  That said, I didn't manage to track down anyone with a
> Pi1505 to test it against 2.6.32, so thoughts from alsa folks on
> whether this is appropriate for 2.6.32.y would be useful.
>
> Hope that helps,
> Jonathan
>
> [1] http://bugs.debian.org/599582 has many more details.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
(cherry picked from commit cfc9b06f0befe50ef02253f72b76946363549031)
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 sound/pci/hda/patch_realtek.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 06e7cc2..d9b4453 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -14713,6 +14713,27 @@ static struct alc_config_preset alc861_presets[] = {
 	},
 };
 
+/* Pin config fixes */
+enum {
+	PINFIX_FSC_AMILO_PI1505,
+};
+
+static struct alc_pincfg alc861_fsc_amilo_pi1505_pinfix[] = {
+	{ 0x0b, 0x0221101f }, /* HP */
+	{ 0x0f, 0x90170310 }, /* speaker */
+	{ }
+};
+
+static const struct alc_fixup alc861_fixups[] = {
+	[PINFIX_FSC_AMILO_PI1505] = {
+		.pins = alc861_fsc_amilo_pi1505_pinfix
+	},
+};
+
+static struct snd_pci_quirk alc861_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1734, 0x10c7, "FSC Amilo Pi1505", PINFIX_FSC_AMILO_PI1505),
+	{}
+};
 
 static int patch_alc861(struct hda_codec *codec)
 {
@@ -14736,6 +14757,8 @@ static int patch_alc861(struct hda_codec *codec)
 		board_config = ALC861_AUTO;
 	}
 
+	alc_pick_fixup(codec, alc861_fixup_tbl, alc861_fixups);
+
 	if (board_config == ALC861_AUTO) {
 		/* automatic parse from the BIOS config */
 		err = alc861_parse_auto_config(codec);
-- 
1.7.12.2.21.g234cd45.dirty



