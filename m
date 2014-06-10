Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaFJTvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:51:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35316 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaFJTvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 142/160] ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data
Date: Tue, 10 Jun 2014 12:46:22 -0700
Message-Id: <1402429600-20477-143-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/card.h     |  1 +
 sound/usb/endpoint.c | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index 9867ab8..97acb90 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -92,6 +92,7 @@ struct snd_usb_endpoint {
 	unsigned int curframesize;      /* current packet size in frames (for capture) */
 	unsigned int syncmaxsize;	/* sync endpoint packet size */
 	unsigned int fill_max:1;	/* fill max packet size always */
+	unsigned int udh01_fb_quirk:1;	/* corrupted feedback data */
 	unsigned int datainterval;      /* log_2 of data packet interval */
 	unsigned int syncinterval;	/* P for adaptive mode, 0 otherwise */
 	unsigned char silence_value;
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 83aabea2..814430f 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -469,6 +469,10 @@ struct snd_usb_endpoint *snd_usb_add_endpoint(struct snd_usb_audio *chip,
 			ep->syncinterval = 3;
 
 		ep->syncmaxsize = le16_to_cpu(get_endpoint(alts, 1)->wMaxPacketSize);
+
+		if (chip->usb_id == USB_ID(0x0644, 0x8038) /* TEAC UD-H01 */ &&
+		    ep->syncmaxsize == 4)
+			ep->udh01_fb_quirk = 1;
 	}
 
 	list_add_tail(&ep->list, &chip->ep_list);
@@ -1099,7 +1103,16 @@ void snd_usb_handle_sync_urb(struct snd_usb_endpoint *ep,
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
-- 
1.9.1

