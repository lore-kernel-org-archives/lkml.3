Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176Ab3K0Bod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:44:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab3K0A54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 41/80] ALSA: hda - Check keep_eapd_on before inv_eapd
Date: Tue, 26 Nov 2013 16:57:10 -0800
Message-Id: <20131127005643.785917344@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 468ac413045af1e0e4d1272291bed6878f248a69 upstream.

We don't change the EAPD bit in set_pin_eapd() if keep_eapd_on flag is
set by the codec driver and enable is false.  But, we also apply the
flipping of enable value according to inv_eapd flag in the same
function, and this confused the former check, handled as if it's
turned ON.  The inverted EAPD check must be applied after keep_eapd_on
check, instead.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -786,10 +786,10 @@ static void set_pin_eapd(struct hda_code
 	if (spec->own_eapd_ctl ||
 	    !(snd_hda_query_pin_caps(codec, pin) & AC_PINCAP_EAPD))
 		return;
-	if (codec->inv_eapd)
-		enable = !enable;
 	if (spec->keep_eapd_on && !enable)
 		return;
+	if (codec->inv_eapd)
+		enable = !enable;
 	snd_hda_codec_update_cache(codec, pin, 0,
 				   AC_VERB_SET_EAPD_BTLENABLE,
 				   enable ? 0x02 : 0x00);


