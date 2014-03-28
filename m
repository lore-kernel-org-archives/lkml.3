Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbaC1Cl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 22:41:28 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61220 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494AbaC1ClV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 22:41:21 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/12] cgroup: cgroup->subsys[] should be cleared after the css is offlined
Date: Thu, 27 Mar 2014 22:40:56 -0400
Message-Id: <1395974461-12735-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395974461-12735-1-git-send-email-tj@kernel.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a css finishes offlining, offline_css() mistakenly performs
RCU_INIT_POINTER(css->cgroup->subsys[ss->id], css) which just sets the
cgroup->subsys[] pointer to the current value.  The intention was to
clear it after offline is complete, not reassign the same value.

Update it to assign NULL instead of the current value.  This makes
cgroup_css() to return NULL once offline is complete.  All the
existing users of the function either can handle NULL return already
or guarantee that the css doesn't get offlined.

While this is a bugfix, as css lifetime is currently tied to the
cgroup it belongs to, this bug doesn't cause any actual problems.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e3aa2aa..c59946c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3692,7 +3692,7 @@ static void offline_css(struct cgroup_subsys_state *css)
 
 	css->flags &= ~CSS_ONLINE;
 	css->cgroup->nr_css--;
-	RCU_INIT_POINTER(css->cgroup->subsys[ss->id], css);
+	RCU_INIT_POINTER(css->cgroup->subsys[ss->id], NULL);
 }
 
 /**
-- 
1.8.5.3

