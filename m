Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3IBJOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:14:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37622 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab3IBIyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:54:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Torstein Hegge <hegge@resisty.net>, Takashi Iwai <tiwai@suse.de>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 02/58] ALSA: usb: Parse UAC2 extension unit like for UAC1
Date: Mon,  2 Sep 2013 09:53:47 +0100
Message-Id: <1378112083-9475-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torstein Hegge <hegge@resisty.net>

commit 61ac51301e6c6d4ed977d7674ce2b8e713619a9b upstream.

UAC2_EXTENSION_UNIT_V2 differs from UAC1_EXTENSION_UNIT, but can be handled in
the same way when parsing the unit. Otherwise parse_audio_unit() fails when it
sees an extension unit on a UAC2 device.

UAC2_EXTENSION_UNIT_V2 is outside the range allocated by UAC1.

Signed-off-by: Torstein Hegge <hegge@resisty.net>
Acked-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/mixer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 3e513a8..9c6a7fe 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -720,7 +720,10 @@ static int check_input_term(struct mixer_build *state, int id, struct usb_audio_
 			return 0;
 		}
 		case UAC1_PROCESSING_UNIT:
-		case UAC1_EXTENSION_UNIT: {
+		case UAC1_EXTENSION_UNIT:
+		/* UAC2_PROCESSING_UNIT_V2 */
+		/* UAC2_EFFECT_UNIT */
+		case UAC2_EXTENSION_UNIT_V2: {
 			struct uac_processing_unit_descriptor *d = p1;
 			if (d->bNrInPins) {
 				id = d->baSourceID[0];
@@ -1983,6 +1986,8 @@ static int parse_audio_unit(struct mixer_build *state, int unitid)
 			return parse_audio_extension_unit(state, unitid, p1);
 		else /* UAC_VERSION_2 */
 			return parse_audio_processing_unit(state, unitid, p1);
+	case UAC2_EXTENSION_UNIT_V2:
+		return parse_audio_extension_unit(state, unitid, p1);
 	default:
 		snd_printk(KERN_ERR "usbaudio: unit %u: unexpected type 0x%02x\n", unitid, p1[2]);
 		return -EINVAL;
-- 
1.8.3.2

