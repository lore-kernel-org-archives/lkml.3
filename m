Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaDRMrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:47:15 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:53502 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754213AbaDRMrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:47:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29445299"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 4/8] idr: fix idr_replace()'s returned error code
Date: Fri, 18 Apr 2014 20:49:51 +0800
Message-ID: <1397825404-12039-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the smaller id is not found, idr_replace() returns -ENOENT.
But when the id is bigger enough, idr_replace() returns -EINVAL,
actually there is no difference between these two kinds of ids.

These are all unallocated id, the return values of the idr_replace()
for these ids should be the same: -ENOENT.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index d200d67..104f87f 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -814,10 +814,10 @@ void *idr_replace(struct idr *idp, void *ptr, int id)
 
 	p = idp->top;
 	if (!p)
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-ENOENT);
 
 	if (id > idr_max(p->layer + 1))
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-ENOENT);
 
 	n = p->layer * IDR_BITS;
 	while ((n > 0) && p) {
-- 
1.7.4.4

