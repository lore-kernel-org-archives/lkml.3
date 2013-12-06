Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162298Ab3LFNIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:08:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162187Ab3LFNGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:06:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 263/272] ALSA: hda - Check keep_eapd_on before inv_eapd
Date: Fri,  6 Dec 2013 12:59:12 +0000
Message-Id: <1386334761-25517-264-git-send-email-luis.henriques@canonical.com>
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

commit 468ac413045af1e0e4d1272291bed6878f248a69 upstream.

We don't change the EAPD bit in set_pin_eapd() if keep_eapd_on flag is
set by the codec driver and enable is false.  But, we also apply the
flipping of enable value according to inv_eapd flag in the same
function, and this confused the former check, handled as if it's
turned ON.  The inverted EAPD check must be applied after keep_eapd_on
check, instead.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_generic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 02fdff6..c6cb67b 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -789,10 +789,10 @@ static void set_pin_eapd(struct hda_codec *codec, hda_nid_t pin, bool enable)
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
-- 
1.8.3.2

