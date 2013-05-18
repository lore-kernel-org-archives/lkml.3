Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab3ERCUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:20:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab3ERCQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:55 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=uaquUXoJs9EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3eNsT8NUs50A:10 a=pGLkceISAAAA:8 a=7xNen2pyAAAA:8 a=gUlcKy5wAAAA:8 a=VwQbUJbxAAAA:8 a=5nsbfZ7KEJxCHIGmJagA:9 a=MSl-tDqOz04A:10 a=CmIqRP-2BzAA:10 a=7GnkPCvt3pwA:10 a=LI9Vle30uBYA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021649.162889919@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Mack <zonque@gmail.com>, <stable@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 046/136 ] ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0046-ALSA-snd-usb-try-harder-to-find-USB_DT_CS_ENDPOINT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

[ Upstream commit ebfc594c02148b6a85c2f178cf167a44a3c3ce10 ]

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
Cc: stable@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/stream.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 1de0c8c..e3c9b66 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -193,6 +193,14 @@ static int parse_uac_endpoint_attributes(struct snd_usb_audio *chip,
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
1.7.10.4


