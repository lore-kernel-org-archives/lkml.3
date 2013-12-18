Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3LRVN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:13:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3LRVNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 005/118] ALSA: hda - Add static DAC/pin mapping for AD1986A codec
Date: Wed, 18 Dec 2013 13:10:42 -0800
Message-Id: <20131218211219.617592164@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c  |   23 ++++++++++++++++++++++-
 sound/pci/hda/hda_generic.h  |    3 +++
 sound/pci/hda/patch_analog.c |   10 ++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -474,6 +474,20 @@ static void invalidate_nid_path(struct h
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
@@ -1192,7 +1206,14 @@ static int try_assign_dacs(struct hda_co
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
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -249,6 +249,9 @@ struct hda_gen_spec {
 	const struct badness_table *main_out_badness;
 	const struct badness_table *extra_out_badness;
 
+	/* preferred pin/DAC pairs; an array of paired NIDs */
+	const hda_nid_t *preferred_dacs;
+
 	/* loopback mixing mode */
 	bool aamix_mode;
 
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -324,6 +324,14 @@ static int patch_ad1986a(struct hda_code
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
@@ -344,6 +352,8 @@ static int patch_ad1986a(struct hda_code
 	 * So, let's disable the shared stream.
 	 */
 	spec->gen.multiout.no_share_stream = 1;
+	/* give fixed DAC/pin pairs */
+	spec->gen.preferred_dacs = preferred_pairs;
 
 	/* AD1986A can't manage the dynamic pin on/off smoothly */
 	spec->gen.auto_mute_via_amp = 1;


