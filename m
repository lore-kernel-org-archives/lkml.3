Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaDRMq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:46:59 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:45782 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753350AbaDRMqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:46:54 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29445278"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 1/8] idr: fix overflow bug for the max-high layer
Date: Fri, 18 Apr 2014 20:49:48 +0800
Message-ID: <1397825404-12039-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In idr_replace(), when the top layer is the max-high layer(p->layer == 3),
The "(1 << n)" will overflow and the result is 0, it causes idr_replace()
return -EINVAL even the id is actually valid.

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

Fixed the bug by using idr_max() instead of the incorrect open code.

There is the same problem in sub_alloc(). The overflow causes sub_alloc()
returns -EAGAIN unexpectedly. But the idr_get_empty_slot() will call it
again with increased @id. So the bug is hided.

CC: stable@vger.kernel.org
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
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

