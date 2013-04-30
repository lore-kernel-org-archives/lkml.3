Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220Ab3D3Qlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:41:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761105Ab3D3Ql2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:41:28 -0400
Date: Tue, 30 Apr 2013 18:38:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 09/10] sigtimedwait: use freezable blocking call
Message-ID: <20130430163817.GA27304@redhat.com>
References: <1367271946-7239-1-git-send-email-ccross@android.com> <1367271946-7239-10-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367271946-7239-10-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Colin Cross wrote:
>
> Avoid waking up every thread sleeping in a sigtimedwait call during
> suspend and resume by calling a freezable blocking call.

This doesn't explain why do want this change...

OK, probably to avoid -EAGAIN from sigtimedwait() if the freezer wakes
up the caller.

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2845,7 +2845,7 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
>  		recalc_sigpending();
>  		spin_unlock_irq(&tsk->sighand->siglock);
>
> -		timeout = schedule_timeout_interruptible(timeout);
> +		timeout = freezable_schedule_timeout_interruptible(timeout);

And I guess freezable_schedule_timeout_interruptible() is added by
http://marc.info/?l=linux-kernel&m=136727195719575 ...

	+#define freezable_schedule_timeout_interruptible(timeout)		\
	+({									\
	+	long __retval;							\
	+	freezer_do_not_count();						\
	+	__retval = schedule_timeout_interruptible(timeout);		\
	+	freezer_count();						\
	+	__retval;							\
	+})

How this can help?

The task will be interrupted anyway and the syscall will return
-EAGAIN, this only changes the time when try_to_freeze() is called.

For what? The task will call do_signal/try_to_freeze really "soon".

Confused...

Oleg.

