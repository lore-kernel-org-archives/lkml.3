Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab3BYWX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:23:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab3BYWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pawel Moll <mail@pawelmoll.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 46/58] ALSA: usb: Fix Processing Unit Descriptor parsers
Date: Mon, 25 Feb 2013 14:19:42 -0800
Message-Id: <20130225221646.218243797@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/usb/audio.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/usb/audio.h
+++ b/include/uapi/linux/usb/audio.h
@@ -384,14 +384,16 @@ static inline __u8 uac_processing_unit_i
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


