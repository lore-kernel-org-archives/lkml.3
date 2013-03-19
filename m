Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767Ab3CST3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:29:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3520 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933698Ab3CST3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:29:09 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904516"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 21/21] workqueue: avoid false negative in assert_manager_or_pool_lock()
Date: Wed, 20 Mar 2013 03:28:21 +0800
Message-Id: <1363721306-2030-22-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:42,
	Serialize complete at 2013/03/20 03:27:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If lockdep complains something for other subsystem, lockdep_is_held() can be
false negative. so we need to also test debug_locks before do assert.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ce8fd7b..13d4d46 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -304,7 +304,8 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 
 #ifdef CONFIG_LOCKDEP
 #define assert_manager_or_pool_lock(pool)				\
-	WARN_ONCE(!lockdep_is_held(&(pool)->manager_mutex) &&		\
+	WARN_ONCE(debug_locks &&					\
+		  !lockdep_is_held(&(pool)->manager_mutex) &&		\
 		  !lockdep_is_held(&(pool)->lock),			\
 		  "pool->manager_mutex or ->lock should be held")
 #else
-- 
1.7.7.6

