Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3HMGdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab3HMGdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Stone <jamesmstone@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 26/60] ALSA: usb-audio: do not trust too-big wMaxPacketSize values
Date: Mon, 12 Aug 2013 23:33:53 -0700
Message-Id: <20130813063335.671528526@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 57e6dae1087bbaa6b33d3dd8a8e90b63888939a3 upstream.

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
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/endpoint.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -591,17 +591,16 @@ static int data_ep_set_params(struct snd
 	ep->stride = frame_bits >> 3;
 	ep->silence_value = pcm_format == SNDRV_PCM_FORMAT_U8 ? 0x80 : 0;
 
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


