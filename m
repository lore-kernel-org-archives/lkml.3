Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaBRWGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:06:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaBRWGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:06:14 -0500
Date: Tue, 18 Feb 2014 17:06:06 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] Set bounds on what /proc/self/make-it-fail accepts.
Message-ID: <20140218220606.GA9712@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/self/make-it-fail is a boolean, but accepts any number, including
negative ones. Change variable to unsigned, and cap upper bound at 1.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 51507065263b..b926377c354f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1207,7 +1207,7 @@ static ssize_t proc_fault_inject_read(struct file * file, char __user * buf,
 	struct task_struct *task = get_proc_task(file_inode(file));
 	char buffer[PROC_NUMBUF];
 	size_t len;
-	int make_it_fail;
+	unsigned int make_it_fail;
 
 	if (!task)
 		return -ESRCH;
@@ -1224,7 +1224,7 @@ static ssize_t proc_fault_inject_write(struct file * file,
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
-	int make_it_fail;
+	unsigned int make_it_fail;
 
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
@@ -1236,6 +1236,9 @@ static ssize_t proc_fault_inject_write(struct file * file,
 	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
 	if (*end)
 		return -EINVAL;
+	if (make_it_fail > 1)
+		return -EINVAL;
+
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
