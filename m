Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaI1DiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 23:38:25 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:46963 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaI1DiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 23:38:24 -0400
Message-ID: <1411875493.2029.78.camel@cyc>
Subject: Re: [PATCH] x86, MCE: support raising machine check poll for
 software MCE injection in IRQ context
From: Chen Yucong <slaoub@gmail.com>
To: gong.chen@linux.intel.com
Cc: andi@firstfloor.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Luck, Tony" <tony.luck@intel.com>
Date: Sun, 28 Sep 2014 11:38:13 +0800
In-Reply-To: <1407847544-13224-1-git-send-email-slaoub@gmail.com>
References: <1407847544-13224-1-git-send-email-slaoub@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-12 at 20:45 +0800, Chen Yucong wrote:
> At present MCJ_NMI_BROADCAST(same for raise_local) supports both raise_exception()
> and raise_poll(), but MCJ_IRQ_BROADCAST only supports raise_exception(). The goal
> of this patch is that MCJ_IRQ_BROADCAST can support raising machine check poll.
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce-inject.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> index 5ac2d1f..97e4f7a 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> @@ -99,11 +99,13 @@ static void mce_irq_ipi(void *info)
>  	int cpu = smp_processor_id();
>  	struct mce *m = &__get_cpu_var(injectm);
>  
> -	if (cpumask_test_cpu(cpu, mce_inject_cpumask) &&
> -			m->inject_flags & MCJ_EXCEPTION) {
> -		cpumask_clear_cpu(cpu, mce_inject_cpumask);
> +	if (!cpumask_test_cpu(cpu, mce_inject_cpumask))
> +		return;
> +	cpumask_clear_cpu(cpu, mce_inject_cpumask);
> +	if (m->inject_flags & MCJ_EXCEPTION)
>  		raise_exception(m, NULL);
> -	}
> +	else if (m->status)
> +		raise_poll(m);
>  }
>  
>  /* Inject mce on current CPU */

Hi Chen Gong,

Can you review the above patch?

thx!
cyc 

