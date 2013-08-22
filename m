Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3HVQwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab3HVQwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:52:54 -0400
Date: Thu, 22 Aug 2013 18:47:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
Message-ID: <20130822164703.GA19196@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com> <20130819183319.GA24846@redhat.com> <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com> <20130819184355.GA25362@redhat.com> <87siy4z1pf.fsf@xmission.com> <20130820184521.GA23293@redhat.com> <87li3ww0e6.fsf@xmission.com> <20130821163532.GA15152@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821163532.GA15152@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Oleg Nesterov wrote:
>
> Still. Can't we make a single check? Like the initial patch I sent, but
> this one moves the check into copy_process() and checks CLONE_* first.
> Looks a bit simpler. And more understandable to me but this is subjective.

Seriously. CLONE_NEWPID and task_active_pid_ns() != nsproxy->pid_ns are
the same thing in this respect. Let me send the patches for review, I
decided to split this change.

> --- x/kernel/fork.c
> +++ x/kernel/fork.c
> @@ -1173,12 +1173,13 @@ static struct task_struct *copy_process(
>  		return ERR_PTR(-EINVAL);
>  
>  	/*
> -	 * If the new process will be in a different pid namespace
> -	 * don't allow the creation of threads.
> +	 * --------------  COMMENT -----------------
>  	 */
> -	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
> -	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
> -		return ERR_PTR(-EINVAL);
> +	if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
> +		if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
> +		    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
> +			return -EINVAL;
                                ^^^^^^

should be ERR_PTR(-EINVAL)

Oleg.

