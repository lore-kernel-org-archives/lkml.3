Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaISL4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:56:44 -0400
Received: from avasout03.plus.net ([84.93.230.244]:34724 "EHLO
	avasout03.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbaISL4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:56:43 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Sep 2014 07:56:43 EDT
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.1 cv=X6ncKQje c=1 sm=1 tr=0
 a=VGUxJGZ/H8UixBFj6Q9CRg==:117 a=VGUxJGZ/H8UixBFj6Q9CRg==:17 a=0Bzu9jTXAAAA:8
 a=MNywjXDINhEA:10 a=MKSCr0E1VDwA:10 a=NunxZpRWgsAA:10 a=eIRpCU4CAAAA:8
 a=x5wP3IcZ2IpP0OpUtiUA:9 a=JslQj40bar0A:10
X-AUTH: oscars+hm:2500
From: Howard Mitchell <hm@hmbedded.co.uk>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Howard Mitchell <hm@hmbedded.co.uk>
Subject: [PATCH] soc-core: Fix volsw_range funcs so SOC_DOUBLE_R_RANGE_TLV works.
Date: Fri, 19 Sep 2014 12:50:31 +0100
Message-Id: <1411127431-31144-1-git-send-email-hm@hmbedded.co.uk>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a bug when using the SOC_DOUBLE_R_RANGE_TLV macro in
the invert mode. In the non-invert case, e.g.

SOC_DOUBLE_R_RANGE_TLV("<name>", <reg_l>, <reg_r>,
					0, 40, 255, 0, <tlv>)

the range sent to the hardware is 40..255, but in the invert case:

SOC_DOUBLE_R_RANGE_TLV("<name>", <reg_l>, <reg_r>,
					0, 40, 255, 1, <tlv>)

the range 215..0 was being sent to the hardware. This commit
corrects this to 255..40 so it is consistent with the non-invert
case.

Signed-off-by: Howard Mitchell <hm@hmbedded.co.uk>
---
 sound/soc/soc-core.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index d4bfd4a..6a58af3 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3027,9 +3027,10 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	unsigned int val, val_mask;
 	int ret;
 
-	val = ((ucontrol->value.integer.value[0] + min) & mask);
 	if (invert)
-		val = max - val;
+		val = (max - ucontrol->value.integer.value[0]) & mask;
+	else
+		val = ((ucontrol->value.integer.value[0] + min) & mask);
 	val_mask = mask << shift;
 	val = val << shift;
 
@@ -3038,9 +3039,10 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 		return ret;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
-		val = ((ucontrol->value.integer.value[1] + min) & mask);
 		if (invert)
-			val = max - val;
+			val = (max - ucontrol->value.integer.value[1]) & mask;
+		else
+			val = ((ucontrol->value.integer.value[1] + min) & mask);
 		val_mask = mask << shift;
 		val = val << shift;
 
@@ -3085,8 +3087,9 @@ int snd_soc_get_volsw_range(struct snd_kcontrol *kcontrol,
 	if (invert)
 		ucontrol->value.integer.value[0] =
 			max - ucontrol->value.integer.value[0];
-	ucontrol->value.integer.value[0] =
-		ucontrol->value.integer.value[0] - min;
+	else
+		ucontrol->value.integer.value[0] =
+			ucontrol->value.integer.value[0] - min;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
 		ret = snd_soc_component_read(component, rreg, &val);
@@ -3097,8 +3100,9 @@ int snd_soc_get_volsw_range(struct snd_kcontrol *kcontrol,
 		if (invert)
 			ucontrol->value.integer.value[1] =
 				max - ucontrol->value.integer.value[1];
-		ucontrol->value.integer.value[1] =
-			ucontrol->value.integer.value[1] - min;
+		else
+			ucontrol->value.integer.value[1] =
+				ucontrol->value.integer.value[1] - min;
 	}
 
 	return 0;
-- 
1.7.9.5

