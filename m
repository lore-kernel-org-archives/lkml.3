Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaIWCfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:35:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:37635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaIWCfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:35:41 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Yuri Tikhonov <yur@emcraft.com>,
        Dan Williams <dan.j.williams@intel.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 11/45] md/raid6: avoid data corruption during recovery of double-degraded RAID6
Date: Tue, 23 Sep 2014 10:31:13 +0800
Message-Id: <1411439507-30391-11-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 9c4bdf697c39805078392d5ddbbba5ae5680e0dd upstream.

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

Fixes: 6c0069c0ae9659e3a91b68eaed06a5c6c37f45c8
Cc: Yuri Tikhonov <yur@emcraft.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: "Manibalan P" <pmanibalan@amiindia.co.in>
Tested-by: "Manibalan P" <pmanibalan@amiindia.co.in>
Resolves: https://bugzilla.redhat.com/show_bug.cgi?id=1090423
Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/md/raid5.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 17b918d..c276ad0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3433,6 +3433,8 @@ static void handle_stripe(struct stripe_head *sh)
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
 					continue;
+				if (s.failed > 1)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    ((i == sh->pd_idx || i == sh->qd_idx)  &&
 				     s.failed == 0))
-- 
1.7.9.5

