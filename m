Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaJ2RsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:48:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45174 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbaJ2RsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:48:14 -0400
Date: Wed, 29 Oct 2014 10:48:10 -0700
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: tiwai@suse.de, arnd@arndb.de
Cc: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: es1968: Replace timeval with ktime_t
Message-ID: <20141029174810.GA48058@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

es1968_measure_clock uses struct timeval, which on 32-bit systems will overflow
in 2038, leading to incorrect interpretation of time.This patch changes the
function to use ktime_t instead of struct timeval, which implies:
- no y2038: ktime_t uses a 64-bit datatype explicitly.
- efficent subtraction: The earlier version computes the difference in usecs
  while dealing with secs and nsecs. It requires checks to see if the nsecs of
  stop is less than start. This patch uses a direct subtract of ktime_t and
  converts to usecs.
- use of monotonic clock (ktime_get) over real time (do_gettimeofday),
  which simplifies timekeeping, as it does not have to deal with cases
  where stop_time is less than start_time.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 sound/pci/es1968.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index a9956a7..6039700 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -1710,7 +1710,8 @@ static void es1968_measure_clock(struct es1968 *chip)
 	int i, apu;
 	unsigned int pa, offset, t;
 	struct esm_memory *memory;
-	struct timeval start_time, stop_time;
+	ktime_t start_time, stop_time;
+	ktime_t diff;
 
 	if (chip->clock == 0)
 		chip->clock = 48000; /* default clock value */
@@ -1761,12 +1762,12 @@ static void es1968_measure_clock(struct es1968 *chip)
 	snd_es1968_bob_inc(chip, ESM_BOB_FREQ);
 	__apu_set_register(chip, apu, 5, pa & 0xffff);
 	snd_es1968_trigger_apu(chip, apu, ESM_APU_16BITLINEAR);
-	do_gettimeofday(&start_time);
+	start_time = ktime_get();
 	spin_unlock_irq(&chip->reg_lock);
 	msleep(50);
 	spin_lock_irq(&chip->reg_lock);
 	offset = __apu_get_register(chip, apu, 5);
-	do_gettimeofday(&stop_time);
+	stop_time = ktime_get();
 	snd_es1968_trigger_apu(chip, apu, 0); /* stop */
 	snd_es1968_bob_dec(chip);
 	chip->in_measurement = 0;
@@ -1777,12 +1778,8 @@ static void es1968_measure_clock(struct es1968 *chip)
 	offset &= 0xfffe;
 	offset += chip->measure_count * (CLOCK_MEASURE_BUFSIZE/2);
 
-	t = stop_time.tv_sec - start_time.tv_sec;
-	t *= 1000000;
-	if (stop_time.tv_usec < start_time.tv_usec)
-		t -= start_time.tv_usec - stop_time.tv_usec;
-	else
-		t += stop_time.tv_usec - start_time.tv_usec;
+	diff = ktime_sub(stop_time, start_time);
+	t = ktime_to_us(diff);
 	if (t == 0) {
 		dev_err(chip->card->dev, "?? calculation error..\n");
 	} else {
-- 
2.1.0.rc2.206.gedb03e5

