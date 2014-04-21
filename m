Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaDUQdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:33:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39456 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbaDUQdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:33:52 -0400
Message-ID: <53554846.3070608@zytor.com>
Date: Mon, 21 Apr 2014 09:33:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hui Zhu <teawater@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, eparis@redhat.com,
        ak@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "gdb@sourceware.org" <gdb@sourceware.org>
Subject: Re: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by
 GDB
References: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com>
In-Reply-To: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 09:19 AM, Hui Zhu wrote:
> }
> Now ax is in 32 bits now, need sign-extend to 64 bits.  But
> current_thread_info()->status TS_COMPAT is cleared when GDB call "call func1()".
> Linux kernel don't know this is a 32 bits task and will not extend it.
> Then -ERESTARTSYS is not be handled and go back to user space.
> 
> Then the syscall "read" get a errno in ERESTARTSYS.
> 
> To fix this issue, I tried to add a local variable to "do_signal" but
> it is not works.  The stack is cleared before GDB "continue".
> so I make a patch that add "test_thread_flag (TIF_IA32)" to syscall_get_error.
> 
> Signed-off-by: Hui Zhu <hui@codesourcery.com>
> ---
> --- a/arch/x86/include/asm/syscall.h
> +++ b/arch/x86/include/asm/syscall.h
> @@ -48,7 +48,8 @@ static inline long syscall_get_error(str
>   * TS_COMPAT is set for 32-bit syscall entries and then
>   * remains set until we return to user mode.
>   */
> - if (task_thread_info(task)->status & TS_COMPAT)
> + if ((task_thread_info(task)->status & TS_COMPAT)
> +    || test_thread_flag (TIF_IA32))
>   /*
>   * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
>   * and will match correctly in comparisons.
> 

No, this is definitely not the right fix.  Your description is
incredibly hard to follow, but I feel pretty strongly that the above is
at the very best a last resort fix.  TS_COMPAT is a local property
whereas TIF_IA32 is global; it is important to keep their respective
uses correct.  Mixing them is almost guaranteed to be just plain wrong.

	-hpa

