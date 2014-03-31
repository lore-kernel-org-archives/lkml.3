Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaCaNaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:30:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35848 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbaCaNYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 64/71] ALSA: hda/realtek - Avoid invalid COEFs for ALC271X
Date: Mon, 31 Mar 2014 14:23:10 +0100
Message-Id: <1396272197-13394-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d3c56568f43807135f2c2a09582a69f809f0d8b7 upstream.

We've seen often problems after suspend/resume on Acer Aspire One
AO725 with ALC271X codec as reported in kernel bugzilla, and it turned
out that some COEFs doesn't work and triggers the codec communication
stall.

Since these magic COEF setups are specific to ALC269VB for some PLL
configurations, the machine works even without these manual
adjustment.  So, let's simply avoid applying them for ALC271X.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=52181
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9df1421..21bc6d6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6164,6 +6164,9 @@ static void alc269_fill_coef(struct hda_codec *codec)
 
 	if (spec->codec_variant != ALC269_TYPE_ALC269VB)
 		return;
+	/* ALC271X doesn't seem to support these COEFs (bko#52181) */
+	if (!strcmp(codec->chip_name, "ALC271X"))
+		return;
 
 	if ((alc_get_coef0(codec) & 0x00ff) < 0x015) {
 		alc_write_coef_idx(codec, 0xf, 0x960b);
-- 
1.9.1

