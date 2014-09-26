Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbaIZKNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:13:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbaIZJqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Yuri Tikhonov <yur@emcraft.com>,
        Dan Williams <dan.j.williams@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 094/142] md/raid6: avoid data corruption during recovery of double-degraded RAID6
Date: Fri, 26 Sep 2014 11:45:05 +0200
Message-Id: <edb42d7292c2fe60a01163e15193e1657bdd2a10.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/raid5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3ecfb063ec0b..42510e40c23c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3672,6 +3672,8 @@ static void handle_stripe(struct stripe_head *sh)
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
 					continue;
+				if (s.failed > 1)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    ((i == sh->pd_idx || i == sh->qd_idx)  &&
 				     s.failed == 0))
-- 
2.1.0

