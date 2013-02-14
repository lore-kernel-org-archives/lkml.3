Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935131Ab3BNXic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:38:32 -0500
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48526 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759670Ab3BNXia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:38:30 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/5] vfork: don't freezer_count() for in-kernel users of CLONE_VFORK
Date: Thu, 14 Feb 2013 15:38:12 -0800
Message-Id: <1360885096-21207-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to call freezer_do_not_count() for in-kernel users
of CLONE_VFORK since exec will get called in bounded time.

We don't want to call freezer_count() for in-kernel users because
they may be holding locks. freezer_count() calls try_to_freeze().
We don't want to freeze an in-kernel user because it may be
holding locks.

In a follow-up patch, I call debug_check_no_locks_held() from
try_to_freeze(). After applying this patch, I get no lockdep
warnings with that patch.

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
index c535f33..a7cd973 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -722,9 +722,11 @@ static int wait_for_vfork_done(struct task_struct *child,
 {
 	int killed;
 
-	freezer_do_not_count();
+	if (current->mm)
+		freezer_do_not_count();
 	killed = wait_for_completion_killable(vfork);
-	freezer_count();
+	if (current->mm)
+		freezer_count();
 
 	if (killed) {
 		task_lock(child);
-- 
1.8.1

