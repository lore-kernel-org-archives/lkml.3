Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaKPWLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:11:30 -0500
Received: from 1wt.eu ([62.212.114.60]:47919 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaKPWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:48 -0500
Message-Id: <20141116215330.266056864@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:54:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yuri Tikhonov <yur@emcraft.com>, Dan Williams <dan.j.williams@intel.com>,
        NeilBrown <neilb@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [ 39/48] md/raid6: avoid data corruption during recovery of
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 double-degraded RAID6

From: NeilBrown <neilb@suse.de>

During recovery of a double-degraded RAID6 it is possible for
some blocks not to be recovered properly, leading to corruption.

If a write happens to one block in a stripe that would be written to a
missing device, and at the same time that stripe is recovering data
to the other missing device, then that recovered data may not be written.

This patch skips, in the double-degraded case, an optimisation that is
only safe for single-degraded arrays.

Bug was introduced in 2.6.32 and fix is suitable for any kernel since
then.  In an older kernel with separate handle_stripe5() and
handle_stripe6() functions the patch must change handle_stripe6().

Cc: stable@vger.kernel.org (2.6.32+)
Fixes: 6c0069c0ae9659e3a91b68eaed06a5c6c37f45c8
Cc: Yuri Tikhonov <yur@emcraft.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: "Manibalan P" <pmanibalan@amiindia.co.in>
Tested-by: "Manibalan P" <pmanibalan@amiindia.co.in>
Resolves: https://bugzilla.redhat.com/show_bug.cgi?id=1090423
Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Dan Williams <dan.j.williams@intel.com>
(cherry picked from commit 9c4bdf697c39805078392d5ddbbba5ae5680e0dd)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/md/raid5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 883215d..013e598 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3091,6 +3091,8 @@ static void handle_stripe5(struct stripe_head *sh)
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
 					continue;
+				if (s.failed > 1)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    (i == sh->pd_idx && s.failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);
-- 
1.7.12.2.21.g234cd45.dirty



