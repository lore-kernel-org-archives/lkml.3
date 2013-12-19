Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3LSMI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:08:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45315 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab3LSL7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 183/208] ALSA: hda - hdmi: Fix IEC958 ctl indexes for some simple HDMI devices
Date: Thu, 19 Dec 2013 11:54:41 +0000
Message-Id: <1387454106-19326-184-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 4fb8bc3..0b36c63 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2087,8 +2087,9 @@ static int simple_playback_build_controls(struct hda_codec *codec)
 	int err;
 
 	per_cvt = get_cvt(spec, 0);
-	err = snd_hda_create_spdif_out_ctls(codec, per_cvt->cvt_nid,
-					    per_cvt->cvt_nid);
+	err = snd_hda_create_dig_out_ctls(codec, per_cvt->cvt_nid,
+					  per_cvt->cvt_nid,
+					  HDA_PCM_TYPE_HDMI);
 	if (err < 0)
 		return err;
 	return simple_hdmi_build_jack(codec, 0);
-- 
1.8.3.2

