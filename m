Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaELEzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 00:55:05 -0400
Received: from smtprelay.synopsys.com ([198.182.44.111]:45552 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaELEzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 00:55:02 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.14 27/83] ARC: !PREEMPT: Ensure Return to kernel mode
 is IRQ safe
Thread-Topic: [PATCH 3.14 27/83] ARC: !PREEMPT: Ensure Return to kernel mode
 is IRQ safe
Thread-Index: AQHPbU47yytuy3hXuUeTWrS5w+roug==
Date: Mon, 12 May 2014 04:54:56 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751A6AC711@IN01WEMBXA.internal.synopsys.com>
References: <20140511191907.024339448@linuxfoundation.org>
 <20140511191910.756830473@linuxfoundation.org>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 12 May 2014 12:51 AM, Greg Kroah-Hartman wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
>
> commit 8aa9e85adac609588eeec356e5a85059b3b819ba upstream.

Hi Greg,

This one was also marked for stable 3.10 however because the 2 pre-req patches
were not in yet, applying it would have failed and AFAIKR I did describe the state
of things in that failure report. Anyhow can you please queue this one up for the
next 3.10 stable.

Thx,
-Vineet

>
> There was a very small race window where resume to kernel mode from a
> Exception Path (or pure kernel mode which is true for most of ARC
> exceptions anyways), was not disabling interrupts in restore_regs,
> clobbering the exception regs
>
> Anton found the culprit call flow (after many sleepless nights)
>
> | 1. we got a Trap from user land
> | 2. started to service it.
> | 3. While doing some stuff on user-land memory (I think it is padzero()),
> |     we got a DataTlbMiss
> | 4. On return from it we are taking "resume_kernel_mode" path
> | 5. NEED_RESHED is not set, so we go to "return from exception" path in
> |     restore regs.
> | 6. there seems to be IRQ happening
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Anton Kolesov <Anton.Kolesov@synopsys.com>
> Cc: Francois Bedard <Francois.Bedard@synopsys.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  arch/arc/kernel/entry.S |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> --- a/arch/arc/kernel/entry.S
> +++ b/arch/arc/kernel/entry.S
> @@ -614,11 +614,13 @@ resume_user_mode_begin:
>  
>  resume_kernel_mode:
>  
> -#ifdef CONFIG_PREEMPT
> -
> -	; This is a must for preempt_schedule_irq()
> +	; Disable Interrupts from this point on
> +	; CONFIG_PREEMPT: This is a must for preempt_schedule_irq()
> +	; !CONFIG_PREEMPT: To ensure restore_regs is intr safe
>  	IRQ_DISABLE	r9
>  
> +#ifdef CONFIG_PREEMPT
> +
>  	; Can't preempt if preemption disabled
>  	GET_CURR_THR_INFO_FROM_SP   r10
>  	ld  r8, [r10, THREAD_INFO_PREEMPT_COUNT]
>
>
>

