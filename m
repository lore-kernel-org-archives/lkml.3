Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3ETLWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:22:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab3ETKwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 024/115] ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT
Date: Mon, 20 May 2013 11:50:24 +0100
Message-Id: <1369047116-9378-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit ebfc594c02148b6a85c2f178cf167a44a3c3ce10 upstream.

The USB_DT_CS_ENDPOINT class-specific endpoint descriptor is usually
stuffed directly after the standard USB endpoint descriptor, and this is
where the driver currently expects it to be.

There are, however, devices in the wild that have it the other way
around in their descriptor sets, so the USB_DT_CS_ENDPOINT comes
*before* the standard enpoint. Devices known to implement it that way
are "Sennheiser BTD-500" and Plantronics USB headsets.

When the driver can't find the USB_DT_CS_ENDPOINT, it won't be able to
change sample rates, as the bitmask for the validity of this command is
storen in bmAttributes of that descriptor.

Fix this by searching the entire interface instead of just the extra
bytes of the first endpoint, in case the latter fails.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-and-tested-by: Torstein Hegge <hegge@resisty.net>
Reported-and-tested-by: Yves G <alsa-user@vivigatt.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/stream.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 2025205..1891e49b 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -194,6 +194,14 @@ static int parse_uac_endpoint_attributes(struct snd_usb_audio *chip,
 	if (!csep && altsd->bNumEndpoints >= 2)
 		csep = snd_usb_find_desc(alts->endpoint[1].extra, alts->endpoint[1].extralen, NULL, USB_DT_CS_ENDPOINT);
 
+	/*
+	 * If we can't locate the USB_DT_CS_ENDPOINT descriptor in the extra
+	 * bytes after the first endpoint, go search the entire interface.
+	 * Some devices have it directly *before* the standard endpoint.
+	 */
+	if (!csep)
+		csep = snd_usb_find_desc(alts->extra, alts->extralen, NULL, USB_DT_CS_ENDPOINT);
+
 	if (!csep || csep->bLength < 7 ||
 	    csep->bDescriptorSubtype != UAC_EP_GENERAL) {
 		snd_printk(KERN_WARNING "%d:%u:%d : no or invalid"
-- 
1.8.1.2

