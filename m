Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbaHHWgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:36:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaHHUlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mengdong Lin <mengdong.lin@intel.com>, Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 012/259] ALSA: hda/hdmi - apply all Haswell fix-ups to Broadwell display codec
Date: Fri,  8 Aug 2014 13:37:15 -0700
Message-Id: <1407530482-4483-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengdong Lin <mengdong.lin@intel.com>

commit 75dcbe4dc251ebc28cdf0797b85774cdf53a4d29 upstream.

Broadwell and Haswell have the same behavior on display audio. So this patch
defines is_haswell_plus() to include codecs for both Haswell and its successor
Broadwell, and apply all Haswell fix-ups to Broadwell.

Signed-off-by: Mengdong Lin <mengdong.lin@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 2f66de6..65d6dc0 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -46,6 +46,9 @@ module_param(static_hdmi_pcm, bool, 0644);
 MODULE_PARM_DESC(static_hdmi_pcm, "Don't restrict PCM parameters per ELD info");
 
 #define is_haswell(codec)  ((codec)->vendor_id == 0x80862807)
+#define is_broadwell(codec)    ((codec)->vendor_id == 0x80862808)
+#define is_haswell_plus(codec) (is_haswell(codec) || is_broadwell(codec))
+
 #define is_valleyview(codec) ((codec)->vendor_id == 0x80862882)
 
 struct hdmi_spec_per_cvt {
@@ -1114,7 +1117,7 @@ static void hdmi_setup_audio_infoframe(struct hda_codec *codec,
 	if (!channels)
 		return;
 
-	if (is_haswell(codec))
+	if (is_haswell_plus(codec))
 		snd_hda_codec_write(codec, pin_nid, 0,
 					    AC_VERB_SET_AMP_GAIN_MUTE,
 					    AMP_OUT_UNMUTE);
@@ -1295,7 +1298,7 @@ static int hdmi_setup_stream(struct hda_codec *codec, hda_nid_t cvt_nid,
 	struct hdmi_spec *spec = codec->spec;
 	int err;
 
-	if (is_haswell(codec))
+	if (is_haswell_plus(codec))
 		haswell_verify_D0(codec, cvt_nid, pin_nid);
 
 	err = spec->ops.pin_hbr_setup(codec, pin_nid, is_hbr_format(format));
@@ -1436,7 +1439,7 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 			    mux_idx);
 
 	/* configure unused pins to choose other converters */
-	if (is_haswell(codec) || is_valleyview(codec))
+	if (is_haswell_plus(codec) || is_valleyview(codec))
 		intel_not_share_assigned_cvt(codec, per_pin->pin_nid, mux_idx);
 
 	snd_hda_spdif_ctls_assign(codec, pin_idx, per_cvt->cvt_nid);
@@ -1626,7 +1629,7 @@ static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 	if (get_defcfg_connect(config) == AC_JACK_PORT_NONE)
 		return 0;
 
-	if (is_haswell(codec))
+	if (is_haswell_plus(codec))
 		intel_haswell_fixup_connect_list(codec, pin_nid);
 
 	pin_idx = spec->num_pins;
@@ -2297,7 +2300,7 @@ static int patch_generic_hdmi(struct hda_codec *codec)
 	codec->spec = spec;
 	hdmi_array_init(spec, 4);
 
-	if (is_haswell(codec)) {
+	if (is_haswell_plus(codec)) {
 		intel_haswell_enable_all_pins(codec, true);
 		intel_haswell_fixup_enable_dp12(codec);
 	}
@@ -2308,7 +2311,7 @@ static int patch_generic_hdmi(struct hda_codec *codec)
 		return -EINVAL;
 	}
 	codec->patch_ops = generic_hdmi_patch_ops;
-	if (is_haswell(codec)) {
+	if (is_haswell_plus(codec)) {
 		codec->patch_ops.set_power_state = haswell_set_power_state;
 		codec->dp_mst = true;
 	}
-- 
1.9.1

