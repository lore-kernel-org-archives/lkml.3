Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaBSVkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:40:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaBSVk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:40:26 -0500
Date: Wed, 19 Feb 2014 13:40:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] Set bounds on what /proc/self/make-it-fail accepts.
Message-Id: <20140219134025.fcd70941e1ec98723a1bd230@linux-foundation.org>
In-Reply-To: <20140218220606.GA9712@redhat.com>
References: <20140218220606.GA9712@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014 17:06:06 -0500 Dave Jones <davej@redhat.com> wrote:

> /proc/self/make-it-fail is a boolean, but accepts any number, including
> negative ones. Change variable to unsigned, and cap upper bound at 1.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 51507065263b..b926377c354f 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1207,7 +1207,7 @@ static ssize_t proc_fault_inject_read(struct file * file, char __user * buf,
>  	struct task_struct *task = get_proc_task(file_inode(file));
>  	char buffer[PROC_NUMBUF];
>  	size_t len;
> -	int make_it_fail;
> +	unsigned int make_it_fail;
>  
>  	if (!task)
>  		return -ESRCH;
> @@ -1224,7 +1224,7 @@ static ssize_t proc_fault_inject_write(struct file * file,
>  {
>  	struct task_struct *task;
>  	char buffer[PROC_NUMBUF], *end;
> -	int make_it_fail;
> +	unsigned int make_it_fail;
>  
>  	if (!capable(CAP_SYS_RESOURCE))
>  		return -EPERM;
> @@ -1236,6 +1236,9 @@ static ssize_t proc_fault_inject_write(struct file * file,
>  	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
>  	if (*end)
>  		return -EINVAL;
> +	if (make_it_fail > 1)
> +		return -EINVAL;
> +
>  	task = get_proc_task(file_inode(file));
>  	if (!task)
>  		return -ESRCH;

Switching `make_it_fail' to unsigned makes the test simpler but it does
rather muck up the typing in there.  task_struct.make_it_fail is still
an int, we should now use simple_strtoul rather than simple_strtol,
proc_fault_inject_read()'s snprintf() should now use %u, etc.  None of
which actually matters, but still...

Rather than address all that I'm inclined to leave `make_it_fail' as an
int, turning your patch into a one-liner?

--- a/fs/proc/base.c~fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix
+++ a/fs/proc/base.c
@@ -1207,7 +1207,7 @@ static ssize_t proc_fault_inject_read(st
 	struct task_struct *task = get_proc_task(file_inode(file));
 	char buffer[PROC_NUMBUF];
 	size_t len;
-	unsigned int make_it_fail;
+	int make_it_fail;
 
 	if (!task)
 		return -ESRCH;
@@ -1224,7 +1224,7 @@ static ssize_t proc_fault_inject_write(s
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
-	unsigned int make_it_fail;
+	int make_it_fail;
 
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
@@ -1236,7 +1236,7 @@ static ssize_t proc_fault_inject_write(s
 	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
 	if (*end)
 		return -EINVAL;
-	if (make_it_fail > 1)
+	if (make_it_fail < 0 || make_it_fail > 1)
 		return -EINVAL;
 
 	task = get_proc_task(file_inode(file));
_

