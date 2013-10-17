Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab3JQWO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:14:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60633 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3JQWOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:14:54 -0400
Date: Thu, 17 Oct 2013 23:14:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: George Spelvin <linux@horizon.com>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Message-ID: <20131017221450.GU13318@ZenIV.linux.org.uk>
References: <20131009172336.GH13318@ZenIV.linux.org.uk>
 <20131017211143.1712.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017211143.1712.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:11:43PM -0400, George Spelvin wrote:
> Al Viro wrote:
> > Note that do_group_exit() is preceded by
> >                spin_unlock_irq(&sighand->siglock);
> > so no matter what happened in callers, irq is enabled.  I'd suggest sticking
> > such BUG_ON() into __fput() and trying to reproduce that crap...
> 
> Well, it happened again (error appended).  Can you please clarify what you mean
> by "such BUG_ON()"; I'm having a hard time following the RCU code and determining
> all the situations under which __fput() might be called.

__fput() can be called via task_work_run() or via schedule_work().  That's
all.  And it certainly should never be called with interrupts disabled.
So stick BUG_ON(irqs_disabled()) in it (WARN_ON() might be better, but
not by much).

There are two ways these traces could've happened:
	* exit_task_work() called by do_exit() with irqs disabled.
Definitely buggy (and would do really nasty things to several functions
called by do_exit() before that one).  If such BUG_ON() triggers in
__fput(), this is what happens and the next step will be sticking
several BUG_ON(irqs_disabled()) in do_exit() - something like
	BUG_ON(irqs_disabled());
        exit_sem(tsk);
	BUG_ON(irqs_disabled());
        exit_shm(tsk);
	BUG_ON(irqs_disabled());
        exit_files(tsk);
	BUG_ON(irqs_disabled());
        exit_fs(tsk);
	BUG_ON(irqs_disabled());
        exit_task_namespaces(tsk);
	BUG_ON(irqs_disabled());
        exit_task_work(tsk);
and checking which of those triggers; that'll tell us who has disabled it
and forgot to enable.
	* __fput() is called with irqs enabled, but somewhere on the
way into ext4 (dput -> iput -> evict inode -> free blocks, now that
unlinked file got closed -> ...) we manage to disable irqs and forget
to enable them.
