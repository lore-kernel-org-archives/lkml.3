Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab3CHSBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:01:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759889Ab3CHSBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:01:08 -0500
Date: Fri, 8 Mar 2013 18:59:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] coredump: introduce dump_interrupted()
Message-ID: <20130308175915.GA26322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308175852.GA26300@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By discussion with Mandeep Singh Baines <msb@chromium.org>.

Change dump_write(), dump_seek() and do_coredump() to check
signal_pending() and abort if it is true.

We add the new trivial helper, dump_interrupted(), to document that
this probably needs more work and to simplify the potential freezer
changes. Perhaps it will have more callers.

Ideally it should do try_to_freeze() but then we need the unpleasant
changes in dump_write() and wait_for_dump_helpers(). So far we simply
accept the fact that the freezer can truncate a core-dump but at least
you can reliably suspend.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 5503d94..66f65f0 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -418,6 +418,17 @@ static void coredump_finish(struct mm_struct *mm, bool core_dumped)
 	mm->core_state = NULL;
 }
 
+static bool dump_interrupted(void)
+{
+	/*
+	 * SIGKILL or freezing() interrupt the coredumping. Perhaps we
+	 * can do try_to_freeze() and check __fatal_signal_pending(),
+	 * but then we need to teach dump_write() to restart and clear
+	 * TIF_SIGPENDING.
+	 */
+	return signal_pending(current);
+}
+
 static void wait_for_dump_helpers(struct file *file)
 {
 	struct pipe_inode_info *pipe;
@@ -636,7 +647,7 @@ void do_coredump(siginfo_t *siginfo)
 	if (displaced)
 		put_files_struct(displaced);
 
-	core_dumped = binfmt->core_dump(&cprm);
+	core_dumped = !dump_interrupted() && binfmt->core_dump(&cprm);
 
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -664,7 +675,9 @@ fail:
  */
 int dump_write(struct file *file, const void *addr, int nr)
 {
-	return access_ok(VERIFY_READ, addr, nr) && file->f_op->write(file, addr, nr, &file->f_pos) == nr;
+	return !dump_interrupted() &&
+		access_ok(VERIFY_READ, addr, nr) &&
+		file->f_op->write(file, addr, nr, &file->f_pos) == nr;
 }
 EXPORT_SYMBOL(dump_write);
 
@@ -673,7 +686,8 @@ int dump_seek(struct file *file, loff_t off)
 	int ret = 1;
 
 	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
-		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
+		if (dump_interrupted() ||
+		    file->f_op->llseek(file, off, SEEK_CUR) < 0)
 			return 0;
 	} else {
 		char *buf = (char *)get_zeroed_page(GFP_KERNEL);
-- 
1.5.5.1

