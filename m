Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbaAURKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:10:10 -0500
Received: from science.horizon.com ([71.41.210.146]:55277 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754466AbaAURKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:10:08 -0500
Date: 21 Jan 2014 12:10:04 -0500
Message-ID: <20140121171004.7023.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, nate@thatsmathematics.com
Subject: Re: math_state_restore and kernel_fpu_end disable interrupts?
Cc: adilger@dilger.ca, arjan@linux.intel.com, jack@suse.cz,
        linux-kernel@vger.kernel.org, maarten-baert@hotmail.com, mingo@elte.hu,
        sbsiddha@gmail.com, tglx@linutronix.de, viro@zeniv.linux.org.uk
In-Reply-To: <alpine.DEB.2.10.1401201915250.2663@minerva.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nate Eldredge wrote:
> On Sun, 19 Jan 2014, George Spelvin wrote:
>>> It's credited to Suresh Siddha, whom I've cc'ed (along with others who
>>> signed off).  Suresh, if you're still around, could you comment on why
>>> math_state_restore always leaves interrupts disabled, regardless of their
>>> state on entry?  Is there a deep reason or is it a bug?
>>
>> What the comments seemed to be implying was that it was a bug to enter
>> this code with interrupts enabled.  So the problem may be a little bit
>> more systemic; expert counsel is required.
>
> It would be kind of weird for code that requires disabled interrupts on 
> entry to turn around and enable interrupts itself.  I agree that it would 
> really help for a guru to take a look...

Actually, on second look, it appears the comments are just confused.
Suresh's patch appears to have just failed to consider the possibility
of calling math_state_restore with interrupts enabled, rather than
having made a deliberate choice.

> On which note, Suresh's email bounced :-(

I found a newer address.  Let's see if this works.  Suresh, here's
Nate's proposed patch:

--- linux-source-3.11.0/arch/x86/kernel/traps.c	2013-09-02 14:46:10.000000000 -0600
+++ linux-source-3.11.0-nate/arch/x86/kernel/traps.c	2014-01-19 11:25:32.977221476 -0700
@@ -624,6 +624,9 @@ asmlinkage void math_state_restore(void)
  	struct task_struct *tsk = current;

  	if (!tsk_used_math(tsk)) {
+		unsigned long flags;
+
+		local_save_flags(flags);
  		local_irq_enable();
  		/*
  		 * does a slab alloc which can sleep
@@ -635,7 +638,7 @@
  			do_group_exit(SIGKILL);
  			return;
  		}
-		local_irq_disable();
+		local_irq_restore(flags);
  	}

  	__thread_fpu_begin(tsk);


BTW, my test case to reliably trigger the fault is Firefox crashing.
It usually takes a few days for it to run out of memory.  It happened
once, with no problem, but I'd like to get one more before passing
judgement.  Still, feel free to consider this:

Tested-by: George Spelvin <linux@horizon.com>

It's the
Cc: <stable@vger.kernel.org> # 2.6.26+
I'm a bit anxious about.
