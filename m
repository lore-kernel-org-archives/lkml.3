Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936298AbaBDWsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:48:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbaBDVC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 062/104] ALSA: hda - Dont create duplicated ctls for loopback paths
Date: Tue,  4 Feb 2014 13:02:05 -0800
Message-Id: <20140204210224.472462607@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -2796,9 +2796,11 @@ static bool look_for_mix_leaf_ctls(struc
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


