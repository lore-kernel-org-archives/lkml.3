Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaLIG0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:26:16 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:37891 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaLIG0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:26:15 -0500
Date: Tue, 9 Dec 2014 07:26:10 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softirq/preempt: add missing current->preempt_disable_ip
 update
Message-ID: <20141209062610.GC4362@osiris>
References: <20141124141619.GB3738@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124141619.GB3738@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120906-0009-0000-0000-0000024D7541
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 03:16:19PM +0100, Heiko Carstens wrote:
> While debugging some "sleeping function called from invalid context" bug I
> realized that the debug message "Preemption disabled at:" pointed to an
> incorrect function.
> In particular if the function/action that disabled preemption was
> spin_lock_bh() then current->preempt_disable_ip won't be updated.
> 
> The reason for this is that __local_bh_disable_ip() will increase
> preempt_count manually instead of calling preempt_count_add(), which
> would handle the update correctly.
> It look like the manual handling was done to work around some lockdep issue.
> 
> So add the missing update of current->preempt_disable_ip to
> __local_bh_disable_ip() as well.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  kernel/softirq.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 501baa9ac1be..edd51027e3ab 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -114,8 +114,13 @@ void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
>  		trace_softirqs_off(ip);
>  	raw_local_irq_restore(flags);
>  
> -	if (preempt_count() == cnt)
> -		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
> +	if (preempt_count() == cnt) {
> +		unsigned long ip = get_parent_ip(CALLER_ADDR1);
> +#ifdef CONFIG_DEBUG_PREEMPT
> +		current->preempt_disable_ip = ip;
> +#endif
> +		trace_preempt_off(CALLER_ADDR0, ip);
> +	}
>  }
>  EXPORT_SYMBOL(__local_bh_disable_ip);
>  #endif /* CONFIG_TRACE_IRQFLAGS */

*ping*

