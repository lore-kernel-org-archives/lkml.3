Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab3BYWXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:23:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab3BYWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 47/58] ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()
Date: Mon, 25 Feb 2013 14:19:43 -0800
Message-Id: <20130225221646.401746712@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1100,8 +1100,12 @@ static int hdmi_pcm_open(struct hda_pcm_
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


