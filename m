Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaEZLpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:45:19 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:48120 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaEZLpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:45:17 -0400
X-Nat-Received: from [202.181.97.72]:24791 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1401104713.5618
To: Motohiro.Kosaki@us.fujitsu.com, david@fromorbit.com, riel@redhat.com
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        hch@infradead.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] mm/vmscan: Do not block forever atshrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140520004449.GE18954@dastard>
	<20140519225915.3370328d.akpm@linux-foundation.org>
	<20140520063024.GH18954@dastard>
	<201405202358.ADF10119.SMOFOQLFtOVHJF@I-love.SAKURA.ne.jp>
	<6B2BA408B38BA1478B473C31C3D2074E31D59D8673@SV-EXCHANGE1.Corp.FC.LOCAL>
In-Reply-To: <6B2BA408B38BA1478B473C31C3D2074E31D59D8673@SV-EXCHANGE1.Corp.FC.LOCAL>
Message-Id: <201405262045.CDG95893.HLFFOSFMQOVOJt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 26 May 2014 20:45:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 26052014 #8026966, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Dave, if you are OK with this updated patch, please let me know commit ID of your patch.

I overlooked that too_many_isolated() in mm/vmscan.c already has

  if (current_is_kswapd())
    return 0;

lines. Therefore, it turned out that my patch is irrelevant to XFS issue.
Does patch shown below make sense?

Regards.
----------
>From e133aadd65df3d8622efced3443888ed3e60327b Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 26 May 2014 20:37:12 +0900
Subject: [PATCH] mm/vmscan: Do not throttle when hibernation_mode != 0.

In shrink_inactive_list(), we do not insert delay at

  if (!sc->hibernation_mode && !current_is_kswapd())
    wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);

if sc->hibernation_mode != 0.
Follow the same reason, we should not insert delay at

  while (unlikely(too_many_isolated(zone, file, sc))) {
    congestion_wait(BLK_RW_ASYNC, HZ/10);

    /* We are about to die and free our memory. Return now. */
    if (fatal_signal_pending(current))
      return SWAP_CLUSTER_MAX;
  }

if sc->hibernation_mode != 0.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 mm/vmscan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 32c661d..89c42ca 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1362,6 +1362,9 @@ static int too_many_isolated(struct zone *zone, int file,
 	if (current_is_kswapd())
 		return 0;
 
+	if (sc->hibernation_mode)
+		return 0;
+
 	if (!global_reclaim(sc))
 		return 0;
 
-- 
1.7.1
