Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaGPVcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:32:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34490 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaGPVcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:32:51 -0400
Date: Thu, 17 Jul 2014 00:32:47 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] proc: fix PAGE_SIZE limit of /proc/$PID/cmdline
Message-ID: <20140716213247.GC21290@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert /proc/$PID/cmdline to seq_file interface.

XXX

This one must be buggy.

seq_file buffer is adjustable, so userspace can execute itself
with huge command line (which can be arbitrarily long now), then read 1 byte.

Voila, whole command line now is in kmalloced/vmalloced memory.

Imposing limit is trivial but equally lame to current PAGE_SIZE limit.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -200,9 +200,17 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
 	return result;
 }
 
-static int proc_pid_cmdline(struct task_struct *task, char *buffer)
+static int proc_pid_cmdline(struct seq_file *m, struct pid_namespace *ns,
+			    struct pid *pid, struct task_struct *task)
 {
-	return get_cmdline(task, buffer, PAGE_SIZE);
+	/*
+	 * Rely on struct seq_operations::show() being called once
+	 * per internal buffer allocation. See single_open(), traverse().
+	 *
+	 * Rely on internal buffer autoexpansion if it was entirely filled.
+	 */
+	m->count += get_cmdline(task, m->buf, m->size);
+	return 0;
 }
 
 static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
@@ -2567,7 +2575,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
+	ONE("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
@@ -2903,7 +2911,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
+	ONE("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
