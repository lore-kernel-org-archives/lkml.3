Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3LSMIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:08:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45319 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3LSL7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 184/208] ALSA: hda - Add static DAC/pin mapping for AD1986A codec
Date: Thu, 19 Dec 2013 11:54:42 +0000
Message-Id: <1387454106-19326-185-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 3690739b013504d33fe9348dd45f6b126aa370fb upstream.

AD1986A codec is a pretty old codec and has really many hidden
restrictions.  One of such is that each DAC is dedicated to certain
pin although there are possible connections.  Currently, the generic
parser tries to assign individual DACs as much as possible, and this
lead to two bad situations: connections where the sound actually
doesn't work, and connections conflicting other channels.

We may fix this by trying to find the best connections more harder,
but as of now, it's easier to give some hints for paired DAC/pin
connections and honor them if available, since such a hint is needed
only for specific codecs (right now only AD1986A, and there will be
unlikely any others in future).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64971
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66621
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_generic.c  | 23 ++++++++++++++++++++++-
 sound/pci/hda/hda_generic.h  |  3 +++
 sound/pci/hda/patch_analog.c | 10 ++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index bd7efe8..08172b1 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -471,6 +471,20 @@ static void invalidate_nid_path(struct hda_codec *codec, int idx)
 	memset(path, 0, sizeof(*path));
 }
 
+/* return a DAC if paired to the given pin by codec driver */
+static hda_nid_t get_preferred_dac(struct hda_codec *codec, hda_nid_t pin)
+{
+	struct hda_gen_spec *spec = codec->spec;
+	const hda_nid_t *list = spec->preferred_dacs;
+
+	if (!list)
+		return 0;
+	for (; *list; list += 2)
+		if (*list == pin)
+			return list[1];
+	return 0;
+}
+
 /* look for an empty DAC slot */
 static hda_nid_t look_for_dac(struct hda_codec *codec, hda_nid_t pin,
 			      bool is_digital)
@@ -1165,7 +1179,14 @@ static int try_assign_dacs(struct hda_codec *codec, int num_outs,
 			continue;
 		}
 
-		dacs[i] = look_for_dac(codec, pin, false);
+		dacs[i] = get_preferred_dac(codec, pin);
+		if (dacs[i]) {
+			if (is_dac_already_used(codec, dacs[i]))
+				badness += bad->shared_primary;
+		}
+
+		if (!dacs[i])
+			dacs[i] = look_for_dac(codec, pin, false);
 		if (!dacs[i] && !i) {
 			/* try to steal the DAC of surrounds for the front */
 			for (j = 1; j < num_outs; j++) {
diff --git a/sound/pci/hda/hda_generic.h b/sound/pci/hda/hda_generic.h
index e199a85..76c685a 100644
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -245,6 +245,9 @@ struct hda_gen_spec {
 	const struct badness_table *main_out_badness;
 	const struct badness_table *extra_out_badness;
 
+	/* preferred pin/DAC pairs; an array of paired NIDs */
+	const hda_nid_t *preferred_dacs;
+
 	/* loopback mixing mode */
 	bool aamix_mode;
 
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index a3d9143..c7db6e5 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1227,6 +1227,14 @@ static int ad1986a_parse_auto_config(struct hda_codec *codec)
 {
 	int err;
 	struct ad198x_spec *spec;
+	static hda_nid_t preferred_pairs[] = {
+		0x1a, 0x03,
+		0x1b, 0x03,
+		0x1c, 0x04,
+		0x1d, 0x05,
+		0x1e, 0x03,
+		0
+	};
 
 	err = alloc_ad_spec(codec);
 	if (err < 0)
@@ -1247,6 +1255,8 @@ static int ad1986a_parse_auto_config(struct hda_codec *codec)
 	 * So, let's disable the shared stream.
 	 */
 	spec->gen.multiout.no_share_stream = 1;
+	/* give fixed DAC/pin pairs */
+	spec->gen.preferred_dacs = preferred_pairs;
 
 	/* AD1986A can't manage the dynamic pin on/off smoothly */
 	spec->gen.auto_mute_via_amp = 1;
-- 
1.8.3.2

