Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbaIOTgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:36:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbaIOTgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yuri Tikhonov <yur@emcraft.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Manibalan P" <pmanibalan@amiindia.co.in>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.16 127/158] md/raid6: avoid data corruption during recovery of double-degraded RAID6
Date: Mon, 15 Sep 2014 12:26:06 -0700
Message-Id: <20140915192546.695280830@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3817,6 +3817,8 @@ static void handle_stripe(struct stripe_
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
 					continue;
+				if (s.failed > 1)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    ((i == sh->pd_idx || i == sh->qd_idx)  &&
 				     s.failed == 0))


