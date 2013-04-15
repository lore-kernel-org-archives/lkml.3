Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934752Ab3DOPfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:35:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933283Ab3DOPfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:35:50 -0400
Date: Mon, 15 Apr 2013 17:33:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Wagin <avagin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/1] move exit_task_namespaces() outside of
	exit_notify()
Message-ID: <20130415153307.GA15817@redhat.com>
References: <1365794853-23912-1-git-send-email-avagin@openvz.org> <20130413142246.GA864@redhat.com> <20130413155457.GA6533@redhat.com> <20130413155521.GB6533@redhat.com> <CANaxB-wb3h9zb1C38W=pSjg_sf4RiRbpUHRU2pKppohmDy5Dtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANaxB-wb3h9zb1C38W=pSjg_sf4RiRbpUHRU2pKppohmDy5Dtg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15, Andrey Wagin wrote:
>
> It looks good for me. I have tested it a bit and don't find any problem.
> Oleg, thank you.
>
> Acked-by: Andrew Vagin <avagin@gmail.com>

Thanks Andrey and Eric.

> > --- x/kernel/exit.c
> > +++ x/kernel/exit.c
> > @@ -649,7 +649,6 @@ static void exit_notify(struct task_stru
> >          *      jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
> >          */
> >         forget_original_parent(tsk);
> > -       exit_task_namespaces(tsk);
> >
> >         write_lock_irq(&tasklist_lock);
> >         if (group_dead)
> > @@ -795,6 +794,7 @@ void do_exit(long code)
> >         exit_shm(tsk);
> >         exit_files(tsk);
> >         exit_fs(tsk);
> > +       exit_task_namespaces(tsk);
> >         exit_task_work(tsk);

I do not see any problems with this patch too... but still I am worried.

Even if fput() can work correctly after exit_task_namespaces(), this limits
the usage of task_work_add(). Probably this is fine, but can't we at least
discuss another change?

We can change fput() so that it can always work, even after exit_task_work(),

	void fput(struct file *file)
	{
		if (atomic_long_dec_and_test(&file->f_count)) {
			struct task_struct *task = current;
			unsigned long flags;

			file_sb_list_del(file);
			if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
				init_task_work(&file->f_u.fu_rcuhead, ____fput);
				if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
					return;
			}

			spin_lock_irqsave(&delayed_fput_lock, flags);
			list_add(&file->f_u.fu_list, &delayed_fput_list);
			schedule_work(&delayed_fput_work);
			spin_unlock_irqrestore(&delayed_fput_lock, flags);
		}
	}

Al, what do you think?

Untested patch below.

Oleg.

--- x/fs/file_table.c
+++ x/fs/file_table.c
@@ -306,17 +306,19 @@ void fput(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		struct task_struct *task = current;
+		unsigned long flags;
+
 		file_sb_list_del(file);
-		if (unlikely(in_interrupt() || task->flags & PF_KTHREAD)) {
-			unsigned long flags;
-			spin_lock_irqsave(&delayed_fput_lock, flags);
-			list_add(&file->f_u.fu_list, &delayed_fput_list);
-			schedule_work(&delayed_fput_work);
-			spin_unlock_irqrestore(&delayed_fput_lock, flags);
-			return;
+		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
+			init_task_work(&file->f_u.fu_rcuhead, ____fput);
+			if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
+				return;
 		}
-		init_task_work(&file->f_u.fu_rcuhead, ____fput);
-		task_work_add(task, &file->f_u.fu_rcuhead, true);
+
+		spin_lock_irqsave(&delayed_fput_lock, flags);
+		list_add(&file->f_u.fu_list, &delayed_fput_list);
+		schedule_work(&delayed_fput_work);
+		spin_unlock_irqrestore(&delayed_fput_lock, flags);
 	}
 }
 

