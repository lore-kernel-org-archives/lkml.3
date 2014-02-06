Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaBFF03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 00:26:29 -0500
Received: from aurora.thatsmathematics.com ([162.209.10.89]:46099 "EHLO
	aurora.thatsmathematics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbaBFF01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 00:26:27 -0500
Date: Wed, 5 Feb 2014 22:26:24 -0700 (MST)
From: Nate Eldredge <nate@thatsmathematics.com>
X-X-Sender: nate@minerva.lan
To: Suresh Siddha <sbsiddha@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt
 flag
In-Reply-To: <1391410583.3801.6.camel@europa>
Message-ID: <alpine.DEB.2.10.1402052224200.2702@minerva.lan>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>  <CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>  <CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>  <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
  <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>  <1391325599.6481.5.camel@europa>  <CA+55aFzz8a7K+KSB_TkGb1ih1hAg09-0TQusQgE5vwMJGegHDw@mail.gmail.com> <1391410583.3801.6.camel@europa>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Feb 2014, Suresh Siddha wrote:

> Here is the second patch, which should fix the issue reported in this
> thread. Maarten, Nate, George, please give this patch a try as is and
> see if it helps address the issue you ran into. And please ack/review
> with your test results.

3.13 plus this patch: boots and fixes the testcase I reported (core dump 
on ecrypt).

Tested-by: Nate Eldredge <nate@thatsmathematics.com>

> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 4e5f770..670bba1 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -87,10 +87,19 @@ EXPORT_SYMBOL(__kernel_fpu_begin);
>
> void __kernel_fpu_end(void)
> {
> -	if (use_eager_fpu())
> -		math_state_restore();
> -	else
> +	if (use_eager_fpu()) {
> +		/*
> +		 * For eager fpu, most the time, tsk_used_math() is true.
> +		 * Restore the user math as we are done with the kernel usage.
> +		 * At few instances during thread exit, signal handling etc,
> +		 * tsk_used_math() is false. Those few places will take proper
> +		 * actions, so we don't need to restore the math here.
> +		 */
> +		if (likely(tsk_used_math(current)))
> +			math_state_restore();
> +	} else {
> 		stts();
> +	}
> }
> EXPORT_SYMBOL(__kernel_fpu_end);

-- 
Nate Eldredge
nate@thatsmathematics.com

