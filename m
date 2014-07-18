Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469AbaGRUML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:12:11 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:51941 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaGRUMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:12:09 -0400
Date: Fri, 18 Jul 2014 23:12:05 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/10] proc: convert /proc/$PID/cmdline to seq_file
 interface
Message-ID: <20140718201205.GB26857@p183.telecom.by>
References: <20140716213247.GC21290@p183.telecom.by>
 <20140717155346.afadf6243dc6c0ebfda95853@linux-foundation.org>
 <20140718201059.GA26857@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718201059.GA26857@p183.telecom.by>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -200,9 +200,16 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
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
+	 */
+	BUG_ON(m->size < PAGE_SIZE);
+	m->count += get_cmdline(task, m->buf, PAGE_SIZE);
+	return 0;
 }
 
 static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
@@ -2567,7 +2574,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
+	ONE("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
@@ -2903,7 +2910,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
+	ONE("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
