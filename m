Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaFFTJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 15:09:10 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:13054 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbaFFTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 15:08:51 -0400
Message-ID: <1402081726.6680.61.camel@j-VirtualBox>
Subject: Re: [PATCH 1/2] locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, mpatocka@redhat.com,
        torvalds@linux-foundation.org, waiman.long@hp.com,
        jejb@parisc-linux.org, paulmck@linux.vnet.ibm.com,
        dave.anglin@bell.net, aswin@hp.com, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Date: Fri, 06 Jun 2014 12:08:46 -0700
In-Reply-To: <1402080497.14433.8.camel@buesod1.americas.hpqcorp.net>
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
	 <1402070140-15090-2-git-send-email-davidlohr@hp.com>
	 <1402074788.6680.50.camel@j-VirtualBox>
	 <1402078358.14433.3.camel@buesod1.americas.hpqcorp.net>
	 <1402080497.14433.8.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 11:48 -0700, Davidlohr Bueso wrote:
> On Fri, 2014-06-06 at 11:12 -0700, Davidlohr Bueso wrote:
> > On Fri, 2014-06-06 at 10:13 -0700, Jason Low wrote:
> > > On Fri, 2014-06-06 at 08:55 -0700, Davidlohr Bueso wrote:
> > > > Just like with mutexes (CONFIG_MUTEX_SPIN_ON_OWNER),
> > > > encapsulate the dependencies for rwsem optimistic spinning.
> > > > No logical changes here as it continues to depend on both
> > > > SMP and the XADD algorithm variant.
> > > > 
> > > > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > > > ---
> > > >  include/linux/rwsem.h  | 4 ++--
> > > >  kernel/Kconfig.locks   | 4 ++++
> > > >  kernel/locking/rwsem.c | 2 +-
> > > >  3 files changed, 7 insertions(+), 3 deletions(-)
> > > 
> > > Do we also want to add an #ifdef CONFIG_RWSEM_SPIN_ON_OWNER in
> > > __init_rwsem() and in the optimistic spinning functions for rwsem-xadd?
> > > 
> > 
> > Not really, as we conditionally build rwsem-xadd.o based on
> > CONFIG_RWSEM_XCHGADD_ALGORITHM:
> > 
> > obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
> > obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
> > 
> > So leaving just SMP is ok there.
> 
> Of course that's bogus when we add more dependencies (ie 2/2), so yeah,
> we need to add the whole CONFIG_RWSEM_SPIN_ON_OWNER option.
> 
> Thanks.

> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> index dacc321..f6b5b96 100644
> --- a/kernel/locking/rwsem-xadd.c
> +++ b/kernel/locking/rwsem-xadd.c
> @@ -82,7 +82,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
>  	sem->count = RWSEM_UNLOCKED_VALUE;
>  	raw_spin_lock_init(&sem->wait_lock);
>  	INIT_LIST_HEAD(&sem->wait_list);
> -#ifdef CONFIG_SMP
> +#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
>  	sem->owner = NULL;
>  	sem->osq = NULL;
>  #endif

And should we also change that in the optimistic spinning functions so
that it defaults to:

	static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
	{
        	return false;
	}

in the !CONFIG_RWSEM_SPIN_ON_OWNER case.

Thanks.

> diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
> index 42f806d..e2d3bc7 100644
> --- a/kernel/locking/rwsem.c
> +++ b/kernel/locking/rwsem.c
> @@ -12,7 +12,7 @@
>  
>  #include <linux/atomic.h>
>  
> -#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
> +#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
>  static inline void rwsem_set_owner(struct rw_semaphore *sem)
>  {
>  	sem->owner = current;


