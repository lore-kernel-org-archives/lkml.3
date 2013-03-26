Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164Ab3CZPqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:46:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53909 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965060Ab3CZPXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 085/150] ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()
Date: Tue, 26 Mar 2013 15:19:44 +0000
Message-Id: <1364311249-14454-86-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/mixer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 1b523a1..4d8ddc6 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2047,7 +2047,7 @@ static int snd_usb_mixer_controls(struct usb_mixer_interface *mixer)
 			state.oterm.type = le16_to_cpu(desc->wTerminalType);
 			state.oterm.name = desc->iTerminal;
 			err = parse_audio_unit(&state, desc->bSourceID);
-			if (err < 0)
+			if (err < 0 && err != -EINVAL)
 				return err;
 		} else { /* UAC_VERSION_2 */
 			struct uac2_output_terminal_descriptor *desc = p;
@@ -2059,12 +2059,12 @@ static int snd_usb_mixer_controls(struct usb_mixer_interface *mixer)
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
-- 
1.8.1.2

