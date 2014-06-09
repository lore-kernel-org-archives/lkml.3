Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbaFIJL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:11:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58433 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 062/146] ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data
Date: Mon,  9 Jun 2014 10:49:57 +0200
Message-Id: <fde051cada91a1ae03eec8b8dd13b09379cf9dbf.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/usb/card.h     |  1 +
 sound/usb/endpoint.c | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index 5ecacaa90b53..2d30a9e6aaed 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -91,6 +91,7 @@ struct snd_usb_endpoint {
 	unsigned int curframesize;      /* current packet size in frames (for capture) */
 	unsigned int syncmaxsize;	/* sync endpoint packet size */
 	unsigned int fill_max:1;	/* fill max packet size always */
+	unsigned int udh01_fb_quirk:1;	/* corrupted feedback data */
 	unsigned int datainterval;      /* log_2 of data packet interval */
 	unsigned int syncinterval;	/* P for adaptive mode, 0 otherwise */
 	unsigned char silence_value;
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 93e970f2b3c0..ba106c6c2d3a 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -470,6 +470,10 @@ struct snd_usb_endpoint *snd_usb_add_endpoint(struct snd_usb_audio *chip,
 			ep->syncinterval = 3;
 
 		ep->syncmaxsize = le16_to_cpu(get_endpoint(alts, 1)->wMaxPacketSize);
+
+		if (chip->usb_id == USB_ID(0x0644, 0x8038) /* TEAC UD-H01 */ &&
+		    ep->syncmaxsize == 4)
+			ep->udh01_fb_quirk = 1;
 	}
 
 	list_add_tail(&ep->list, &chip->ep_list);
@@ -1078,7 +1082,16 @@ void snd_usb_handle_sync_urb(struct snd_usb_endpoint *ep,
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
1.9.3

