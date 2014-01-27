Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaA0UQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:16:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbaA0UQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:16:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.13 08/10] ALSA: hda - Explicitly keep codec powered up in hdmi_present_sense
Date: Mon, 27 Jan 2014 12:17:11 -0800
Message-Id: <20140127201535.937672648@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140127201535.350372282@linuxfoundation.org>
References: <20140127201535.350372282@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit da4a7a3926d09c13ae052ede67feb7285e01e3f5 upstream.

This should help us avoid the following mutex deadlock:

[] mutex_lock+0x2a/0x50
[] hdmi_present_sense+0x53/0x3a0 [snd_hda_codec_hdmi]
[] generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
[] hda_call_codec_resume+0xec/0x1d0 [snd_hda_codec]
[] snd_hda_power_save+0x1e4/0x280 [snd_hda_codec]
[] codec_exec_verb+0x5f/0x290 [snd_hda_codec]
[] snd_hda_codec_read+0x5b/0x90 [snd_hda_codec]
[] snd_hdmi_get_eld_size+0x1e/0x20 [snd_hda_codec_hdmi]
[] snd_hdmi_get_eld+0x2c/0xd0 [snd_hda_codec_hdmi]
[] hdmi_present_sense+0x9a/0x3a0 [snd_hda_codec_hdmi]
[] hdmi_repoll_eld+0x34/0x50 [snd_hda_codec_hdmi]

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Fixes: cbbaa603a03c ('ALSA: hda - Fix possible races in HDMI driver')
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1496,11 +1496,14 @@ static bool hdmi_present_sense(struct hd
 	 * specification worked this way. Hence, we just ignore the data in
 	 * the unsolicited response to avoid custom WARs.
 	 */
-	int present = snd_hda_pin_sense(codec, pin_nid);
+	int present;
 	bool update_eld = false;
 	bool eld_changed = false;
 	bool ret;
 
+	snd_hda_power_up(codec);
+	present = snd_hda_pin_sense(codec, pin_nid);
+
 	mutex_lock(&per_pin->lock);
 	pin_eld->monitor_present = !!(present & AC_PINSENSE_PRESENCE);
 	if (pin_eld->monitor_present)
@@ -1573,6 +1576,7 @@ static bool hdmi_present_sense(struct hd
 		jack->block_report = !ret;
 
 	mutex_unlock(&per_pin->lock);
+	snd_hda_power_down(codec);
 	return ret;
 }
 


