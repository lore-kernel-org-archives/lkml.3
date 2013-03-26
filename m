Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3CZWwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:52:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab3CZWwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 34/72] ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()
Date: Tue, 26 Mar 2013 15:51:17 -0700
Message-Id: <20130326224923.216836194@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 83ea5d18d74f032a760fecde78c0210f66f7f70c upstream.

Creation of individual mixer controls may fail, but that shouldn't cause
the entire mixer creation to fail. Even worse, if the mixer creation
fails, that will error out the entire device probing.

All the functions called by parse_audio_unit() should return -EINVAL if
they find descriptors that are unsupported or believed to be malformed,
so we can safely handle this error code as a non-fatal condition in
snd_usb_mixer_controls().

That fixes a long standing bug which is commonly worked around by
adding quirks which make the driver ignore entire interfaces. Some of
them might now be unnecessary.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-and-tested-by: Rodolfo Thomazelli <pe.soberbo@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2027,7 +2027,7 @@ static int snd_usb_mixer_controls(struct
 			state.oterm.type = le16_to_cpu(desc->wTerminalType);
 			state.oterm.name = desc->iTerminal;
 			err = parse_audio_unit(&state, desc->bSourceID);
-			if (err < 0)
+			if (err < 0 && err != -EINVAL)
 				return err;
 		} else { /* UAC_VERSION_2 */
 			struct uac2_output_terminal_descriptor *desc = p;
@@ -2039,12 +2039,12 @@ static int snd_usb_mixer_controls(struct
 			state.oterm.type = le16_to_cpu(desc->wTerminalType);
 			state.oterm.name = desc->iTerminal;
 			err = parse_audio_unit(&state, desc->bSourceID);
-			if (err < 0)
+			if (err < 0 && err != -EINVAL)
 				return err;
 
 			/* for UAC2, use the same approach to also add the clock selectors */
 			err = parse_audio_unit(&state, desc->bCSourceID);
-			if (err < 0)
+			if (err < 0 && err != -EINVAL)
 				return err;
 		}
 	}


