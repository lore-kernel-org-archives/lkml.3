Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3GFFsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 01:48:05 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42249 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3GFFsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 01:48:03 -0400
Date: Sat, 6 Jul 2013 13:45:53 +0800
From: Wang YanQing <udknight@gmail.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
        deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, rostedt@goodmis.org,
        miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, tglx@linutronix.de,
        lig.fnst@cn.fujitsu.com, anton@samba.org
Subject: Re: [PATCH 3/3] smp/ipi:Remove check around csd lock in handler for
 smp_call_function variants
Message-ID: <20130706054552.GA2929@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Preeti U Murthy <preeti@linux.vnet.ibm.com>,
	xiaoguangrong@cn.fujitsu.com, mingo@elte.hu,
	paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	a.p.zijlstra@chello.nl, npiggin@suse.de, deepthi@linux.vnet.ibm.com,
	peterz@infradead.org, rusty@rustcorp.com.au,
	heiko.carstens@de.ibm.com, rostedt@goodmis.org, miltonm@bga.com,
	srivatsa.bhat@linux.vnet.ibm.com, jens.axboe@oracle.com,
	tj@kernel.org, akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
	shli@kernel.org, tglx@linutronix.de, lig.fnst@cn.fujitsu.com,
	anton@samba.org
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
 <20130705162720.16888.81958.stgit@preeti.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130705162720.16888.81958.stgit@preeti.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 09:57:21PM +0530, Preeti U Murthy wrote:
> call_single_data is always locked by all callers of
> arch_send_call_function_single_ipi() or
> arch_send_call_function_ipi_mask() which results in execution of
> generic_call_function_interrupt() handler.
> 
> Hence remove the check for lock on csd in generic_call_function_interrupt()
> handler, before unlocking it.

I can't find where is the generic_call_function_interrupt :)

> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> Cc: srivatsa.bhat@linux.vnet.ibm.com
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au
> ---
> 
>  kernel/smp.c |   14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index b6981ae..d37581a 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -181,25 +181,13 @@ void generic_smp_call_function_single_interrupt(void)
>  
>  	while (!list_empty(&list)) {
>  		struct call_single_data *csd;
> -		unsigned int csd_flags;
>  
>  		csd = list_entry(list.next, struct call_single_data, list);
>  		list_del(&csd->list);
>  
> -		/*
> -		 * 'csd' can be invalid after this call if flags == 0
> -		 * (when called through generic_exec_single()),
> -		 * so save them away before making the call:
> -		 */
> -		csd_flags = csd->flags;
> -

You haven't mention this change in the ChangeLog, don't do it.
I can't see any harm to remove csd_flags, but I hope others
check it again.

>  		csd->func(csd->info);
>  
> -		/*
> -		 * Unlocked CSDs are valid through generic_exec_single():
> -		 */
> -		if (csd_flags & CSD_FLAG_LOCK)
> -			csd_unlock(csd);
> +		csd_unlock(csd);

I don't like this change, I think check CSD_FLAG_LOCK 
to make sure we really need csd_unlock is good.

Just like you can't know who and how people will use the
API, so some robust check code is good.
