Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaFDXiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:38:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaFDXXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 042/103] ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data
Date: Wed,  4 Jun 2014 16:25:05 -0700
Message-Id: <20140604232548.212166443@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 7040b6d1febfdbd9c1595efb751d492cd2503f96 upstream.

The TEAC UD-H01 firmware sends wrong feedback frequency values, thus
causing the PC to send the samples at a wrong rate, which results in
clicks and crackles in the output.

Add a workaround to detect and fix the corruption.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
[mick37@gmx.de: use sender->udh01_fb_quirk rather than
 ep->udh01_fb_quirk in snd_usb_handle_sync_urb()]
Reported-and-tested-by: Mick <mick37@gmx.de>
Reported-and-tested-by: Andrea Messa <andr.messa@tiscali.it>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.h     |    1 +
 sound/usb/endpoint.c |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -90,6 +90,7 @@ struct snd_usb_endpoint {
 	unsigned int curframesize;      /* current packet size in frames (for capture) */
 	unsigned int syncmaxsize;	/* sync endpoint packet size */
 	unsigned int fill_max:1;	/* fill max packet size always */
+	unsigned int udh01_fb_quirk:1;	/* corrupted feedback data */
 	unsigned int datainterval;      /* log_2 of data packet interval */
 	unsigned int syncinterval;	/* P for adaptive mode, 0 otherwise */
 	unsigned char silence_value;
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -467,6 +467,10 @@ struct snd_usb_endpoint *snd_usb_add_end
 			ep->syncinterval = 3;
 
 		ep->syncmaxsize = le16_to_cpu(get_endpoint(alts, 1)->wMaxPacketSize);
+
+		if (chip->usb_id == USB_ID(0x0644, 0x8038) /* TEAC UD-H01 */ &&
+		    ep->syncmaxsize == 4)
+			ep->udh01_fb_quirk = 1;
 	}
 
 	list_add_tail(&ep->list, &chip->ep_list);
@@ -1075,7 +1079,16 @@ void snd_usb_handle_sync_urb(struct snd_
 	if (f == 0)
 		return;
 
-	if (unlikely(ep->freqshift == INT_MIN)) {
+	if (unlikely(sender->udh01_fb_quirk)) {
+		/*
+		 * The TEAC UD-H01 firmware sometimes changes the feedback value
+		 * by +/- 0x1.0000.
+		 */
+		if (f < ep->freqn - 0x8000)
+			f += 0x10000;
+		else if (f > ep->freqn + 0x8000)
+			f -= 0x10000;
+	} else if (unlikely(ep->freqshift == INT_MIN)) {
 		/*
 		 * The first time we see a feedback value, determine its format
 		 * by shifting it left or right until it matches the nominal


