Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab3GZUvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:51:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab3GZUtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:49:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 79/79] ALSA: hda - Fix EAPD GPIO control for Sigmatel codecs
Date: Fri, 26 Jul 2013 13:48:09 -0700
Message-Id: <20130726204731.119878429@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1ea9a69d1a36a5b62bf281ba8bb304fcac656dad upstream.

The EAPD GPIO is dynamically turned on/off for some machines with
Sigmatel codecs, but this didn't work as expected, and it resulted in
spontaneous lost of speaker outputs per HP plugging or power-saving.

This patch fixes the bug by simply including spec->eapd_mask into
spec->gpio_mask and spec->gpio_data bits.

Reported-and-tested-by: Eric Shattow <lucent@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -417,9 +417,11 @@ static void stac_update_outputs(struct h
 			val &= ~spec->eapd_mask;
 		else
 			val |= spec->eapd_mask;
-		if (spec->gpio_data != val)
+		if (spec->gpio_data != val) {
+			spec->gpio_data = val;
 			stac_gpio_set(codec, spec->gpio_mask, spec->gpio_dir,
 				      val);
+		}
 	}
 }
 
@@ -3608,20 +3610,18 @@ static int stac_parse_auto_config(struct
 static int stac_init(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec = codec->spec;
-	unsigned int gpio;
 	int i;
 
 	/* override some hints */
 	stac_store_hints(codec);
 
 	/* set up GPIO */
-	gpio = spec->gpio_data;
 	/* turn on EAPD statically when spec->eapd_switch isn't set.
 	 * otherwise, unsol event will turn it on/off dynamically
 	 */
 	if (!spec->eapd_switch)
-		gpio |= spec->eapd_mask;
-	stac_gpio_set(codec, spec->gpio_mask, spec->gpio_dir, gpio);
+		spec->gpio_data |= spec->eapd_mask;
+	stac_gpio_set(codec, spec->gpio_mask, spec->gpio_dir, spec->gpio_data);
 
 	snd_hda_gen_init(codec);
 
@@ -3921,6 +3921,7 @@ static void stac_setup_gpio(struct hda_c
 {
 	struct sigmatel_spec *spec = codec->spec;
 
+	spec->gpio_mask |= spec->eapd_mask;
 	if (spec->gpio_led) {
 		if (!spec->vref_mute_led_nid) {
 			spec->gpio_mask |= spec->gpio_led;


