Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab3HNKmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:42:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab3HNKi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 68/75] ALSA: usb-audio: do not trust too-big wMaxPacketSize values
Date: Wed, 14 Aug 2013 11:36:57 +0100
Message-Id: <1376476624-10011-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/endpoint.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 060dccb..5fa3bd7 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -582,17 +582,16 @@ static int data_ep_set_params(struct snd_usb_endpoint *ep,
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
1.8.3.2

