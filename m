Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3FZQxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:53:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3FZQxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:53:03 -0400
Date: Wed, 26 Jun 2013 18:48:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Eric Wong <normalperson@yhbt.net>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] signals: eventpoll: set ->saved_sigmask at the
	start
Message-ID: <20130626164839.GA4552@redhat.com>
References: <20130625195738.GA15231@redhat.com> <20130625195759.GA15252@redhat.com> <20130625202343.GA4165@ZenIV.linux.org.uk> <20130625203245.GA16451@redhat.com> <20130625204447.GA17001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625204447.GA17001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Oleg Nesterov wrote:
>
> But if we remove this WARN_ON() we can probably change
> set_restore_sigmask() to set TS_RESTORE_SIGMASK and
> do saved_mask = blocked.
>
> Perhaps it can even acccept "sigset_t *newmask" and do
> set_current_blocked().

So, Al, what do you think if we do something like

	--- x/arch/x86/include/asm/thread_info.h
	+++ x/arch/x86/include/asm/thread_info.h
	@@ -247,7 +247,6 @@ static inline void set_restore_sigmask(v
	 {
		struct thread_info *ti = current_thread_info();
		ti->status |= TS_RESTORE_SIGMASK;
	-	WARN_ON(!test_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags));
	 }
	 static inline void clear_restore_sigmask(void)
	 {
	--- x/include/linux/signal.h
	+++ x/include/linux/signal.h
	@@ -249,6 +249,13 @@ extern void __set_current_blocked(const 
	 extern int show_unhandled_signals;
	 extern int sigsuspend(sigset_t *);
	 
	+static inline set_restore_xxx(sigset_t *mask)
	+{
	+	set_restore_sigmask();
	+	current->saved_sigmask = current->blocked;
	+	set_current_blocked(mask);
	+}
	+
	 struct sigaction {
	 #ifndef __ARCH_HAS_IRIX_SIGACTION
		__sighandler_t	sa_handler;

Then sys_epoll_pwait() (and other users) can simply do

	SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
			int, maxevents, int, timeout, const sigset_t __user *, sigmask,
			size_t, sigsetsize)
	{
		int error;
		/*
		 * If the caller wants a certain signal mask to be set during the wait,
		 * we apply it here.
		 */
		if (sigmask) {
			sigset_t ksigmask;

			if (sigsetsize != sizeof(sigset_t))
				return -EINVAL;
			if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
				return -EFAULT;

			set_restore_xxx(&ksigmask);
		}

		error = sys_epoll_wait(epfd, events, maxevents, timeout);

		if (error != -EINTR)
			restore_saved_sigmask();

		return error;
	}

Hmm... and when I re-read your original email I am starting to think
that perhaps you proposed exactly this...

But I still think it would be better to do this change on top of the
cleanups I sent (fs/compat.c and fs/select.c should be updated too).

But, perhaps, it also makes sense to add

	void restore_saved_sigmask_if(bool cond)
	{
		if (cond)
			restore_saved_sigmask();
		else
			WARN_ON(TS_RESTORE_SIGMASK && !TIF_SIGPENDING);
	}

so that epoll_pwait() could do

	restore_saved_sigmask_if(error != -EINTR);

What do you think?

Oleg.

