Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3CYBbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:31:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33944 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755952Ab3CYBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:55 -0400
Message-Id: <20130325010530.999616790@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:32 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Mack <zonque@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 068/104] ALSA: snd-usb: mixer: propagate errors up the call chain
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 4d7b86c98e445b075c2c4c3757eb6d3d6efbe72e upstream.

In check_input_term() and parse_audio_feature_unit(), propagate the
error value that has been returned by a failing function instead of
-EINVAL. That helps cleaning up the error pathes in the mixer.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/mixer.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -711,8 +711,9 @@ static int check_input_term(struct mixer
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
@@ -1263,8 +1264,9 @@ static int parse_audio_feature_unit(stru
 		return err;
 
 	/* determine the input source type and name */
-	if (check_input_term(state, hdr->bSourceID, &iterm) < 0)
-		return -EINVAL;
+	err = check_input_term(state, hdr->bSourceID, &iterm);
+	if (err < 0)
+		return err;
 
 	master_bits = snd_usb_combine_bytes(bmaControls, csize);
 	/* master configuration quirks */


