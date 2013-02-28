Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab3B1Oqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab3B1Oqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 023/139] ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()
Date: Thu, 28 Feb 2013 14:42:53 +0000
Message-Id: <1362062689-2567-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2ad779b7329d6894a80df94e693e72eaa0d56790 upstream.

If the driver detects and invalid ELD, it gives an open error.
But it forgot to release the assigned pin, converter and spdif ctls
before returning.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index f212c37..063afa2 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -926,8 +926,12 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
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
-- 
1.8.1.2

