Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab3FNV6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:58:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3FNV6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:58:32 -0400
Date: Fri, 14 Jun 2013 14:58:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fput: task_work_add() can fail if the caller has
 passed exit_task_work()
Message-Id: <20130614145831.c65ad42447637e3ad33eb79d@linux-foundation.org>
In-Reply-To: <20130614190947.GA8259@redhat.com>
References: <20130614190915.GA8226@redhat.com>
	<20130614190947.GA8259@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013 21:09:47 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> fput() assumes that it can't be called after exit_task_work() but
> this is not true, for example free_ipc_ns()->shm_destroy() can do
> this. In this case fput() silently leaks the file.
> 
> Change it to fallback to delayed_fput_work if task_work_add() fails.
> The patch looks complicated but it is not, it changes the code from
> 
> 	if (PF_KTHREAD) {
> 		schedule_work(...);
> 		return;
> 	}
> 	task_work_add(...)
> 
> to
> 	if (!PF_KTHREAD) {
> 		if (!task_work_add(...))
> 			return;
> 		/* fallback */
> 	}
> 	schedule_work(...);
> 
> As for shm_destroy() in particular, we could make another fix but I
> think this change makes sense anyway. There could be another similar
> user, it is not safe to assume that task_work_add() can't fail.
> 
> ...
>
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -306,17 +306,18 @@ void fput(struct file *file)
>  {
>  	if (atomic_long_dec_and_test(&file->f_count)) {
>  		struct task_struct *task = current;
> +		unsigned long flags;
> +
>  		file_sb_list_del(file);
> -		if (unlikely(in_interrupt() || task->flags & PF_KTHREAD)) {
> -			unsigned long flags;
> -			spin_lock_irqsave(&delayed_fput_lock, flags);
> -			list_add(&file->f_u.fu_list, &delayed_fput_list);
> -			schedule_work(&delayed_fput_work);
> -			spin_unlock_irqrestore(&delayed_fput_lock, flags);
> -			return;
> +		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
> +			init_task_work(&file->f_u.fu_rcuhead, ____fput);
> +			if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
> +				return;

A comment here would be useful, explaining the circumstances under
which we fall through to the delayed fput.  This is particularly needed
because kernel/task_work.c is such undocumented crap.

This?

--- a/fs/file_table.c~fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix
+++ a/fs/file_table.c
@@ -313,6 +313,12 @@ void fput(struct file *file)
 			init_task_work(&file->f_u.fu_rcuhead, ____fput);
 			if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
 				return;
+			/*
+			 * After this task has run exit_task_work(),
+			 * task_work_add() will fail.  free_ipc_ns()->
+			 * shm_destroy() can do this.  Fall through to delayed
+			 * fput to avoid leaking *file.
+			 */
 		}
 		spin_lock_irqsave(&delayed_fput_lock, flags);
 		list_add(&file->f_u.fu_list, &delayed_fput_list);


>  		}
> -		init_task_work(&file->f_u.fu_rcuhead, ____fput);
> -		task_work_add(task, &file->f_u.fu_rcuhead, true);
> +		spin_lock_irqsave(&delayed_fput_lock, flags);
> +		list_add(&file->f_u.fu_list, &delayed_fput_list);
> +		schedule_work(&delayed_fput_work);
> +		spin_unlock_irqrestore(&delayed_fput_lock, flags);

OT: I don't think that schedule_work() needs to be inside the locked
region.  Scalability improvements beckon!

>  	}
>  }

