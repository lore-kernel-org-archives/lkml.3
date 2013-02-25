Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab3BYWWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:22:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab3BYWUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Staffan Lindberg <pike@xbmc.org>, Anssi Hannula <anssi.hannula@iki.fi>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 48/58] ALSA: hda - Fix default multichannel HDMI mapping regression
Date: Mon, 25 Feb 2013 14:19:44 -0800
Message-Id: <20130225221646.578532457@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit 20608731f479d48be6bcb88e727f360ddf98ddaf upstream.

Commit d45e6889ee69456a4d5b1bbb32252f460cd48fa9 ("ALSA: hda - Provide
the proper channel mapping for generic HDMI driver") added support for
custom channel maps in the HDA HDMI driver. Due to a mistake in an
'if' condition the custom map is always used even when no such map has
been set. This causes incorrect channel mapping for multichannel audio
by default.

Pass per_pin->chmap_set to hdmi_setup_channel_mapping() as a parameter
so that it can use it for detecting if a custom map has been set instead
of checking if map is NULL (which is never the case).

Reported-by: Staffan Lindberg <pike@xbmc.org>
Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -714,9 +714,10 @@ static void hdmi_setup_fake_chmap(unsign
 
 static void hdmi_setup_channel_mapping(struct hda_codec *codec,
 				       hda_nid_t pin_nid, bool non_pcm, int ca,
-				       int channels, unsigned char *map)
+				       int channels, unsigned char *map,
+				       bool chmap_set)
 {
-	if (!non_pcm && map) {
+	if (!non_pcm && chmap_set) {
 		hdmi_manual_setup_channel_mapping(codec, pin_nid,
 						  channels, map);
 	} else {
@@ -905,7 +906,8 @@ static void hdmi_setup_audio_infoframe(s
 			    pin_nid,
 			    channels);
 		hdmi_setup_channel_mapping(codec, pin_nid, non_pcm, ca,
-					   channels, per_pin->chmap);
+					   channels, per_pin->chmap,
+					   per_pin->chmap_set);
 		hdmi_stop_infoframe_trans(codec, pin_nid);
 		hdmi_fill_audio_infoframe(codec, pin_nid,
 					    ai.bytes, sizeof(ai));
@@ -915,7 +917,8 @@ static void hdmi_setup_audio_infoframe(s
 		 * accordingly */
 		if (per_pin->non_pcm != non_pcm)
 			hdmi_setup_channel_mapping(codec, pin_nid, non_pcm, ca,
-						   channels, per_pin->chmap);
+						   channels, per_pin->chmap,
+						   per_pin->chmap_set);
 	}
 
 	per_pin->non_pcm = non_pcm;


