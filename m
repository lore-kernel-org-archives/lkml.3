Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab3CZWoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3CZWoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 32/98] ALSA: snd-usb: mixer: propagate errors up the call chain
Date: Tue, 26 Mar 2013 15:42:21 -0700
Message-Id: <20130326224245.764844262@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 4d7b86c98e445b075c2c4c3757eb6d3d6efbe72e upstream.

In check_input_term() and parse_audio_feature_unit(), propagate the
error value that has been returned by a failing function instead of
-EINVAL. That helps cleaning up the error pathes in the mixer.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -715,8 +715,9 @@ static int check_input_term(struct mixer
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
@@ -1356,8 +1357,9 @@ static int parse_audio_feature_unit(stru
 		return err;
 
 	/* determine the input source type and name */
-	if (check_input_term(state, hdr->bSourceID, &iterm) < 0)
-		return -EINVAL;
+	err = check_input_term(state, hdr->bSourceID, &iterm);
+	if (err < 0)
+		return err;
 
 	master_bits = snd_usb_combine_bytes(bmaControls, csize);
 	/* master configuration quirks */


