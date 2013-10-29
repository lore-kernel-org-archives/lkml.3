Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3J2SSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:18:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab3J2SJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fengguang Wu <fengguang.wu@intel.com>, Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 80/81] writeback: fix negative bdi max pause
Date: Tue, 29 Oct 2013 11:04:41 -0700
Message-Id: <1383069882-11437-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fengguang Wu <fengguang.wu@intel.com>

commit e3b6c655b91e01a1dade056cfa358581b47a5351 upstream.

Toralf runs trinity on UML/i386.  After some time it hangs and the last
message line is

	BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:1521]

It's found that pages_dirtied becomes very large.  More than 1000000000
pages in this case:

	period = HZ * pages_dirtied / task_ratelimit;
	BUG_ON(pages_dirtied > 2000000000);
	BUG_ON(pages_dirtied > 1000000000);      <---------

UML debug printf shows that we got negative pause here:

	ick: pause : -984
	ick: pages_dirtied : 0
	ick: task_ratelimit: 0

	 pause:
	+       if (pause < 0)  {
	+               extern int printf(char *, ...);
	+               printf("ick : pause : %li\n", pause);
	+               printf("ick: pages_dirtied : %lu\n", pages_dirtied);
	+               printf("ick: task_ratelimit: %lu\n", task_ratelimit);
	+               BUG_ON(1);
	+       }
	        trace_balance_dirty_pages(bdi,

Since pause is bounded by [min_pause, max_pause] where min_pause is also
bounded by max_pause.  It's suspected and demonstrated that the
max_pause calculation goes wrong:

	ick: pause : -717
	ick: min_pause : -177
	ick: max_pause : -717
	ick: pages_dirtied : 14
	ick: task_ratelimit: 0

The problem lies in the two "long = unsigned long" assignments in
bdi_max_pause() which might go negative if the highest bit is 1, and the
min_t(long, ...) check failed to protect it falling under 0.  Fix all of
them by using "unsigned long" throughout the function.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Richard Weinberger <richard@nod.at>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/page-writeback.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0713bfb..906d540 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1100,11 +1100,11 @@ static unsigned long dirty_poll_interval(unsigned long dirty,
 	return 1;
 }
 
-static long bdi_max_pause(struct backing_dev_info *bdi,
-			  unsigned long bdi_dirty)
+static unsigned long bdi_max_pause(struct backing_dev_info *bdi,
+				   unsigned long bdi_dirty)
 {
-	long bw = bdi->avg_write_bandwidth;
-	long t;
+	unsigned long bw = bdi->avg_write_bandwidth;
+	unsigned long t;
 
 	/*
 	 * Limit pause time for small memory systems. If sleeping for too long
@@ -1116,7 +1116,7 @@ static long bdi_max_pause(struct backing_dev_info *bdi,
 	t = bdi_dirty / (1 + bw / roundup_pow_of_two(1 + HZ / 8));
 	t++;
 
-	return min_t(long, t, MAX_PAUSE);
+	return min_t(unsigned long, t, MAX_PAUSE);
 }
 
 static long bdi_min_pause(struct backing_dev_info *bdi,
-- 
1.8.1.2

