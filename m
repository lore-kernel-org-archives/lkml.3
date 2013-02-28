Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3B1Osp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:48:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3B1Osl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pawel Moll <mail@pawelmoll.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 070/139] ALSA: usb: Fix Processing Unit Descriptor parsers
Date: Thu, 28 Feb 2013 14:43:40 +0000
Message-Id: <1362062689-2567-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Moll <mail@pawelmoll.com>

commit b531f81b0d70ffbe8d70500512483227cc532608 upstream.

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
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: include/uapi/linux/usb/audio.h -> include/linux/usb/audio.h,
  adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/usb/audio.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/usb/audio.h b/include/linux/usb/audio.h
index a54b825..6f8b026 100644
--- a/include/linux/usb/audio.h
+++ b/include/linux/usb/audio.h
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
1.8.1.2

