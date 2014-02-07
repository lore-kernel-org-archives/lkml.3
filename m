Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaBGLuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:50:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41863 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbaBGLuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 099/233] ALSA: hda - Don't create duplicated ctls for loopback paths
Date: Fri,  7 Feb 2014 11:45:18 +0000
Message-Id: <1391773652-25214-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 43a8e50a46a4e1dd1451e4a4ffa1f7695fb7d287 upstream.

AD1986A mic pins (0x1d and 0x1f) share the same widget for controlling
the loopback volume/mute, but the generic parser didn't check it.
This ended up with the duplicated controls for the same effect.

This patch adds the check of the duplication for avoiding it.

After this fix, there will be only one control although it affects
both paths; this remaining issue should be fixed later in a different
patch.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66621
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_generic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 08172b1..d71509c 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -2827,9 +2827,11 @@ static bool look_for_mix_leaf_ctls(struct hda_codec *codec, hda_nid_t mix_nid,
 	if (num_conns < idx)
 		return false;
 	nid = list[idx];
-	if (!*mix_val && nid_has_volume(codec, nid, HDA_OUTPUT))
+	if (!*mix_val && nid_has_volume(codec, nid, HDA_OUTPUT) &&
+	    !is_ctl_associated(codec, nid, HDA_OUTPUT, 0, NID_PATH_VOL_CTL))
 		*mix_val = HDA_COMPOSE_AMP_VAL(nid, 3, 0, HDA_OUTPUT);
-	if (!*mute_val && nid_has_mute(codec, nid, HDA_OUTPUT))
+	if (!*mute_val && nid_has_mute(codec, nid, HDA_OUTPUT) &&
+	    !is_ctl_associated(codec, nid, HDA_OUTPUT, 0, NID_PATH_MUTE_CTL))
 		*mute_val = HDA_COMPOSE_AMP_VAL(nid, 3, 0, HDA_OUTPUT);
 
 	return *mix_val || *mute_val;
-- 
1.8.3.2

