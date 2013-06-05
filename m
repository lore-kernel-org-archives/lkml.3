Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3FEUyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:54:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3FEUxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 31/33] ALSA: usb-audio: avoid integer overflow in create_fixed_stream_quirk()
Date: Wed,  5 Jun 2013 13:53:09 -0700
Message-Id: <20130605204709.548278568@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605204702.359510786@linuxfoundation.org>
References: <20130605204702.359510786@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.h   |    1 +
 sound/usb/format.c |    4 +---
 sound/usb/quirks.c |    6 +++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -1,6 +1,7 @@
 #ifndef __USBAUDIO_CARD_H
 #define __USBAUDIO_CARD_H
 
+#define MAX_NR_RATES	1024
 #define MAX_PACKS	20
 #define MAX_PACKS_HS	(MAX_PACKS * 8)	/* in high speed mode */
 #define MAX_URBS	8
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -209,8 +209,6 @@ static int parse_audio_format_rates_v1(s
 	return 0;
 }
 
-#define MAX_UAC2_NR_RATES 1024
-
 /*
  * Helper function to walk the array of sample rate triplets reported by
  * the device. The problem is that we need to parse whole array first to
@@ -255,7 +253,7 @@ static int parse_uac2_sample_rate_range(
 			fp->rates |= snd_pcm_rate_to_rate_bit(rate);
 
 			nr_rates++;
-			if (nr_rates >= MAX_UAC2_NR_RATES) {
+			if (nr_rates >= MAX_NR_RATES) {
 				snd_printk(KERN_ERR "invalid uac2 rates\n");
 				break;
 			}
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -131,10 +131,14 @@ static int create_fixed_stream_quirk(str
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
 		rate_table = kmalloc(sizeof(int) * fp->nr_rates, GFP_KERNEL);
 		if (!rate_table) {


