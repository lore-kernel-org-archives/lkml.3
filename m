Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaDVGVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:21:37 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:18477 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751354AbaDVGUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:20:16 -0400
X-IronPort-AV: E=Sophos;i="4.97,899,1389715200"; 
   d="scan'208";a="29554475"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, <stable@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 1/7 V3] idr: fix overflow bug during maximum ID calculation at maximum height
Date: Tue, 22 Apr 2014 14:23:23 +0800
Message-ID: <1398147810-26414-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398147810-26414-1-git-send-email-laijs@cn.fujitsu.com>
References: <20140421152345.4d67a6563ebd89f0b969332f@linux-foundation.org>
 <1398147810-26414-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_replace() open-codes the logic to calculate the maximum valid ID
given the height of the idr tree; unfortunately, the open-coded logic
doesn't account for the fact that the top layer may have unused slots
and over-shifts the limit to zero when the tree is at its maximum
height.

The following test code shows it fails to replace the value for id=((1<<27)+42):

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

tj: Updated patch description.

CC: stable@vger.kernel.org
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 lib/idr.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 2642fa8..4df6792 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -249,7 +249,7 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa,
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
 			/* if already at the top layer, we need to grow */
-			if (id >= 1 << (idp->layers * IDR_BITS)) {
+			if (id > idr_max(idp->layers)) {
 				*starting_id = id;
 				return -EAGAIN;
 			}
@@ -811,12 +811,10 @@ void *idr_replace(struct idr *idp, void *ptr, int id)
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
1.7.4.4

