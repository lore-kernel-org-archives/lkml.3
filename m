Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaDVGVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:21:41 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:13030 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751738AbaDVGUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:20:16 -0400
X-IronPort-AV: E=Sophos;i="4.97,899,1389715200"; 
   d="scan'208";a="29554480"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 2/7 V3] idr: fix unexpected ID-removal when idr_remove(unallocated_id)
Date: Tue, 22 Apr 2014 14:23:24 +0800
Message-ID: <1398147810-26414-3-git-send-email-laijs@cn.fujitsu.com>
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

If unallocated_id = (ANY * idr_max(idp->layers) + existing_id) is passed
to idr_remove(). The existing_id will be removed unexpectedly.

The following test shows this unexpected id-removal:

static void test4(void)
{
	int id;
	DEFINE_IDR(test_idr);

	printk(KERN_INFO "Start test4\n");
	id = idr_alloc(&test_idr, (void *)1, 42, 43, GFP_KERNEL);
	BUG_ON(id != 42);
	idr_remove(&test_idr, 42 + IDR_SIZE);
	TEST_BUG_ON(idr_find(&test_idr, 42) != (void *)1);
	idr_destroy(&test_idr);
	printk(KERN_INFO "End of test4\n");
}

ida_remove() shares the similar problem.

It happens only when the caller tries to free an unallocated ID which
is the caller's fault. It is not a bug. But it is better to add
the proper check and complain rather than removing an existing_id silently.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 lib/idr.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 4df6792..c4afd94 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -562,6 +562,11 @@ void idr_remove(struct idr *idp, int id)
 	if (id < 0)
 		return;
 
+	if (id > idr_max(idp->layers)) {
+		idr_remove_warning(id);
+		return;
+	}
+
 	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
 	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
 	    idp->top->ary[0]) {
@@ -1025,6 +1030,9 @@ void ida_remove(struct ida *ida, int id)
 	int n;
 	struct ida_bitmap *bitmap;
 
+	if (idr_id > idr_max(ida->idr.layers))
+		goto err;
+
 	/* clear full bits while looking up the leaf idr_layer */
 	while ((shift > 0) && p) {
 		n = (idr_id >> shift) & IDR_MASK;
-- 
1.7.4.4

