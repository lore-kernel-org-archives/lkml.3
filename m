Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaCGXTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:19:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41891 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbaCGXTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:19:13 -0500
Message-ID: <531A53CF.2000604@zytor.com>
Date: Fri, 07 Mar 2014 15:18:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: sbsiddha@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
CC: Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt
 flag
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>	 <CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>	 <CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>	 <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>	 <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com> <1391325599.6481.5.camel@europa> <530FCDD6.3060701@zytor.com>
In-Reply-To: <530FCDD6.3060701@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh,

Any thoughts on this?

	-hpa

On 02/27/2014 03:44 PM, H. Peter Anvin wrote:
> So, picking up this thread which got dropped on the floor...
> 
> On 02/01/2014 11:19 PM, Suresh Siddha wrote:
>>
>> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
>> index e8368c6..4e5f770 100644
>> --- a/arch/x86/kernel/i387.c
>> +++ b/arch/x86/kernel/i387.c
>> @@ -5,6 +5,7 @@
>>   *  General FPU state handling cleanups
>>   *	Gareth Hughes <gareth@valinux.com>, May 2000
>>   */
>> +#include <linux/bootmem.h>
>>  #include <linux/module.h>
>>  #include <linux/regset.h>
>>  #include <linux/sched.h>
>> @@ -186,6 +187,10 @@ void fpu_init(void)
>>  	if (xstate_size == 0)
>>  		init_thread_xstate();
>>  
>> +	if (!current->thread.fpu.state)
>> +		current->thread.fpu.state =
>> +			alloc_bootmem_align(xstate_size, __alignof__(struct xsave_struct));
>> +
>>  	mxcsr_feature_mask_init();
>>  	xsave_init();
>>  	eager_fpu_init();
> 
> So this bit is giving me a bit of a headache, specifically
> alloc_bootmem_align() is an __init function and fpu_init() obviously isn't.
> 
> I am doubly confused because init_thread_xstate() only sets the xstate
> without any XSAVE features, so the memory allocation we get there will
> be insufficient later -- in fact, only a few lines further down the
> function, when xsave_init() is called.
> 
> I'm wondering if we could put this somewhere inside
> xstate_enable_boot_cpu() instead, maybe?
> 
> I'm assuming the reason you didn't want to in eager_fpu_init_bp()
> anymore is because you want the allocation to happen regardless of if
> eagerfpu is enabled, correct?
> 
> 	-hpa
> 
> 

