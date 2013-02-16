Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3BPJxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 04:53:38 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36411 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab3BPJxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 04:53:36 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/5] vfork: don't freezer_count() for in-kernel users of CLONE_VFORK
Date: Sat, 16 Feb 2013 01:53:22 -0800
Message-Id: <1361008406-2307-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to call freezer_do_not_count() for in-kernel users
of CLONE_VFORK since exec will get called in bounded time.

We don't want to call freezer_count() for in-kernel users because
they may be holding locks. freezer_count() calls try_to_freeze().
We don't want to freeze an in-kernel user because it may be
holding locks.

Changes since v1:
* <20130215152840.GC30829@redhat.com> Oleg Nesterov
 * Use (p->flags & PF_KTHREAD) checks instead of p->mm.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/fork.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index c535f33..c7ace33 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -722,9 +722,11 @@ static int wait_for_vfork_done(struct task_struct *child,
 {
 	int killed;
 
-	freezer_do_not_count();
+	if (!(current->flags & PF_KTHREAD))
+		freezer_do_not_count();
 	killed = wait_for_completion_killable(vfork);
-	freezer_count();
+	if (!(current->flags & PF_KTHREAD))
+		freezer_count();
 
 	if (killed) {
 		task_lock(child);
-- 
1.7.12.4

