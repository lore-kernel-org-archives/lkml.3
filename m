Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935257AbaGPTYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:24:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaGPTYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:24:35 -0400
Date: Wed, 16 Jul 2014 12:23:18 -0700
From: tip-bot for Jason Baron <tipbot@zytor.com>
Message-ID: <tip-5cd08fbfdb6baa9fe98f530b76898fc5725a6289@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, jbaron@akamai.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, jbaron@akamai.com, tglx@linutronix.de
In-Reply-To: <9d7780c83db26683955cd01e6bc654ee2586e67f.1404315388.git.jbaron@akamai.com>
References: <9d7780c83db26683955cd01e6bc654ee2586e67f.1404315388.git.jbaron@akamai.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix static_key race with sched_feat()
Git-Commit-ID: 5cd08fbfdb6baa9fe98f530b76898fc5725a6289
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cd08fbfdb6baa9fe98f530b76898fc5725a6289
Gitweb:     http://git.kernel.org/tip/5cd08fbfdb6baa9fe98f530b76898fc5725a6289
Author:     Jason Baron <jbaron@akamai.com>
AuthorDate: Wed, 2 Jul 2014 15:52:44 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:38:21 +0200

sched: Fix static_key race with sched_feat()

As pointed out by Andi Kleen, the usage of static keys can be racy in
sched_feat_disable() vs. sched_feat_enable(). Currently, we first check the
value of keys->enabled, and subsequently update the branch direction. This,
can be racy and can potentially leave the keys in an inconsistent state.

Take the i_mutex around these calls to resolve the race.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rostedt@goodmis.org
Link: http://lkml.kernel.org/r/9d7780c83db26683955cd01e6bc654ee2586e67f.1404315388.git.jbaron@akamai.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2f96081..8705125 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -245,6 +245,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	char buf[64];
 	char *cmp;
 	int i;
+	struct inode *inode;
 
 	if (cnt > 63)
 		cnt = 63;
@@ -255,7 +256,11 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	buf[cnt] = 0;
 	cmp = strstrip(buf);
 
+	/* Ensure the static_key remains in a consistent state */
+	inode = file_inode(filp);
+	mutex_lock(&inode->i_mutex);
 	i = sched_feat_set(cmp);
+	mutex_unlock(&inode->i_mutex);
 	if (i == __SCHED_FEAT_NR)
 		return -EINVAL;
 
