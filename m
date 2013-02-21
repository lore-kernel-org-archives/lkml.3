Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3BUCCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:02:17 -0500
Received: from service.web3.rootnode.net ([46.105.38.32]:54599 "EHLO
	mail1.rootnode.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3BUCCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:02:15 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2013 21:02:15 EST
From: Pawel Moll <mail@pawelmoll.com>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: Daniel Mack <daniel@caiaq.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Pawel Moll <mail@pawelmoll.com>
Subject: [PATCH] ALSA: usb: Fix Processing Unit Descriptor parsers
Date: Thu, 21 Feb 2013 01:55:50 +0000
Message-Id: <1361411750-30056-1-git-send-email-mail@pawelmoll.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 99fc86450c439039d2ef88d06b222fd51a779176 "ALSA: usb-mixer:
parse descriptors with structs" introduced a set of useful parsers
for descriptors. Unfortunately the parses for the Processing Unit
Descriptor came with a very subtle bug...

Functions uac_processing_unit_iProcessing() and
uac_processing_unit_specific() were indexing the baSourceID array
forgetting the fields before the iProcessing and process-specific
descriptors.

The problem was observed with Sound Blaster Extigy mixer,
where nNrModes in Up/Down-mix Processing Unit Descriptor
was accessed at offset 10 of the descriptor (value 0)
instead of offset 15 (value 7). In result the resulting
control had interesting limit values:

Simple mixer control 'Channel Routing Mode Select',0
  Capabilities: volume volume-joined penum
  Playback channels: Mono
  Capture channels: Mono
  Limits: 0 - -1
  Mono: -1 [100%]

Fixed by starting from the bmControls, which was calculated
correctly, instead of baSourceID.

Now the mentioned control is fine:

Simple mixer control 'Channel Routing Mode Select',0
  Capabilities: volume volume-joined penum
  Playback channels: Mono
  Capture channels: Mono
  Limits: 0 - 6
  Mono: 0 [0%]

Signed-off-by: Pawel Moll <mail@pawelmoll.com>
---
 include/uapi/linux/usb/audio.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/usb/audio.h b/include/uapi/linux/usb/audio.h
index ac90037..d2314be 100644
--- a/include/uapi/linux/usb/audio.h
+++ b/include/uapi/linux/usb/audio.h
@@ -384,14 +384,16 @@ static inline __u8 uac_processing_unit_iProcessing(struct uac_processing_unit_de
 						   int protocol)
 {
 	__u8 control_size = uac_processing_unit_bControlSize(desc, protocol);
-	return desc->baSourceID[desc->bNrInPins + control_size];
+	return *(uac_processing_unit_bmControls(desc, protocol)
+			+ control_size);
 }
 
 static inline __u8 *uac_processing_unit_specific(struct uac_processing_unit_descriptor *desc,
 						 int protocol)
 {
 	__u8 control_size = uac_processing_unit_bControlSize(desc, protocol);
-	return &desc->baSourceID[desc->bNrInPins + control_size + 1];
+	return uac_processing_unit_bmControls(desc, protocol)
+			+ control_size + 1;
 }
 
 /* 4.5.2 Class-Specific AS Interface Descriptor */
-- 
1.7.10.4

