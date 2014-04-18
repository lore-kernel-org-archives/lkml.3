Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaDRMrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:47:01 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:45782 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753374AbaDRMq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:46:57 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29445287"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 2/8] idr: fix unexpected id-removal when idr_remove(unallocated_id)
Date: Fri, 18 Apr 2014 20:49:49 +0800
Message-ID: <1397825404-12039-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If unallocated_id = (ANY * idr_max(idp->layers) + existed_id) is passed
to idr_remove(). The existed_id will be removed unexpected.

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

It only happens when unallocated_id, it is caller's fault. It is not
a bug. But it is better to add the proper check and complains instead
of removing an existed_id silently.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 4df6792..a28036d 100644
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
-- 
1.7.4.4

