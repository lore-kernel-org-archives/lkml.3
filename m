Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbaKUNNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:13:18 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46415 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaKUNNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:13:16 -0500
Message-ID: <546F3A5C.3010604@linux.vnet.ibm.com>
Date: Fri, 21 Nov 2014 18:43:00 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
CC: mikey@neuling.org, james.hogan@imgtec.com, avagin@openvz.org,
        Paul.Clothier@imgtec.com, peterz@infradead.org, palves@redhat.com,
        oleg@redhat.com, davem@davemloft.net, dhowells@redhat.com,
        davej@redhat.com, akpm@linux-foundation.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de,
        sam.bobroff@au1.ibm.com
Subject: Re: [PATCH V4 2/8] powerpc, process: Add functions flush_tm_state,
 flush_tmregs_to_thread
References: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com> <1415683597-22819-3-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1415683597-22819-3-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112113-0029-0000-0000-000000A5913A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 10:56 AM, Anshuman Khandual wrote:
> This patch creates a new function called flush_tm_state to flush
> the existing transactional memory state from the thread. It also
> creates a function called flush_tmregs_to_thread which will then
> be used on subsequent patches in this series.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/switch_to.h |  8 ++++++
>  arch/powerpc/kernel/process.c        | 49 +++++++++++++++++++++++++++++-------
>  2 files changed, 48 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
> index 58abeda..23752a9 100644
> --- a/arch/powerpc/include/asm/switch_to.h
> +++ b/arch/powerpc/include/asm/switch_to.h
> @@ -82,6 +82,14 @@ static inline void flush_spe_to_thread(struct task_struct *t)
>  }
>  #endif
>  
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +extern void flush_tmregs_to_thread(struct task_struct *);
> +#else
> +static inline void flush_tmregs_to_thread(struct task_struct *t)
> +{
> +}
> +#endif
> +
>  static inline void clear_task_ebb(struct task_struct *t)
>  {
>  #ifdef CONFIG_PPC_BOOK3S_64
> diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
> index aa1df89..c36477b 100644
> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -745,6 +745,45 @@ void restore_tm_state(struct pt_regs *regs)
>  #define __switch_to_tm(prev)
>  #endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
>  
> +/*
> + * flush_tm_state
> + *
> + * Flush TM state out so we can copy it.  __switch_to_tm() does this
> + * flush but it removes the checkpointed state from the current CPU and
> + * transitions the CPU out of TM mode.  Hence we need to call
> + * tm_recheckpoint_new_task() (on the same task) to restore the
> + * checkpointed state back and the TM mode.
> + */
> +static void flush_tm_state(struct task_struct *src)
> +{
> +	__switch_to_tm(src);
> +	tm_recheckpoint_new_task(src);
> +}
> +
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +void flush_tmregs_to_thread(struct task_struct *tsk)
> +{
> +	/*
> +	 * If task is not current, it should have been flushed
> +	 * already to it's thread_struct during __switch_to().
> +	 */
> +	if (tsk != current)
> +		return;

As of now, ptrace does not support process self tracing. So here in this
function we really dont have to do anything if current and tsk does not
match each other. In case they match, we will just post one warning (as
ptrace generic code should have prevented this from happening) and move
on. Will make this function very simple like the following and remove
the next patch as well which was created because of this patch.

#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
void flush_tmregs_to_thread(struct task_struct *tsk)
{
	/*
	 * Self tracing is not yet supported through ptrace
	 * interface. Warn here if attempted.
	 */

	WARN_ON(tsk == current);
	return;
}
#endif

