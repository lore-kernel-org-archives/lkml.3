Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab3FEUxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:53:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab3FEUxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Xi Wang <xi.wang@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 30/33] ALSA: usb-audio: fix possible hang and overflow in parse_uac2_sample_rate_range()
Date: Wed,  5 Jun 2013 13:53:08 -0700
Message-Id: <20130605204709.354630751@linuxfoundation.org>
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

commit 4fa0e81b83503900be277e6273a79651b375e288 upstream.

A malicious USB device may feed in carefully crafted min/max/res values,
so that the inner loop in parse_uac2_sample_rate_range() could run for
a long time or even never terminate, e.g., given max = INT_MAX.

Also nr_rates could be a large integer, which causes an integer overflow
in the subsequent call to kmalloc() in parse_audio_format_rates_v2().
Thus, kmalloc() would allocate a smaller buffer than expected, leading
to a memory corruption.

To exploit the two vulnerabilities, an attacker needs physical access
to the machine to plug in a malicious USB device.

This patch makes two changes.

1) The type of "rate" is changed to unsigned int, so that the loop could
   stop once "rate" is larger than INT_MAX.

2) Limit nr_rates to 1024.

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/format.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -209,6 +209,8 @@ static int parse_audio_format_rates_v1(s
 	return 0;
 }
 
+#define MAX_UAC2_NR_RATES 1024
+
 /*
  * Helper function to walk the array of sample rate triplets reported by
  * the device. The problem is that we need to parse whole array first to
@@ -226,7 +228,7 @@ static int parse_uac2_sample_rate_range(
 		int min = combine_quad(&data[2 + 12 * i]);
 		int max = combine_quad(&data[6 + 12 * i]);
 		int res = combine_quad(&data[10 + 12 * i]);
-		int rate;
+		unsigned int rate;
 
 		if ((max < 0) || (min < 0) || (res < 0) || (max < min))
 			continue;
@@ -253,6 +255,10 @@ static int parse_uac2_sample_rate_range(
 			fp->rates |= snd_pcm_rate_to_rate_bit(rate);
 
 			nr_rates++;
+			if (nr_rates >= MAX_UAC2_NR_RATES) {
+				snd_printk(KERN_ERR "invalid uac2 rates\n");
+				break;
+			}
 
 			/* avoid endless loop */
 			if (res == 0)


