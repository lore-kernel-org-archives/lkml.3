Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaDKJ7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:59:19 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:4747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755942AbaDKJ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:59:13 -0400
X-IronPort-AV: E=Sophos;i="4.97,841,1389715200"; 
   d="scan'208";a="29145733"
Message-ID: <5347BAB7.6060306@cn.fujitsu.com>
Date: Fri, 11 Apr 2014 17:49:43 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] f2fs: remove the unuseful "issue_tail" list
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the issue_list and dispatch_list, we can handle flush_merge
already, so remove the useless "issue_tail" list.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/f2fs.h    |    1 -
 fs/f2fs/segment.c |    5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2ecac83..90109fa 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -358,7 +358,6 @@ struct f2fs_sm_info {
 	struct flush_cmd *issue_list;		/* list for command issue */
 	struct flush_cmd *dispatch_list;	/* list for command dispatch */
 	spinlock_t issue_lock;			/* for issue list lock */
-	struct flush_cmd *issue_tail;		/* list tail of issue list */
 };
 
 /*
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 524b7ed..8a6fe2a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -209,7 +209,7 @@ repeat:
 	spin_lock(&sm_i->issue_lock);
 	if (sm_i->issue_list) {
 		sm_i->dispatch_list = sm_i->issue_list;
-		sm_i->issue_list = sm_i->issue_tail = NULL;
+		sm_i->issue_list = NULL;
 	}
 	spin_unlock(&sm_i->issue_lock);
 
@@ -250,10 +250,9 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 
 	spin_lock(&sm_i->issue_lock);
 	if (sm_i->issue_list)
-		sm_i->issue_tail->next = cmd;
+		sm_i->issue_list->next = cmd;
 	else
 		sm_i->issue_list = cmd;
-	sm_i->issue_tail = cmd;
 	spin_unlock(&sm_i->issue_lock);
 
 	if (!sm_i->dispatch_list)
-- 
1.7.7

