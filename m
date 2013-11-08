Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3KHRV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:21:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab3KHRV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:21:26 -0500
Date: Fri, 8 Nov 2013 18:22:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Christian Seiler <christian@iwakd.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
Message-ID: <20131108172240.GA29979@redhat.com>
References: <20131106180232.GA8980@ac100> <20131106193311.GA18720@redhat.com> <87vc05jgak.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc05jgak.fsf@tw-ebiederman.twitter.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06, Eric W. Biederman wrote:
>
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1174,7 +1174,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>          * do not allow it to share a thread group or signal handlers or
>          * parent with the forking task.
>          */
> -       if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
> +       if (clone_flags & (CLONE_SIGHAND)) {
>                 if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
>                     (task_active_pid_ns(current) !=
>                                 current->nsproxy->pid_ns_for_children))

OK, agreed. I failed to find any problem with CLONE_PARENT with
CLONE_NEWUSER or after setns. And the main point of 40a0d32d1eaf
was "make them consistent", not "tighten up".

Besides, this doesn't differ too much from setns + fork() && exit(),
the grandchild will have the new namespace and reparented.

Acked-by: Oleg Nesterov <oleg@redhat.com>

> Changing the CLONE_SIGHAND into CLONE_THREAD will need to happen in a
> separate patch.  It isn't stable material, and so far there is no
> compelling use case for it.

Yes. Again, 40a0d32d1eaf chose CLONE_SIGHAND to unify CLONE_NEWUSER/setns
cases, copy_process() used this check. And in fact I voted for CLONE_THREAD
from the very beginning, it was you who suggested to use CLONE_SIGHAND
instead ;) OTOH, it was probably right to not relax the restrictions we
already had.

Oleg.

