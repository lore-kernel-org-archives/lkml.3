Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab3FPW3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:29:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46290 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755477Ab3FPWIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Xi Wang" <xi.wang@gmail.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.17180767@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [14/83] ALSA: usb-audio: avoid integer overflow in
 create_fixed_stream_quirk()
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit 8866f405efd4171f9d9c91901d2dd02f01bacb60 upstream.

A malicious USB device could feed in a large nr_rates value.  This would
cause the subsequent call to kmemdup() to allocate a smaller buffer than
expected, leading to out-of-bounds access.

This patch validates the nr_rates value and reuses the limit introduced
in commit 4fa0e81b ("ALSA: usb-audio: fix possible hang and overflow
in parse_uac2_sample_rate_range()").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/card.h   |    1 +
 sound/usb/format.c |    4 +---
 sound/usb/quirks.c |    6 +++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index a39edcc..da5fa1a 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -1,6 +1,7 @@
 #ifndef __USBAUDIO_CARD_H
 #define __USBAUDIO_CARD_H
 
+#define MAX_NR_RATES	1024
 #define MAX_PACKS	20
 #define MAX_PACKS_HS	(MAX_PACKS * 8)	/* in high speed mode */
 #define MAX_URBS	8
diff --git a/sound/usb/format.c b/sound/usb/format.c
index e09aba1..ddfef57 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -209,8 +209,6 @@ static int parse_audio_format_rates_v1(struct snd_usb_audio *chip, struct audiof
 	return 0;
 }
 
-#define MAX_UAC2_NR_RATES 1024
-
 /*
  * Helper function to walk the array of sample rate triplets reported by
  * the device. The problem is that we need to parse whole array first to
@@ -255,7 +253,7 @@ static int parse_uac2_sample_rate_range(struct audioformat *fp, int nr_triplets,
 			fp->rates |= snd_pcm_rate_to_rate_bit(rate);
 
 			nr_rates++;
-			if (nr_rates >= MAX_UAC2_NR_RATES) {
+			if (nr_rates >= MAX_NR_RATES) {
 				snd_printk(KERN_ERR "invalid uac2 rates\n");
 				break;
 			}
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index a3ddac0..2781726 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -132,10 +132,14 @@ static int create_fixed_stream_quirk(struct snd_usb_audio *chip,
 	unsigned *rate_table = NULL;
 
 	fp = kmemdup(quirk->data, sizeof(*fp), GFP_KERNEL);
-	if (! fp) {
+	if (!fp) {
 		snd_printk(KERN_ERR "cannot memdup\n");
 		return -ENOMEM;
 	}
+	if (fp->nr_rates > MAX_NR_RATES) {
+		kfree(fp);
+		return -EINVAL;
+	}
 	if (fp->nr_rates > 0) {
 		rate_table = kmemdup(fp->rate_table,
 				     sizeof(int) * fp->nr_rates, GFP_KERNEL);

