Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908AbaF3Mb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:31:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964882AbaF3Mbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:52 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 121/181] idr: fix overflow bug during maximum ID calculation at maximum height
Date: Mon, 30 Jun 2014 13:52:22 +0200
Message-Id: <630f083a4e43aa1c49d7f12b2535fd7a77e0f816.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3afb69cb5572b3c8c898c00880803cf1a49852c4 upstream.

idr_replace() open-codes the logic to calculate the maximum valid ID
given the height of the idr tree; unfortunately, the open-coded logic
doesn't account for the fact that the top layer may have unused slots
and over-shifts the limit to zero when the tree is at its maximum
height.

The following test code shows it fails to replace the value for
id=((1<<27)+42):

  static void test5(void)
  {
        int id;
        DEFINE_IDR(test_idr);
  #define TEST5_START ((1<<27)+42) /* use the highest layer */

        printk(KERN_INFO "Start test5\n");
        id = idr_alloc(&test_idr, (void *)1, TEST5_START, 0, GFP_KERNEL);
        BUG_ON(id != TEST5_START);
        TEST_BUG_ON(idr_replace(&test_idr, (void *)2, TEST5_START) != (void *)1);
        idr_destroy(&test_idr);
        printk(KERN_INFO "End of test5\n");
  }

Fix the bug by using idr_max() which correctly takes into account the
maximum allowed shift.

sub_alloc() shares the same problem and may incorrectly fail with
-EAGAIN; however, this bug doesn't affect correct operation because
idr_get_empty_slot(), which already uses idr_max(), retries with the
increased @id in such cases.

[tj@kernel.org: Updated patch description.]
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 lib/idr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index bfe4db4e165f..674c30bc2ed0 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -250,7 +250,7 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa,
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
 			/* if already at the top layer, we need to grow */
-			if (id >= 1 << (idp->layers * IDR_BITS)) {
+			if (id > idr_max(idp->layers)) {
 				*starting_id = id;
 				return -EAGAIN;
 			}
@@ -827,12 +827,10 @@ void *idr_replace(struct idr *idp, void *ptr, int id)
 	if (!p)
 		return ERR_PTR(-EINVAL);
 
-	n = (p->layer+1) * IDR_BITS;
-
-	if (id >= (1 << n))
+	if (id > idr_max(p->layer + 1))
 		return ERR_PTR(-EINVAL);
 
-	n -= IDR_BITS;
+	n = p->layer * IDR_BITS;
 	while ((n > 0) && p) {
 		p = p->ary[(id >> n) & IDR_MASK];
 		n -= IDR_BITS;
-- 
2.0.0

