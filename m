Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaCaAWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:22:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36313 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.428120792@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 081/200] ALSA: hda/realtek - Avoid invalid COEFs for
 ALC271X
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: return 0]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5157,6 +5157,9 @@ static int alc269_fill_coef(struct hda_c
 
 	if (spec->codec_variant != ALC269_TYPE_ALC269VB)
 		return 0;
+	/* ALC271X doesn't seem to support these COEFs (bko#52181) */
+	if (!strcmp(codec->chip_name, "ALC271X"))
+		return 0;
 
 	if ((alc_get_coef0(codec) & 0x00ff) < 0x015) {
 		alc_write_coef_idx(codec, 0xf, 0x960b);

