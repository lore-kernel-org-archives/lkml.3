Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbaGOVc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:32:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054AbaGOVcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:32:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 108/198] idr: fix overflow bug during maximum ID calculation at maximum height
Date: Tue, 15 Jul 2014 14:29:38 -0700
Message-Id: <1405459868-15089-109-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 lib/idr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index bfe4db4..674c30b 100644
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
1.9.1

