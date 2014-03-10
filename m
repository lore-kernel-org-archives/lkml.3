Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaCJQrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:47:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48891 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaCJQrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:47:16 -0400
Message-ID: <531DEC40.4060801@zytor.com>
Date: Mon, 10 Mar 2014 09:45:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org
CC: x86@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xen.org
Subject: Re: [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 09:17 AM, David Vrabel wrote:
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 57409f6..c8078d2 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -624,18 +624,13 @@ void math_state_restore(void)
>  	struct task_struct *tsk = current;
>  
>  	if (!tsk_used_math(tsk)) {
> -		local_irq_enable();
> -		/*
> -		 * does a slab alloc which can sleep
> -		 */
> -		if (init_fpu(tsk)) {
> +		if (init_fpu(tsk, GFP_ATOMIC)) {
>  			/*
>  			 * ran out of memory!
>  			 */
> -			do_group_exit(SIGKILL);
> +			force_sig(SIGKILL, tsk);
>  			return;
>  		}
> -		local_irq_disable();
>  	}
>  

OK, answering my own question... you're randomly SIGKILLing processes
because the kernel doesn't have enough memory on hand.

In other words, because Xen is broken you want to break the rest of the
universe.

This is NAKed so hard it isn't even funny.

	-hpa


