Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbaIKMr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:47:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51614 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "NeilBrown" <neilb@suse.de>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Manibalan P" <pmanibalan@amiindia.co.in>,
        "Yuri Tikhonov" <yur@emcraft.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.547378807@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 069/131] md/raid6: avoid data corruption during
 recovery of double-degraded RAID6
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid5.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3240,6 +3240,8 @@ static void handle_stripe(struct stripe_
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
 					continue;
+				if (s.failed > 1)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    ((i == sh->pd_idx || i == sh->qd_idx)  &&
 				     s.failed == 0))

