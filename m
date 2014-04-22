Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaDVGV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:21:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:18477 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751908AbaDVGUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:20:18 -0400
X-IronPort-AV: E=Sophos;i="4.97,899,1389715200"; 
   d="scan'208";a="29554485"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 3/7 V3] idr: fix NULL pointer dereference when ida_remove(unallocated_id)
Date: Tue, 22 Apr 2014 14:23:25 +0800
Message-ID: <1398147810-26414-4-git-send-email-laijs@cn.fujitsu.com>
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

If the ida has at least one existing id, and when an unallocated ID which
meets a certain condition is passed to the ida_remove(), the system will crash
because it hits NULL pointer dereference.

The condition is that the unallocated ID shares the same lowest idr layer with
the existing ID, but the idr slot would be different if the unallocated ID
were to be allocated.

In this case the matching idr slot for the unallocated_id is NULL,
causing @bitmap to be NULL which the function dereferences without
checking crashing the kernel.

See the test code:

static void test3(void)
{
	int id;
	DEFINE_IDA(test_ida);

	printk(KERN_INFO "Start test3\n");
	if (ida_pre_get(&test_ida, GFP_KERNEL) < 0) return;
	if (ida_get_new(&test_ida,  &id) < 0) return;
	ida_remove(&test_ida, 4000); /* bug: null deference here */
	printk(KERN_INFO "End of test3\n");
}

It happens only when the caller tries to free an unallocated ID which
is the caller's fault. It is not a bug. But it is better to add
the proper check and complain rather than crashing the kernel.

tj: Updated patch description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 lib/idr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index c4afd94..36ff732 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -1048,7 +1048,7 @@ void ida_remove(struct ida *ida, int id)
 	__clear_bit(n, p->bitmap);
 
 	bitmap = (void *)p->ary[n];
-	if (!test_bit(offset, bitmap->bitmap))
+	if (!bitmap || !test_bit(offset, bitmap->bitmap))
 		goto err;
 
 	/* update bitmap and remove it if empty */
-- 
1.7.4.4

