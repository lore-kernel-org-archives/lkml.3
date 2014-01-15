Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaAOWG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:06:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaAOWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:20 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 043/166] ALSA: hda - hdmi: Fix IEC958 ctl indexes for some simple HDMI devices
Date: Wed, 15 Jan 2014 13:50:57 -0800
Message-Id: <1389822780-4729-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit c9a6338aecdb92f9d015ecc26d203e54250bebbb upstream.

In case a single HDA card has both HDMI and S/PDIF outputs, the S/PDIF
outputs will have their IEC958 controls created starting from index 16
and the HDMI controls will be created starting from index 0.

However, HDMI simple_playback_build_controls() as used by old VIA and
NVIDIA codecs incorrectly requests the IEC958 controls to be created
with an S/PDIF type instead of HDMI.
In case the card has other codecs that have HDMI outputs, the controls
will be created with wrong index=16, causing them to e.g. be unreachable
by the ALSA "hdmi" alias.

Fix that by making simple_playback_build_controls() request controls
with HDMI indexes.

Not many cards have an affected configuration, but e.g. ASUS M3N78-VM
contains an integrated NVIDIA HDA "card" with:
- a VIA codec that has, among others, an S/PDIF pin incorrectly
  labelled as an HDMI pin, and
- an NVIDIA MCP7x HDMI codec.

Reported-by: MysterX on #openelec
Tested-by: MysterX on #openelec
Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 01b98b0..027e4f0 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1800,9 +1800,9 @@ static int simple_playback_build_controls(struct hda_codec *codec)
 	struct hdmi_spec *spec = codec->spec;
 	int err;
 
-	err = snd_hda_create_spdif_out_ctls(codec,
-					    spec->cvts[0].cvt_nid,
-					    spec->cvts[0].cvt_nid);
+	err = snd_hda_create_dig_out_ctls(codec, spec->cvts[0].cvt_nid,
+					  spec->cvts[0].cvt_nid,
+					  HDA_PCM_TYPE_HDMI);
 	if (err < 0)
 		return err;
 	return simple_hdmi_build_jack(codec, 0);
-- 
1.8.3.2

