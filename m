Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682AbaJ3SE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:04:58 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:60135 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaJ3SE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:04:56 -0400
Date: Thu, 30 Oct 2014 11:04:53 -0700
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, opw-kernel@googlegroups.com, rjw@rjwysocki.net
Subject: [PATCH] PM / Hibernate: Migrate to ktime_t
Message-ID: <20141030180453.GA55907@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch migrates swsusp_show_speed and its callers to using ktime_t instead
of 'struct timeval' which suffers from the y2038 problem.

Changes to swsusp_show_speed:
        - use ktime_t for start and stop times
        - pass start and stop times by value
Calling functions affected:
        - load_image
        - load_image_lzo
        - save_image
        - save_image_lzo
        - hibernate_preallocate_memory
Design decisions:
        - use ktime_t to preserve same granularity of reporting as before
        - use centisecs logic as before to avoid 'div by zero' issues caused by
          using seconds and nanoseconds directly
        - use monotonic time (ktime_get()) since we only care about elapsed time.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>

--
Changes in v4:
 - Rebased patch off of 3.18-rc1
Changes in v3:
 - Use monotonic clock (ktime_get())
   instead of ktime_get_real()
 - Fix incorrect denominator in ktime_divns
Changes in v2:
 - Incorporate whitespace fixes suggested by
   Arnd Bergmann <arnd@arndb.de>
 - Use ktime_divns instead of ktime_to_ns and
   then do_div to get centisecs
 - Explain reason for changing elapsed_centisecs
   to u64.
---
 kernel/power/hibernate.c | 14 ++++++--------
 kernel/power/power.h     |  3 +--
 kernel/power/snapshot.c  |  9 +++++----
 kernel/power/swap.c      | 41 +++++++++++++++++++++--------------------
 4 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a9dfa79..6e6cb96 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -28,6 +28,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
+#include <linux/ktime.h>
 #include <trace/events/power.h>
 
 #include "power.h"
@@ -232,20 +233,17 @@ static void platform_recover(int platform_mode)
  * @nr_pages: Number of memory pages processed between @start and @stop.
  * @msg: Additional diagnostic message to print.
  */
-void swsusp_show_speed(struct timeval *start, struct timeval *stop,
-			unsigned nr_pages, char *msg)
+void swsusp_show_speed(ktime_t start, ktime_t stop,
+		      unsigned nr_pages, char *msg)
 {
+	ktime_t diff;
 	u64 elapsed_centisecs64;
 	unsigned int centisecs;
 	unsigned int k;
 	unsigned int kps;
 
-	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
-	/*
-	 * If "(s64)elapsed_centisecs64 < 0", it will print long elapsed time,
-	 * it is obvious enough for what went wrong.
-	 */
-	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
+	diff = ktime_sub(stop, start);
+	elapsed_centisecs64 = ktime_divns(diff, 10*NSEC_PER_MSEC);
 	centisecs = elapsed_centisecs64;
 	if (centisecs == 0)
 		centisecs = 1;	/* avoid div-by-zero */
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 2df883a..ce9b832 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -174,8 +174,7 @@ extern int hib_wait_on_bio_chain(struct bio **bio_chain);
 
 struct timeval;
 /* kernel/power/swsusp.c */
-extern void swsusp_show_speed(struct timeval *, struct timeval *,
-				unsigned int, char *);
+extern void swsusp_show_speed(ktime_t, ktime_t, unsigned int, char *);
 
 #ifdef CONFIG_SUSPEND
 /* kernel/power/suspend.c */
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 791a618..0c40c16 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -28,6 +28,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/compiler.h>
+#include <linux/ktime.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1576,11 +1577,11 @@ int hibernate_preallocate_memory(void)
 	struct zone *zone;
 	unsigned long saveable, size, max_size, count, highmem, pages = 0;
 	unsigned long alloc, save_highmem, pages_highmem, avail_normal;
-	struct timeval start, stop;
+	ktime_t start, stop;
 	int error;
 
 	printk(KERN_INFO "PM: Preallocating image memory... ");
-	do_gettimeofday(&start);
+	start = ktime_get();
 
 	error = memory_bm_create(&orig_bm, GFP_IMAGE, PG_ANY);
 	if (error)
@@ -1709,9 +1710,9 @@ int hibernate_preallocate_memory(void)
 	free_unnecessary_pages();
 
  out:
-	do_gettimeofday(&stop);
+	stop = ktime_get();
 	printk(KERN_CONT "done (allocated %lu pages)\n", pages);
-	swsusp_show_speed(&start, &stop, pages, "Allocated");
+	swsusp_show_speed(start, stop, pages, "Allocated");
 
 	return 0;
 
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index aaa3261..2c9d6d5 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -30,6 +30,7 @@
 #include <linux/atomic.h>
 #include <linux/kthread.h>
 #include <linux/crc32.h>
+#include <linux/ktime.h>
 
 #include "power.h"
 
@@ -445,8 +446,8 @@ static int save_image(struct swap_map_handle *handle,
 	int nr_pages;
 	int err2;
 	struct bio *bio;
-	struct timeval start;
-	struct timeval stop;
+	ktime_t start;
+	ktime_t stop;
 
 	printk(KERN_INFO "PM: Saving image data pages (%u pages)...\n",
 		nr_to_write);
@@ -455,7 +456,7 @@ static int save_image(struct swap_map_handle *handle,
 		m = 1;
 	nr_pages = 0;
 	bio = NULL;
-	do_gettimeofday(&start);
+	start = ktime_get();
 	while (1) {
 		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
@@ -469,12 +470,12 @@ static int save_image(struct swap_map_handle *handle,
 		nr_pages++;
 	}
 	err2 = hib_wait_on_bio_chain(&bio);
-	do_gettimeofday(&stop);
+	stop = ktime_get();
 	if (!ret)
 		ret = err2;
 	if (!ret)
 		printk(KERN_INFO "PM: Image saving done.\n");
-	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
+	swsusp_show_speed(start, stop, nr_to_write, "Wrote");
 	return ret;
 }
 
@@ -580,8 +581,8 @@ static int save_image_lzo(struct swap_map_handle *handle,
 	int nr_pages;
 	int err2;
 	struct bio *bio;
-	struct timeval start;
-	struct timeval stop;
+	ktime_t start;
+	ktime_t stop;
 	size_t off;
 	unsigned thr, run_threads, nr_threads;
 	unsigned char *page = NULL;
@@ -674,7 +675,7 @@ static int save_image_lzo(struct swap_map_handle *handle,
 		m = 1;
 	nr_pages = 0;
 	bio = NULL;
-	do_gettimeofday(&start);
+	start = ktime_get();
 	for (;;) {
 		for (thr = 0; thr < nr_threads; thr++) {
 			for (off = 0; off < LZO_UNC_SIZE; off += PAGE_SIZE) {
@@ -759,12 +760,12 @@ static int save_image_lzo(struct swap_map_handle *handle,
 
 out_finish:
 	err2 = hib_wait_on_bio_chain(&bio);
-	do_gettimeofday(&stop);
+	stop = ktime_get();
 	if (!ret)
 		ret = err2;
 	if (!ret)
 		printk(KERN_INFO "PM: Image saving done.\n");
-	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
+	swsusp_show_speed(start, stop, nr_to_write, "Wrote");
 out_clean:
 	if (crc) {
 		if (crc->thr)
@@ -965,8 +966,8 @@ static int load_image(struct swap_map_handle *handle,
 {
 	unsigned int m;
 	int ret = 0;
-	struct timeval start;
-	struct timeval stop;
+	ktime_t start;
+	ktime_t stop;
 	struct bio *bio;
 	int err2;
 	unsigned nr_pages;
@@ -978,7 +979,7 @@ static int load_image(struct swap_map_handle *handle,
 		m = 1;
 	nr_pages = 0;
 	bio = NULL;
-	do_gettimeofday(&start);
+	start = ktime_get();
 	for ( ; ; ) {
 		ret = snapshot_write_next(snapshot);
 		if (ret <= 0)
@@ -996,7 +997,7 @@ static int load_image(struct swap_map_handle *handle,
 		nr_pages++;
 	}
 	err2 = hib_wait_on_bio_chain(&bio);
-	do_gettimeofday(&stop);
+	stop = ktime_get();
 	if (!ret)
 		ret = err2;
 	if (!ret) {
@@ -1005,7 +1006,7 @@ static int load_image(struct swap_map_handle *handle,
 		if (!snapshot_image_loaded(snapshot))
 			ret = -ENODATA;
 	}
-	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
+	swsusp_show_speed(start, stop, nr_to_read, "Read");
 	return ret;
 }
 
@@ -1067,8 +1068,8 @@ static int load_image_lzo(struct swap_map_handle *handle,
 	int ret = 0;
 	int eof = 0;
 	struct bio *bio;
-	struct timeval start;
-	struct timeval stop;
+	ktime_t start;
+	ktime_t stop;
 	unsigned nr_pages;
 	size_t off;
 	unsigned i, thr, run_threads, nr_threads;
@@ -1190,7 +1191,7 @@ static int load_image_lzo(struct swap_map_handle *handle,
 		m = 1;
 	nr_pages = 0;
 	bio = NULL;
-	do_gettimeofday(&start);
+	start = ktime_get();
 
 	ret = snapshot_write_next(snapshot);
 	if (ret <= 0)
@@ -1343,7 +1344,7 @@ out_finish:
 		wait_event(crc->done, atomic_read(&crc->stop));
 		atomic_set(&crc->stop, 0);
 	}
-	do_gettimeofday(&stop);
+	stop = ktime_get();
 	if (!ret) {
 		printk(KERN_INFO "PM: Image loading done.\n");
 		snapshot_write_finalize(snapshot);
@@ -1359,7 +1360,7 @@ out_finish:
 			}
 		}
 	}
-	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
+	swsusp_show_speed(start, stop, nr_to_read, "Read");
 out_clean:
 	for (i = 0; i < ring_size; i++)
 		free_page((unsigned long)page[i]);
-- 
2.1.0.rc2.206.gedb03e5

