Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3IKE72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab3IKE5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:10 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=kAbo8CX66BQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XLqai-3zPlQA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=sxdxw85f_HOQXddcScQA:9 a=7t4jVOfIR2gA:10 a=MSl-tDqOz04A:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042920.934942476@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: James Stone <jamesmstone@gmail.com>, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [172/251] ALSA: usb-audio: do not trust too-big wMaxPacketSize values
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0172-ALSA-usb-audio-do-not-trust-too-big-wMaxPacketSize-v.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

[ Upstream commit 57e6dae1087bbaa6b33d3dd8a8e90b63888939a3 ]

The driver used to assume that the streaming endpoint's wMaxPacketSize
value would be an indication of how much data the endpoint expects or
sends, and compute the number of packets per URB using this value.

However, the Focusrite Scarlett 2i4 declares a value of 1024 bytes,
while only about 88 or 44 bytes are be actually used.  This discrepancy
would result in URBs with far too few packets, which would not work
correctly on the EHCI driver.

To get correct URBs, use wMaxPacketSize only as an upper limit on the
packet size.

Reported-by: James Stone <jamesmstone@gmail.com>
Tested-by: James Stone <jamesmstone@gmail.com>
Cc: <stable@vger.kernel.org> # 2.6.35+
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/endpoint.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index eafc889..38e9583 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -599,17 +599,16 @@ static int data_ep_set_params(struct snd_usb_endpoint *ep,
 	ep->stride = frame_bits >> 3;
 	ep->silence_value = format == SNDRV_PCM_FORMAT_U8 ? 0x80 : 0;
 
-	/* calculate max. frequency */
-	if (ep->maxpacksize) {
+	/* assume max. frequency is 25% higher than nominal */
+	ep->freqmax = ep->freqn + (ep->freqn >> 2);
+	maxsize = ((ep->freqmax + 0xffff) * (frame_bits >> 3))
+				>> (16 - ep->datainterval);
+	/* but wMaxPacketSize might reduce this */
+	if (ep->maxpacksize && ep->maxpacksize < maxsize) {
 		/* whatever fits into a max. size packet */
 		maxsize = ep->maxpacksize;
 		ep->freqmax = (maxsize / (frame_bits >> 3))
 				<< (16 - ep->datainterval);
-	} else {
-		/* no max. packet size: just take 25% higher than nominal */
-		ep->freqmax = ep->freqn + (ep->freqn >> 2);
-		maxsize = ((ep->freqmax + 0xffff) * (frame_bits >> 3))
-				>> (16 - ep->datainterval);
 	}
 
 	if (ep->fill_max)
-- 
1.7.10.4


