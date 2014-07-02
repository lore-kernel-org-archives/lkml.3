Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaGBPws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:52:48 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:34081 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932164AbaGBPwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:52:46 -0400
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, rostedt@goodmis.org
Message-Id: <9d7780c83db26683955cd01e6bc654ee2586e67f.1404315388.git.jbaron@akamai.com>
In-Reply-To: <cover.1404315388.git.jbaron@akamai.com>
References: <cover.1404315388.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 2/2] sched: fix static_key race with sched_feat
Date: Wed,  2 Jul 2014 15:52:44 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Andi Kleen, the usage of static keys can be racy in
sched_feat_disable() vs. sched_feat_enable(). Currently, we first check the
value of keys->enabled, and subsequently update the branch direction. This,
can be racy and can potentially leave the keys in an inconsistent state.

Take the i_mutex around these calls to resolve the race.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 kernel/sched/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3bdf01b..249c865 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -243,6 +243,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	char buf[64];
 	char *cmp;
 	int i;
+	struct inode *inode;
 
 	if (cnt > 63)
 		cnt = 63;
@@ -253,7 +254,11 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	buf[cnt] = 0;
 	cmp = strstrip(buf);
 
+	/* Ensure the static_key remains in a consistent state */
+	inode = file_inode(filp);
+	mutex_lock(&inode->i_mutex);
 	i = sched_feat_set(cmp);
+	mutex_unlock(&inode->i_mutex);
 	if (i == __SCHED_FEAT_NR)
 		return -EINVAL;
 
-- 
1.8.2.rc2

