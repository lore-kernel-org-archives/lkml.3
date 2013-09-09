Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3IIPVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:21:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab3IIPVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:21:42 -0400
Date: Mon, 9 Sep 2013 17:15:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: free_pid() && PIDNS_HASH_ADDING
Message-ID: <20130909151530.GA6755@redhat.com>
References: <20130829211114.GA20726@sergelap> <87mwo0xb9p.fsf@xmission.com> <20130830144232.GA18281@mail.hallyn.com> <87hae6vh0w.fsf_-_@xmission.com> <20130908175602.GA3172@redhat.com> <20130908180137.GA4915@redhat.com> <87bo43gg4h.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo43gg4h.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 09/08, Oleg Nesterov wrote:
> >>
> >> Off topic. What if the first alloc_pid() succeeds and then later
> >> copy_process() fails. In this case free_pid() is called but
> >> PIDNS_HASH_ADDING was not cleared, we miss kern_unmount(), no?
> >
> > Perhaps something like below?
>
> I am thinking more:
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index ab75add..ef59516 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -273,6 +273,10 @@ void free_pid(struct pid *pid)
>                          */
>                         wake_up_process(ns->child_reaper);
>                         break;
> +               case PIDNS_HASH_ADDING:
> +                       /* Handle a fork failure of the first process */
> +                       ns->nr_hashed = 0;

Agreed, it also makes sense to clear ->nr_hashed. But I still think
that WARN_ON(ns->child_reaper) makes sense too.

> At which point I ask myself what of the pathlogocical case where the
> first fork fails but because we created the pid namespace with unshare
> there is a concurrent fork from another process into the pid namespace
> that succeeds.  Resulting in one pid in the pid namespace that is not
> the reaper.

But how can setns() work before the first fork() succeeds and makes the
->child_reaper visible in /proc ?

Probably I missed something obvious, I didn't sleep today...

Oleg.

