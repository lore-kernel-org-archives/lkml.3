Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaDRMrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:47:08 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:45782 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753350AbaDRMrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:47:02 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29445294"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 3/8] idr: fix NULL pointer dereference when ida_remove(unallocated_id)
Date: Fri, 18 Apr 2014 20:49:50 +0800
Message-ID: <1397825404-12039-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the ida has at least one existed_id, and when an special unallocated_id
is passed to the ida_remove(), the system will crash because it hits NULL
pointer dereference.

This special unallocated_id is that it shares the same lowest idr layer with
an exsited_id, but the idr slot is different(if the unallocated_id is allocated).
In this case the supposed idr slot of the unallocated_id is NULL,
It means @bitmap == NULL, and when the code dereference it, it crash the kernel.

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

It only happens when unallocated_id, it is caller's fault. It is not
a bug. But it is better to add the proper check and complains instead
of crashing the kernel.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index a28036d..d200d67 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -1045,7 +1045,7 @@ void ida_remove(struct ida *ida, int id)
 	__clear_bit(n, p->bitmap);
 
 	bitmap = (void *)p->ary[n];
-	if (!test_bit(offset, bitmap->bitmap))
+	if (!bitmap || !test_bit(offset, bitmap->bitmap))
 		goto err;
 
 	/* update bitmap and remove it if empty */
-- 
1.7.4.4

