Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab3CDDqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:46:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33204 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757473Ab3CDDo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:56 -0500
Message-Id: <20130304033709.544089090@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:27 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Takashi Iwai <tiwai@suse.de>
Subject: [ 020/153] ALSA: hda - Release assigned pin/cvt at error path of
 hdmi_pcm_open()
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2ad779b7329d6894a80df94e693e72eaa0d56790 upstream.

If the driver detects and invalid ELD, it gives an open error.
But it forgot to release the assigned pin, converter and spdif ctls
before returning.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_hdmi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -918,8 +918,12 @@ static int hdmi_pcm_open(struct hda_pcm_
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


