Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaKDViX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:38:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaKDViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:38:22 -0500
Date: Tue, 4 Nov 2014 13:38:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: eparis@redhat.com, john@johnmccutchan.com, rlove@rlove.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsnotify: don't call mutex_lock from TASK_INTERRUPTIBLE
 context
Message-Id: <20141104133823.6872a4c977891b98a4091b6a@linux-foundation.org>
In-Reply-To: <1414900298-7871-1-git-send-email-sasha.levin@oracle.com>
References: <1414900298-7871-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  1 Nov 2014 23:51:38 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Sleeping functions should only be called from TASK_RUNNING. The following
> code in fanotify_read():
> 
> 	prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
> 
>         mutex_lock(&group->notification_mutex);
> 
> would call it under TASK_INTERRUPTIBLE, and trigger a warning:
> 
> [12326.092094] WARNING: CPU: 27 PID: 30207 at kernel/sched/core.c:7305 __might_sleep+0xd2/0x110()
> [12326.092878] do not call blocking ops when !TASK_RUNNING; state=1 set at prepare_to_wait (./arch/x86/include/asm/current.h:14 kernel/sched/wait.c:179)
> [12326.093938] Modules linked in:
>
> ...
>

It's a fairly minor problem - if mutex_lock() hits contention we get
flipped into TASK_RUNNING and the schedule() immediately returns and we
take another trip around the loop.

fanotify_read() also calls copy_event_to_user()->copy_to_user() in
TASK_INTERRUPTIBLE state.  That's a bug and this is why the first thing
handle_mm_fault() does is to set TASK_RUNNING.

> Instead of trying to fix fanotify_read() I've converted
> notification_mutex into a spinlock.  I didn't see a reason why it
> should be a mutex nor anything complained when I ran the same tests
> again.

This could be a latency problem - those lists can get very long.

I wonder if we can zap the prepare_to_wait()/finish_wait() and use
something like

	wait_event_interruptible(notification_waitq, foo(group, count));

int foo(struct fsnotify_group *group, size_t count)
{
	int ret;

	mutex_lock(&group->notification_mutex);
	ret = get_one_event(group, count);
	mutex_unlock(&group->notification_mutex);
}

