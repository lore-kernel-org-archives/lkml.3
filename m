Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185Ab3CZPq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:46:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53904 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965145Ab3CZPXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 084/150] ALSA: snd-usb: mixer: propagate errors up the call chain
Date: Tue, 26 Mar 2013 15:19:43 +0000
Message-Id: <1364311249-14454-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 4d7b86c98e445b075c2c4c3757eb6d3d6efbe72e upstream.

In check_input_term() and parse_audio_feature_unit(), propagate the
error value that has been returned by a failing function instead of
-EINVAL. That helps cleaning up the error pathes in the mixer.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/mixer.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 41e8bfb..1b523a1 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -711,8 +711,9 @@ static int check_input_term(struct mixer_build *state, int id, struct usb_audio_
 		case UAC2_CLOCK_SELECTOR: {
 			struct uac_selector_unit_descriptor *d = p1;
 			/* call recursively to retrieve the channel info */
-			if (check_input_term(state, d->baSourceID[0], term) < 0)
-				return -ENODEV;
+			err = check_input_term(state, d->baSourceID[0], term);
+			if (err < 0)
+				return err;
 			term->type = d->bDescriptorSubtype << 16; /* virtual type */
 			term->id = id;
 			term->name = uac_selector_unit_iSelector(d);
@@ -1283,8 +1284,9 @@ static int parse_audio_feature_unit(struct mixer_build *state, int unitid, void
 		return err;
 
 	/* determine the input source type and name */
-	if (check_input_term(state, hdr->bSourceID, &iterm) < 0)
-		return -EINVAL;
+	err = check_input_term(state, hdr->bSourceID, &iterm);
+	if (err < 0)
+		return err;
 
 	master_bits = snd_usb_combine_bytes(bmaControls, csize);
 	/* master configuration quirks */
-- 
1.8.1.2

