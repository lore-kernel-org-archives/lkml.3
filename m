Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3CKQ2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:28:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6269 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab3CKQ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:28:09 -0400
X-IronPort-AV: E=Sophos;i="4.84,824,1355068800"; 
   d="scan'208";a="6852601"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/3] async: simplify lowest_in_progress()
Date: Tue, 12 Mar 2013 00:30:02 +0800
Message-Id: <1363019405-4331-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1363019405-4331-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363019405-4331-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 00:26:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 00:26:56,
	Serialize complete at 2013/03/12 00:26:56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in lowest_in_progress() are duplicated in two branches,
simplify them.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/async.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 8ddee2c..ef66b2f 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -84,24 +84,20 @@ static atomic_t entry_count;
 
 static async_cookie_t lowest_in_progress(struct async_domain *domain)
 {
-	struct async_entry *first = NULL;
+	struct list_head *pending;
 	async_cookie_t ret = ASYNC_COOKIE_MAX;
 	unsigned long flags;
 
 	spin_lock_irqsave(&async_lock, flags);
 
-	if (domain) {
-		if (!list_empty(&domain->pending))
-			first = list_first_entry(&domain->pending,
-					struct async_entry, domain_list);
-	} else {
-		if (!list_empty(&async_global_pending))
-			first = list_first_entry(&async_global_pending,
-					struct async_entry, global_list);
-	}
+	if (domain)
+		pending = &domain->pending;
+	else
+		pending = &async_global_pending;
 
-	if (first)
-		ret = first->cookie;
+	if (!list_empty(pending))
+		ret = list_first_entry(pending, struct async_entry,
+				domain_list)->cookie;
 
 	spin_unlock_irqrestore(&async_lock, flags);
 	return ret;
-- 
1.7.4.4

