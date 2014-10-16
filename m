Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbaJPHa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:30:56 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60204 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaJPHaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:30:55 -0400
Date: Thu, 16 Oct 2014 09:30:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com, tianyu.lan@intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH] xen/smp: Use die_complete completion when taking CPU down
Message-ID: <20141016073048.GA19055@gmail.com>
References: <1413384910-1231-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413384910-1231-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Boris Ostrovsky <boris.ostrovsky@oracle.com> wrote:

> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 8650cdb..4da0008 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -498,6 +498,7 @@ static int xen_cpu_disable(void)
>  	if (cpu == 0)
>  		return -EBUSY;
>  
> +	init_completion(&per_cpu(die_complete, smp_processor_id()));
>  	cpu_disable_common();
>  
>  	load_cr3(swapper_pg_dir);
> @@ -510,6 +511,9 @@ static void xen_cpu_die(unsigned int cpu)
>  		current->state = TASK_UNINTERRUPTIBLE;
>  		schedule_timeout(HZ/10);
>  	}
> +
> +	wait_for_completion_timeout(&per_cpu(die_complete, cpu), HZ);
> +
>  	xen_smp_intr_free(cpu);
>  	xen_uninit_lock_cpu(cpu);
>  	xen_teardown_timer(cpu);

So why not put it into cpu_disable_common() and do the same 
change for native_cpu_disable()?

Likewise, the waiting bit should be put into a common function as 
well (newly introduced, if need to be), we don't want to expose 
internal x86 core data structures to the Xen guest code.

Thanks,

	Ingo
