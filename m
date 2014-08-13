Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaHMQVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:21:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbaHMQVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:21:35 -0400
Date: Wed, 13 Aug 2014 18:19:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] fix sighand use after free
Message-ID: <20140813161909.GA3479@redhat.com>
References: <20140813115000.73da6136@cuia.bos.redhat.com> <20140813155802.GA2695@redhat.com> <53EB8DAC.1040605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EB8DAC.1040605@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Rik van Riel wrote:
>
> On 08/13/2014 11:58 AM, Oleg Nesterov wrote:
> > On 08/13, Rik van Riel wrote:
> >>
> >> @@ -1017,7 +1017,7 @@ void __cleanup_sighand(struct sighand_struct *sighand)
> >>  {
> >>  	if (atomic_dec_and_test(&sighand->count)) {
> >>  		signalfd_cleanup(sighand);
> >> -		kmem_cache_free(sighand_cachep, sighand);
> >> +		rcu_free(sighand_cachep, sighand);
> >
> > Please note that sighand_cachep is SLAB_DESTROY_BY_RCU.
>
> SLAB_DESTROY_BY_RCU means that the slab page is not given
> back to the system until after the RCU grace period has
> expired.
>
> However, the objects inside the slab can still be reused
> immediately!

Yes. This is fine. This memory won't be returned to system before rcu
gp pass, and this memory is still "struct sighand_struct" with the
properly initialized ->siglock (note the sighand_ctor()).

> In the case of the sighand struct, we have this possible race:
>
>      thread A       thread B              thread C
>
>                     gets task A->sighand
>      kmem_cache_free sighand
>                                           re-alloc sighand
>                     spin_lock sighand
>                                           spin_lock_init sighand
                                            ^^^^^^^^^^^^^^^^^^^^^^
see below,

>                     spin_unlock sighand
>
> Now task C has a sighand which can never be locked.

No, please see above. And that is why lock_task_sighand() (which in
turn needs the comment and cleanup, I already have a patch) re-checks
task-sighand with ->siglock.

> > Hmm. and what is rcu_free() ?
>
> Ugh, that should have been kfree_rcu of course, with
> appropriate rcu space in the struct.

kfree_rcu() can't work in this case, __rcu_reclaim() does kfree() but
we need kmem_cache_free().

Oleg.

