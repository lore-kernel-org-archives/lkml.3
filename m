Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968Ab3GWWw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:52:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934346Ab3GWW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 029/103] ALSA: hda - Fix missing Mic Boost controls for VIA codecs
Date: Tue, 23 Jul 2013 15:25:40 -0700
Message-Id: <20130723220421.815322497@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d045c5dc43d829df9f067d363c3b42b14dacf434 upstream.

Some VIA codecs like VT1708S have Mic boost amps in the mic pins but
they aren't exposed in the capability bits.  In the past driver code,
we override the pin caps and create mic boost controls forcibly.
While transition to the generic parser, we lost the mic boost controls
although the pin caps are still overridden, because the generic parser
code checks the widget caps, too.

So this patch adds a new helper function to allow the override of the
given widget capability bits, and makes VIA codecs driver to add the
missing input-amp capability bit.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=59861
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_local.h |    8 ++++++++
 sound/pci/hda/patch_via.c |    2 ++
 2 files changed, 10 insertions(+)

--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -562,6 +562,14 @@ static inline unsigned int get_wcaps_cha
 	return chans;
 }
 
+static inline void snd_hda_override_wcaps(struct hda_codec *codec,
+					  hda_nid_t nid, u32 val)
+{
+	if (nid >= codec->start_nid &&
+	    nid < codec->start_nid + codec->num_nodes)
+		codec->wcaps[nid - codec->start_nid] = val;
+}
+
 u32 query_amp_caps(struct hda_codec *codec, hda_nid_t nid, int direction);
 int snd_hda_override_amp_caps(struct hda_codec *codec, hda_nid_t nid, int dir,
 			      unsigned int caps);
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -910,6 +910,8 @@ static const struct hda_verb vt1708S_ini
 static void override_mic_boost(struct hda_codec *codec, hda_nid_t pin,
 			       int offset, int num_steps, int step_size)
 {
+	snd_hda_override_wcaps(codec, pin,
+			       get_wcaps(codec, pin) | AC_WCAP_IN_AMP);
 	snd_hda_override_amp_caps(codec, pin, HDA_INPUT,
 				  (offset << AC_AMPCAP_OFFSET_SHIFT) |
 				  (num_steps << AC_AMPCAP_NUM_STEPS_SHIFT) |


