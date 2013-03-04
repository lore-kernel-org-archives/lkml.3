Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab3CDEDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:03:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32888 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756415Ab3CDDnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:43 -0500
Message-Id: <20130304033716.164533423@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:34 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Pawel Moll <mail@pawelmoll.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 087/153] ALSA: usb: Fix Processing Unit Descriptor parsers
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/usb/audio.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/usb/audio.h
+++ b/include/linux/usb/audio.h
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


