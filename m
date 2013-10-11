Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3JKI5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:57:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:56379 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383Ab3JKI50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1079,1371106800"; 
   d="scan'208";a="409317802"
Date: Fri, 11 Oct 2013 16:57:01 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        hannes@cmpxchg.org, darrick.wong@oracle.com,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [uml-devel] BUG: soft lockup for a user mode linux image
Message-ID: <20131011085701.GA27382@localhost>
References: <CAMuHMdUo8dSd4s3089ZDEc485wL1sFxBKLeaExJuqNiQY+S-Lw@mail.gmail.com>
 <5251CF94.5040101@gmx.de>
 <CAMuHMdWs6Y7y12STJ+YXKJjxRF0k5yU9C9+0fiPPmq-GgeW-6Q@mail.gmail.com>
 <525591AD.4060401@gmx.de>
 <5255A3E6.6020100@nod.at>
 <20131009214733.GB25608@quack.suse.cz>
 <5255D9A6.3010208@nod.at>
 <5256DA9A.5060904@gmx.de>
 <20131011011649.GA11191@localhost>
 <5257B9EB.7080503@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5257B9EB.7080503@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 10:42:19AM +0200, Toralf Förster wrote:
> yeah, now the picture becomes more clear
> ...
> net.core.warnings = 0                                                                         [ ok ]
> ick: pause : -717
>                  ick : min_pause : -177
>                                    ick : max_pause : -717
>                                                      ick: pages_dirtied : 14
>                                                                             ick: task_ratelimit: 0

Great and thanks! So it's the max pause calculation went wrong.
Would help you try the below patch?

>From 5420b9bbe42dd0a366d7615e9f3d3724cee725c4 Mon Sep 17 00:00:00 2001
From: Fengguang Wu <fengguang.wu@intel.com>
Date: Fri, 11 Oct 2013 16:53:26 +0800
Subject: [PATCH] fix bdi max pause calculation

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3f0c895..241a746 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1104,11 +1104,11 @@ static unsigned long dirty_poll_interval(unsigned long dirty,
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
@@ -1120,7 +1120,7 @@ static long bdi_max_pause(struct backing_dev_info *bdi,
 	t = bdi_dirty / (1 + bw / roundup_pow_of_two(1 + HZ / 8));
 	t++;
 
-	return min_t(long, t, MAX_PAUSE);
+	return min_t(unsigned long, t, MAX_PAUSE);
 }
 
 static long bdi_min_pause(struct backing_dev_info *bdi,
-- 
1.7.10.4

