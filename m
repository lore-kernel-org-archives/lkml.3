Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393Ab3B0AJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:09:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367Ab3B0AJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 39/86] ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()
Date: Tue, 26 Feb 2013 16:07:47 -0800
Message-Id: <20130226235916.947873442@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2ad779b7329d6894a80df94e693e72eaa0d56790 upstream.

If the driver detects and invalid ELD, it gives an open error.
But it forgot to release the assigned pin, converter and spdif ctls
before returning.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -924,8 +924,12 @@ static int hdmi_pcm_open(struct hda_pcm_
 	if (!static_hdmi_pcm && eld->eld_valid) {
 		snd_hdmi_eld_update_pcm_info(eld, hinfo);
 		if (hinfo->channels_min > hinfo->channels_max ||
-		    !hinfo->rates || !hinfo->formats)
+		    !hinfo->rates || !hinfo->formats) {
+			per_cvt->assigned = 0;
+			hinfo->nid = 0;
+			snd_hda_spdif_ctls_unassign(codec, pin_idx);
 			return -ENODEV;
+		}
 	}
 
 	/* Store the updated parameters */


