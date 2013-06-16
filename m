Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3FPWb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:31:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46288 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab3FPWIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:43 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Xi Wang" <xi.wang@gmail.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.12456539@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [13/83] ALSA: usb-audio: fix possible hang and overflow in
 parse_uac2_sample_rate_range()
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/format.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index 89421d1..e09aba1 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -209,6 +209,8 @@ static int parse_audio_format_rates_v1(struct snd_usb_audio *chip, struct audiof
 	return 0;
 }
 
+#define MAX_UAC2_NR_RATES 1024
+
 /*
  * Helper function to walk the array of sample rate triplets reported by
  * the device. The problem is that we need to parse whole array first to
@@ -226,7 +228,7 @@ static int parse_uac2_sample_rate_range(struct audioformat *fp, int nr_triplets,
 		int min = combine_quad(&data[2 + 12 * i]);
 		int max = combine_quad(&data[6 + 12 * i]);
 		int res = combine_quad(&data[10 + 12 * i]);
-		int rate;
+		unsigned int rate;
 
 		if ((max < 0) || (min < 0) || (res < 0) || (max < min))
 			continue;
@@ -253,6 +255,10 @@ static int parse_uac2_sample_rate_range(struct audioformat *fp, int nr_triplets,
 			fp->rates |= snd_pcm_rate_to_rate_bit(rate);
 
 			nr_rates++;
+			if (nr_rates >= MAX_UAC2_NR_RATES) {
+				snd_printk(KERN_ERR "invalid uac2 rates\n");
+				break;
+			}
 
 			/* avoid endless loop */
 			if (res == 0)

