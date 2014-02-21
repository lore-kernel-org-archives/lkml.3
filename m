Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbaBUMts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46806 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbaBUMtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 024/121] ALSA: hda - Improve loopback path lookups for AD1983
Date: Fri, 21 Feb 2014 12:47:28 +0000
Message-Id: <1392986945-9693-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 276ab336b4c6e483d12fd46cbf24f97f71867710 upstream.

AD1983 has flexible loopback routes and the generic parser would take
wrong path confusingly instead of taking individual paths via NID 0x0c
and 0x0d.  For avoiding it, limit the connections at these widgets so
that the parser can think more straightforwardly.  This fixes the
regression of the missing line-in loopback on Dell machine.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=70011
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_analog.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index ab1526c..3d8e567 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1695,6 +1695,8 @@ static int ad1983_add_spdif_mux_ctl(struct hda_codec *codec)
 static int ad1983_parse_auto_config(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
+	static hda_nid_t conn_0c[] = { 0x08 };
+	static hda_nid_t conn_0d[] = { 0x09 };
 	int err;
 
 	err = alloc_ad_spec(codec);
@@ -1705,6 +1707,11 @@ static int ad1983_parse_auto_config(struct hda_codec *codec)
 	spec->gen.mixer_nid = 0x0e;
 	spec->gen.beep_nid = 0x10;
 	set_beep_amp(spec, 0x10, 0, HDA_OUTPUT);
+
+	/* limit the loopback routes not to confuse the parser */
+	snd_hda_override_conn_list(codec, 0x0c, ARRAY_SIZE(conn_0c), conn_0c);
+	snd_hda_override_conn_list(codec, 0x0d, ARRAY_SIZE(conn_0d), conn_0d);
+
 	err = ad198x_parse_auto_config(codec);
 	if (err < 0)
 		goto error;
-- 
1.9.0

