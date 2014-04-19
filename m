Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaDSLfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:35:04 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:55869 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751367AbaDSLe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:34:58 -0400
X-IronPort-AV: E=Sophos;i="4.97,888,1389715200"; 
   d="scan'208";a="29471755"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 5/9 V2] idr: covert BUG_ON() to WARN_ON_ONCE() if the argument is invalid.
Date: Sat, 19 Apr 2014 19:38:12 +0800
Message-ID: <1397907496-5993-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the arguments passed by the caller are invalid, WARN_ON_ONCE()
is proper than BUG_ON() which may crash the kernel.

The invalid-checking for ida_simple_remove() is moved into ida_remove().
idr_remove() also adds this WARN_ON_ONCE().

And when "end < start" in ida_simple_get(), it returns -ENOSPC as
ida_alloc() does.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index e79e051..317fd35 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -559,7 +559,7 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *p;
 	struct idr_layer *to_free;
 
-	if (id < 0)
+	if (WARN_ON_ONCE(id < 0))
 		return;
 
 	if (id > idr_max(idp->layers)) {
@@ -1030,6 +1030,9 @@ void ida_remove(struct ida *ida, int id)
 	int n;
 	struct ida_bitmap *bitmap;
 
+	if (WARN_ON_ONCE(id < 0))
+		return;
+
 	if (idr_id > idr_max(ida->idr.layers))
 		goto err;
 
@@ -1096,13 +1099,14 @@ int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
 	unsigned int max;
 	unsigned long flags;
 
-	BUG_ON((int)start < 0);
-	BUG_ON((int)end < 0);
+	if (WARN_ON_ONCE(((int)start < 0) || ((int)end < 0)))
+		return -EINVAL;
 
 	if (end == 0)
 		max = 0x80000000;
 	else {
-		BUG_ON(end < start);
+		if (WARN_ON_ONCE(end < start))
+			return -ENOSPC;
 		max = end - 1;
 	}
 
@@ -1138,7 +1142,6 @@ void ida_simple_remove(struct ida *ida, unsigned int id)
 {
 	unsigned long flags;
 
-	BUG_ON((int)id < 0);
 	spin_lock_irqsave(&simple_ida_lock, flags);
 	ida_remove(ida, id);
 	spin_unlock_irqrestore(&simple_ida_lock, flags);
-- 
1.7.4.4

