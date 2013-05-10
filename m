Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3EJOev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:34:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57184 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755311Ab3EJOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Daniel Mack" <zonque@gmail.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.625975403@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [055/118] ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/stream.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -168,6 +168,14 @@ static int parse_uac_endpoint_attributes
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

