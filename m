Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3LJIT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:19:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3LJIBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 01/62] ALSA: hda - Fix silent output on ASUS W7J laptop
Date: Tue, 10 Dec 2013 00:00:32 -0800
Message-Id: <20131210080057.516929649@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6ddf0fd1c462a418a3cbb8b0653820dc48ffbd98 upstream.

The recent kernels got regressions on ASUS W7J with ALC660 codec where
no sound comes out.  After a long debugging session, we found out that
setting the pin control on the unused NID 0x10 is mandatory for the
outputs.  And, it was found out that another magic of NID 0x0f that is
required for other ASUS laptops isn't needed on this machine.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66081
Reported-and-tested-by: Andrey Lipaev <lipaev@mail.ru>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4266,6 +4266,7 @@ enum {
 	ALC861_FIXUP_AMP_VREF_0F,
 	ALC861_FIXUP_NO_JACK_DETECT,
 	ALC861_FIXUP_ASUS_A6RP,
+	ALC660_FIXUP_ASUS_W7J,
 };
 
 /* On some laptops, VREF of pin 0x0f is abused for controlling the main amp */
@@ -4315,10 +4316,21 @@ static const struct hda_fixup alc861_fix
 		.v.func = alc861_fixup_asus_amp_vref_0f,
 		.chained = true,
 		.chain_id = ALC861_FIXUP_NO_JACK_DETECT,
+	},
+	[ALC660_FIXUP_ASUS_W7J] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* ASUS W7J needs a magic pin setup on unused NID 0x10
+			 * for enabling outputs
+			 */
+			{0x10, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24},
+			{ }
+		},
 	}
 };
 
 static const struct snd_pci_quirk alc861_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1043, 0x1253, "ASUS W7J", ALC660_FIXUP_ASUS_W7J),
 	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", ALC861_FIXUP_ASUS_A6RP),
 	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", ALC861_FIXUP_AMP_VREF_0F),
 	SND_PCI_QUIRK(0x1462, 0x7254, "HP DX2200", ALC861_FIXUP_NO_JACK_DETECT),


