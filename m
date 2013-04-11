Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852Ab3DKUfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:35:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32712 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab3DKU0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:11 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=oiqsuzUB7swA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_XyZZvWGNs4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Ll6gbR8yTfsDRATT0isA:9 a=MSl-tDqOz04A:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202551.103023750@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 030/171 ] ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0030-ALSA-snd-usb-mixer-ignore-EINVAL-in-snd_usb_mixer_co.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

[ Upstream commit 83ea5d18d74f032a760fecde78c0210f66f7f70c ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/mixer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index c20a0c5..900bf42 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2040,7 +2040,7 @@ static int snd_usb_mixer_controls(struct usb_mixer_interface *mixer)
 			state.oterm.type = le16_to_cpu(desc->wTerminalType);
 			state.oterm.name = desc->iTerminal;
 			err = parse_audio_unit(&state, desc->bSourceID);
-			if (err < 0)
+			if (err < 0 && err != -EINVAL)
 				return err;
 		} else { /* UAC_VERSION_2 */
 			struct uac2_output_terminal_descriptor *desc = p;
@@ -2052,12 +2052,12 @@ static int snd_usb_mixer_controls(struct usb_mixer_interface *mixer)
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
1.7.10.4


