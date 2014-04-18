Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaDRMrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:47:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37871 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753350AbaDRMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:47:10 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29445301"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 5/8] idr: covert BUG_ON() to WARN_ON_ONCE() if the argument is invalid.
Date: Fri, 18 Apr 2014 20:49:52 +0800
Message-ID: <1397825404-12039-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the arguments passed by the caller are invalid, WARN_ON_ONCE()
is proper than BUG_ON() which may crash the kernel.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 104f87f..e4f9965 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -1093,13 +1093,14 @@ int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
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
+			return -EINVAL;
 		max = end - 1;
 	}
 
@@ -1135,7 +1136,7 @@ void ida_simple_remove(struct ida *ida, unsigned int id)
 {
 	unsigned long flags;
 
-	BUG_ON((int)id < 0);
+	WARN_ON_ONCE((int)id < 0);
 	spin_lock_irqsave(&simple_ida_lock, flags);
 	ida_remove(ida, id);
 	spin_unlock_irqrestore(&simple_ida_lock, flags);
-- 
1.7.4.4

