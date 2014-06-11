Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaFLAB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:01:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:36012 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFKX7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:17 -0400
Message-Id: <20140611234607.185637293@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 06/13] sound: intel8x0: Use ktime and ktime_get()
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=sound-intel8x0-use-ktime.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts() and returns
the monotonic time in a timespec.

Use ktime based ktime_get() and use the ktime_delta_us() function to
calculate the delta instead of open coding the timespec math.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/intel8x0.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux/sound/pci/intel8x0.c
===================================================================
--- linux.orig/sound/pci/intel8x0.c
+++ linux/sound/pci/intel8x0.c
@@ -2779,7 +2779,7 @@ static void intel8x0_measure_ac97_clock(
 	unsigned long port;
 	unsigned long pos, pos1, t;
 	int civ, timeout = 1000, attempt = 1;
-	struct timespec start_time, stop_time;
+	ktime_t start_time, stop_time;
 
 	if (chip->ac97_bus->clock != 48000)
 		return; /* specified in module option */
@@ -2813,7 +2813,7 @@ static void intel8x0_measure_ac97_clock(
 		iputbyte(chip, port + ICH_REG_OFF_CR, ICH_IOCE);
 		iputdword(chip, ICHREG(ALI_DMACR), 1 << ichdev->ali_slot);
 	}
-	do_posix_clock_monotonic_gettime(&start_time);
+	start_time = ktime_get();
 	spin_unlock_irq(&chip->reg_lock);
 	msleep(50);
 	spin_lock_irq(&chip->reg_lock);
@@ -2837,7 +2837,7 @@ static void intel8x0_measure_ac97_clock(
 		pos += ichdev->position;
 	}
 	chip->in_measurement = 0;
-	do_posix_clock_monotonic_gettime(&stop_time);
+	stop_time = ktime_get();
 	/* stop */
 	if (chip->device_type == DEVICE_ALI) {
 		iputdword(chip, ICHREG(ALI_DMACR), 1 << (ichdev->ali_slot + 16));
@@ -2865,9 +2865,7 @@ static void intel8x0_measure_ac97_clock(
 	}
 
 	pos /= 4;
-	t = stop_time.tv_sec - start_time.tv_sec;
-	t *= 1000000;
-	t += (stop_time.tv_nsec - start_time.tv_nsec) / 1000;
+	t = ktime_us_delta(stop_time, start_time);
 	dev_info(chip->card->dev,
 		 "%s: measured %lu usecs (%lu samples)\n", __func__, t, pos);
 	if (t == 0) {


