Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbaKRVaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:30:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbaKRVaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:30:25 -0500
Date: Tue, 18 Nov 2014 22:30:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] exit: reparent: document the ->has_child_subreaper
	checks
Message-ID: <20141118213023.GA5027@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118212952.GA4754@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swap the "init_task" and same_thread_group() checks. This way it
is more simple to document these checks and we can remove the link
to the previous discussion on lkml.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index ac7ba9b..266e4f4 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -495,18 +495,16 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 
 	if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
-
 		/*
-		 * Find the first ancestor marked as child_subreaper.
-		 * Note that the code below checks same_thread_group(reaper,
-		 * pid_ns->child_reaper).  This is what we need to DTRT in a
-		 * PID namespace. However we still need the check above, see
-		 * http://marc.info/?l=linux-kernel&m=131385460420380
+		 * Find the first ->is_child_subreaper ancestor in our pid_ns.
+		 * We start from father to ensure we can not look into another
+		 * namespace, this is safe because all its threads are dead.
 		 */
 		for (reaper = father;
-		     reaper != &init_task;
+		     !same_thread_group(reaper, pid_ns->child_reaper);
 		     reaper = reaper->real_parent) {
-			if (same_thread_group(reaper, pid_ns->child_reaper))
+			/* call_usermodehelper() descendants need this check */
+			if (reaper == &init_task)
 				break;
 			if (!reaper->signal->is_child_subreaper)
 				continue;
-- 
1.5.5.1

