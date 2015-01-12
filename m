Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbbALQT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:19:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57595 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbALQT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:19:27 -0500
From: Chintan Pandya <cpandya@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        David Rientjes <rientjes@google.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        Chintan Pandya <cpandya@codeaurora.org>
Subject: [PATCH] lowmemorykiller: Avoid excessive/redundant calling of LMK
Date: Mon, 12 Jan 2015 21:49:14 +0530
Message-Id: <1421079554-30899-1-git-send-email-cpandya@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global shrinker will invoke lowmem_shrink in a loop.
The loop will be run (total_scan_pages/batch_size) times.
The default batch_size will be 128 which will make
shrinker invoking 100s of times. LMK does meaningful
work only during first 2-3 times and then rest of the
invocations are just CPU cycle waste. Fix that by returning
to the shrinker with SHRINK_STOP when LMK doesn't find any
more work to do. The deciding factor here is, no process
found in the selected LMK bucket or memory conditions are
sane.

Signed-off-by: Chintan Pandya <cpandya@codeaurora.org>
---
 drivers/staging/android/lowmemorykiller.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index b545d3d..5bf483f 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -110,7 +110,7 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
 	if (min_score_adj == OOM_SCORE_ADJ_MAX + 1) {
 		lowmem_print(5, "lowmem_scan %lu, %x, return 0\n",
 			     sc->nr_to_scan, sc->gfp_mask);
-		return 0;
+		return SHRINK_STOP;
 	}
 
 	selected_oom_score_adj = min_score_adj;
@@ -163,6 +163,9 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
 		set_tsk_thread_flag(selected, TIF_MEMDIE);
 		send_sig(SIGKILL, selected, 0);
 		rem += selected_tasksize;
+	} else {
+		rcu_read_unlock();
+		return SHRINK_STOP;
 	}
 
 	lowmem_print(4, "lowmem_scan %lu, %x, return %lu\n",
-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

