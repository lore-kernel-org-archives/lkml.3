Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3LSQCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:02:17 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:33115 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3LSQCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:02:14 -0500
Date: Thu, 19 Dec 2013 17:02:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>, x86@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power
 regression
Message-ID: <20131219160210.GA28426@gmail.com>
References: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
 <20131219122257.GC11279@gmail.com>
 <52B316FF.50906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B316FF.50906@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 12/19/2013 04:22 AM, Ingo Molnar wrote:
> >> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> >> index 92d1206..f80b700 100644
> >> --- a/drivers/idle/intel_idle.c
> >> +++ b/drivers/idle/intel_idle.c
> >> @@ -377,6 +377,9 @@ static int intel_idle(struct cpuidle_device *dev,
> >>  
> >>  	if (!current_set_polling_and_test()) {
> >>  
> >> +		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
> >> +			clflush((void *)&current_thread_info()->flags);
> >> +
> >>  		__monitor((void *)&current_thread_info()->flags, 0, 0);
> > 
> > I don't think either of these casts to '(void *)' is needed, both the 
> > clflush() and __monitor() will take pointers.
> 
> __monitor() currently doesn't, which is idiotic.

Hm, __monitor() seems to take a void *:

 arch/x86/include/asm/processor.h:static inline void __monitor(const void *eax, unsigned long ecx,

So writing:

		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
			clflush(&current_thread_info()->flags);

  		__monitor(&current_thread_info()->flags, 0, 0);

ought to work just fine.

Thanks,

	Ingo
