Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3FKUPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:15:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3FKUD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Riesen <raa.lkml@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 35/79] ALSA: hda/via - Fix wrongly cleared pins after suspend on VT1802
Date: Tue, 11 Jun 2013 13:03:01 -0700
Message-Id: <20130611195317.037014412@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5a6f294e87974e6ec68d7113553ffd975d83bf15 upstream.

VIA driver has a special suspend handling only for VT1802 to reduce
the pop noise.  During the transition to the generic parser, the
behavior of snd_hda_set_pin_ctl() was also changed to modify the
cached values, too.  And this caused a regression where the pin is
still cleared even after the resume (including the resume from power
save), resulting in the silent output.

The fix is simply to replace snd_hda_set_pin_ctl() with the explicit
call of snd_hda_codec_write() again.

Reported-by: Alex Riesen <raa.lkml@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -483,7 +483,9 @@ static int via_suspend(struct hda_codec
 		/* Fix pop noise on headphones */
 		int i;
 		for (i = 0; i < spec->gen.autocfg.hp_outs; i++)
-			snd_hda_set_pin_ctl(codec, spec->gen.autocfg.hp_pins[i], 0);
+			snd_hda_codec_write(codec, spec->gen.autocfg.hp_pins[i],
+					    0, AC_VERB_SET_PIN_WIDGET_CONTROL,
+					    0x00);
 	}
 
 	return 0;


