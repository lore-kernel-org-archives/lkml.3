Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965994Ab3DQHrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:47:00 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:59722 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965879Ab3DQHq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:46:58 -0400
Date: Wed, 17 Apr 2013 09:46:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch -v4 1/4] Migrate shutdown/reboot to boot cpu.
Message-ID: <20130417074653.GA31607@gmail.com>
References: <20130416095827.GJ3672@sgi.com>
 <20130416113256.GA10452@gmail.com>
 <20130416120624.GO3658@sgi.com>
 <20130416140101.GS3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416140101.GS3658@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> > 		reboot_cpu_id = cpumask_first(cpu_online_mask);
> > 
> > > Also, does this codepath prevent hotplug from going on in parallel?
> > 
> > Not sure.  I have not considered hotplug.  I will look that over when I
> > am in the office.
> 
> OK.  I have been mulling this over for a bit and I don't think I
> understand what you are asking.

Well, I just saw the apparently naked use of cpu_online_mask, and asked myself 
whether that's safe against hotplug.

Upstream we had two methods:

 - historical: just reboot on any random CPU we happen to run on
 - current: offline all nonboot CPUs then reboot on the boot CPU

Both methods were implicitly "CPU hotplug safe", no locking needed, because either 
they didn't need any, or because it used disable_nonboot_cpus() which is a hotplug 
safe method.

Now your patches change this to:

 - migrate to CPU#0 [if possible] and reboot there

Given that on a system CPU-hotplugging might be executing on any given CPU, if 
reboot is running on another you have to consider the interactions. The previous 
historic and current upstream method was reasonably hotplug safe - yours I'm not 
sure about, there's just no hotplug locking in it, etc?

> I would expect that if an architecture depends upon a certain cpu for 
> shutdown/reboot/halt/suspend/hibernate and that support has been compiled in, 
> then the arch should be preventing that cpu from being removed. I do not know 
> how that would work and think that is far beyond the scope of the initial 
> problem I have been trying to solve.  If that is your question, I certainly do 
> not know how to address it.  I get the feeling this is off your mark due to the 
> "parallel" wording above.

What you mention here should indeed already be handled by the architecture hotplug 
code (for example on x86 the boot CPU cannot be hot-removed).

But beyond that, your use of cpu_online_map is AFAICS not hotplug-safe. For 
example a possible race would be that another CPU might be not-unplugging a CPU 
and you try to reboot-migrate to it.

Thanks,

	Ingo
