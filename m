Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaBRWcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:32:11 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51186 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaBRWcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:32:07 -0500
Date: Tue, 18 Feb 2014 14:32:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Akinobu Mita <akinobu.mita@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] Set bounds on what /proc/self/make-it-fail accepts.
In-Reply-To: <20140218220606.GA9712@redhat.com>
Message-ID: <alpine.DEB.2.02.1402181429060.20772@chino.kir.corp.google.com>
References: <20140218220606.GA9712@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Dave Jones wrote:

> /proc/self/make-it-fail is a boolean, but accepts any number, including
> negative ones. Change variable to unsigned, and cap upper bound at 1.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 

Hmm, this would break anything that uses anything other than one to enable 
it, but it looks like Documentation/fault-injection/fault-injection.txt 
only provides an example for when it does equal one, so it's probably an 
ok change.  I'm just wondering why non-zero is wrong?  Is this an 
interface that will be extended to support other modes?

Adding Akinobu to the cc.

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
