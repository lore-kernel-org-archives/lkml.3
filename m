Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3H0PzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:55:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab3H0PzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:55:03 -0400
Date: Tue, 27 Aug 2013 16:53:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] proc: make proc_fd_permission() thread-friendly
Message-ID: <20130827145345.GC19425@redhat.com>
References: <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com> <20130825194844.GA16717@redhat.com> <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com> <20130826153301.GA15890@redhat.com> <20130826163704.GA21763@redhat.com> <20130826175441.GA28856@redhat.com> <87ioyspaju.fsf@xmission.com> <20130826184631.GA30917@redhat.com> <8738pwp8tj.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738pwp8tj.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
> >
> > And I also assume that you agree with this change ;)
>
> I don't disagree.  Comparing tgid to pids is goofy and my brain is
> elsewhere so I have no thought through the implications.
>
> Actually thinking I think the check should really be.  In which case we
> are comparing what we really care about.
>
> int proc_fd_permission(struct inode *inode, int mask)
> {
> 	int rv = generic_permission(inode, mask);
> 	if (rv == 0)
> 		return 0;
>
>         rcu_read_lock();
>         struct task *task = pid_task(proc_pid(inode));
>         if (task && (current->files == task->files))

But for what?

To me, this looks like the unnecessary semantic complication. It
looks as if we actually need to restrict the access to /proc/self/fd
or /proc/<tgid>/fd or /proc/<subthread-tid>/fd.

I do not think there is any security reason to deny this. They share
->mm, a sub-thread can do "everything" with its leader or vice versa.

same_thread_group() looks more simple and natural to me. And note
that __ptrace_may_access() was recently changed (in -mm) to use
same_thread_group() instead of "task == current".

So personally I'd prefer to not change this patch and I think it
makes sense even with "make /proc/self point to thread" I sent.

But. please tell me if you really dislike it. You are maintainer,
I won't argue.

Oleg.

