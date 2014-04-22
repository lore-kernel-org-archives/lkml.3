Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaDVGVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:21:18 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:13030 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751921AbaDVGUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:20:18 -0400
X-IronPort-AV: E=Sophos;i="4.97,899,1389715200"; 
   d="scan'208";a="29554487"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 4/7 V3] idr: fix idr_replace()'s returned error code
Date: Tue, 22 Apr 2014 14:23:26 +0800
Message-ID: <1398147810-26414-5-git-send-email-laijs@cn.fujitsu.com>
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

When the smaller id is not found, idr_replace() returns -ENOENT.
But when the id is bigger enough, idr_replace() returns -EINVAL,
actually there is no difference between these two kinds of ids.

These are all unallocated id, the return values of the idr_replace()
for these ids should be the same: -ENOENT.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 lib/idr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 36ff732..e79e051 100644
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

