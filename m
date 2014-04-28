Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbaD1VjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:39:16 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52623 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbaD1VjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:39:14 -0400
Date: Mon, 28 Apr 2014 14:39:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Richard Weinberger <richard@nod.at>
Cc: Randy Dunlap <rdunlap@infradead.org>, Rik van Riel <riel@redhat.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, umgwanakikbuti@gmail.com
Subject: Re: mmotm 2014-04-24-13-07 uploaded
Message-ID: <20140428213909.GA16623@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140424200837.727695A407C@corp2gmr1-2.hot.corp.google.com>
 <535992DD.3060808@infradead.org>
 <20140425100459.7824f676@annuminas.surriel.com>
 <535AC91A.1070504@infradead.org>
 <535ACB0E.4070600@infradead.org>
 <20140427062650.GW4496@linux.vnet.ibm.com>
 <20140428135540.GA14661@linux.vnet.ibm.com>
 <535E8D14.7080405@infradead.org>
 <535E8E17.2050600@nod.at>
 <20140428200640.GG4430@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428200640.GG4430@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042821-1542-0000-0000-0000016912EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 01:06:40PM -0700, Paul E. McKenney wrote:
> On Mon, Apr 28, 2014 at 07:21:27PM +0200, Richard Weinberger wrote:
> > Am 28.04.2014 19:17, schrieb Randy Dunlap:
> > > 
> > > uml defconfig on x86_64:
> > > 
> > >   CC      arch/um/kernel/asm-offsets.s
> > > In file included from include/linux/sem.h:5:0,
> > >                  from include/linux/sched.h:35,
> > >                  from arch/x86/um/shared/sysdep/kernel-offsets.h:2,
> > >                  from arch/um/kernel/asm-offsets.c:1:
> > > include/linux/rcupdate.h:257:20: error: static declaration of 'rcu_sysrq_start' follows non-static declaration
> > > include/linux/rcupdate.h:250:6: note: previous declaration of 'rcu_sysrq_start' was here
> > > include/linux/rcupdate.h:260:20: error: static declaration of 'rcu_sysrq_end' follows non-static declaration
> > > include/linux/rcupdate.h:251:6: note: previous declaration of 'rcu_sysrq_end' was here
> > > make[2]: *** [arch/um/kernel/asm-offsets.s] Error 1
> > > 
> > > 
> > > Please test your patch(es).
> 
> Against exactly what?  ;-)
> 
> > Just in case, to build an x86_64 UML please run:
> > 
> > make defconfig ARCH=um SUBARCH=x86_64
> > make linux ARCH=um SUBARCH=x86_64
> 
> Hmmm....  Builds without errors in my local tree.
> 
> Make a clone of linux-next...
> 
> OK, now I get a different build failure:
> 
> /home/paulmck/public_git/linux-next/drivers/tty/sysrq.c:514: undefined reference to `rcu_sysrq_start'
> /home/paulmck/public_git/linux-next/drivers/tty/sysrq.c:558: undefined reference to `rcu_sysrq_end'
> 
> This is due to Rik's "#include <linux/rcupdate.h>" getting lost somehow.
> This #include is needed in drivers/tty/sysrq.c.
> 
> But maybe I need to be using some other branch of linux-next.  Am currently
> on 5bd4e10b96ce20271688aa31d8bd739441249152, which is origin/master.  And
> is also next-20140428.  If I should be somewhere else, please let me know.
> 
> OK, it also appears that my change to make TINY_RCU work is also missing,
> possibly because Randy applied it by hand.
> 
> Please see below for a patch against next-20140428 that makes this build
> for me.  This is derived from Rik's patch, my patch, and is consistent with
> Arnd's patch.

Hmmm...  It also seems to have recently become illegal to not have
a root partition.  It looks like rootfstype=ramfs and rootfstype=tmpfs
should avoid this, but no luck with these thus far.

The purpose of this is to run the kernel entirely within the confines
of initramfs, as has been possible for quite a few years.

Any hints?

							Thanx, Paul

> ------------------------------------------------------------------------
> 
> diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
> index 6c3d11b..38d5f9a 100644
> --- a/drivers/tty/sysrq.c
> +++ b/drivers/tty/sysrq.c
> @@ -46,6 +46,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/syscalls.h>
>  #include <linux/of.h>
> +#include <linux/rcupdate.h>
>  
>  #include <asm/ptrace.h>
>  #include <asm/irq_regs.h>
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index e9cc71c..7b0a669 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -247,8 +247,17 @@ void rcu_idle_enter(void);
>  void rcu_idle_exit(void);
>  void rcu_irq_enter(void);
>  void rcu_irq_exit(void);
> +#ifdef CONFIG_RCU_STALL_COMMON
>  void rcu_sysrq_start(void);
>  void rcu_sysrq_end(void);
> +#else /* #ifdef CONFIG_RCU_STALL_COMMON */
> +static inline void rcu_sysrq_start(void)
> +{
> +}
> +static inline void rcu_sysrq_end(void)
> +{
> +}
> +#endif /* #else #ifdef CONFIG_RCU_STALL_COMMON */
>  
>  #ifdef CONFIG_RCU_USER_QS
>  void rcu_user_enter(void);
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index 20caaf0..a2aeb4d 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -322,7 +322,8 @@ int rcu_jiffies_till_stall_check(void)
>  
>  void rcu_sysrq_start(void)
>  {
> -	rcu_cpu_stall_suppress = 2;
> +	if (!rcu_cpu_stall_suppress)
> +		rcu_cpu_stall_suppress = 2;
>  }
>  
>  void rcu_sysrq_end(void)

