Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936955Ab3DJP3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:29:16 -0400
Received: from relay1.sgi.com ([192.48.179.29]:45588 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761199Ab3DJP3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:29:15 -0400
Date: Wed, 10 Apr 2013 10:29:12 -0500
From: Russ Anderson <rja@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Robin Holt <holt@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130410152911.GA3011@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130403193743.GB29151@sgi.com>
 <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
 <20130408165916.GA3672@sgi.com>
 <20130410111620.GB29752@gmail.com>
 <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 08:10:05AM -0700, Linus Torvalds wrote:
> On Wed, Apr 10, 2013 at 4:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > I think rebooting on the same CPU where we booted up is something worth having in
> > general, as a firmware robustness feature. (assuming the CPU in question is still
> > online)
> 
> Yeah, we've had issues with ACPI in the past, so I do think we should
> always reboot using the BP. Even if it almost certainly works on 99+%
> of all machines on any random CPU.
> 
> The optimal solution would be to just speed up the
> disable_nonboot_cpus() code so much that it isn't an issue. That would
> be good for suspending too, although I guess suspend isn't a big issue
> if you have a thousand CPU's.
> 
> Has anybody checked whether we could do the cpu_down() on non-boot
> CPU's in parallel? Right now we serialize the thing completely, with
> one single
> 
>     for_each_online_cpu(cpu) {
>         ...
> 
> loop that does a synchrinous _cpu_down() for each CPU. No wonder it
> takes forever. We do __stop_machine() over and over and over again:
> the whole thing is basically O(n**2) in CPU's.

Yes, I have a test patch that replaces for_each_online_cpu(cpu)
with a cpu bitmask in disable_nonboot_cpus().  The lower level
routines already take a bitmask.  It allows __stop_machine() to
be called just once.  That change reduces shutdown time on a
1024 cpu machine from 16 minutes 4 minutes.  Significant improvement,
but not good enough.

The next significant bottleneck is __cpu_notify().  Tried creating
worker threads to parallelize the shutdown, but the problem is
__cpu_notify() is not thread safe.  Putting a lock around it
caused all the worker threads to fight over the lock.

Note that __cpu_notify() has to be called for all cpus being
shut down because the cpu_chain notifier call chain has cpu as a
parameter.  The delema is that cpu_chain notifiers need to be called on
all cpus, but cannot be done in parallel due to __cpu_notify() not being
thread safe.  Spinning through the notifier chain sequentially for all
cpus just takes a long time.

The real fix would be to make the &cpu_chain notifier per cpu, or at
least thread safe, so that all the cpus being shut down could do so
in parallel.  That is a significant change with ramifications on
other code.

I will post a patch shortly with the cpu bitmask change.  Changing
__cpu_notify() will take more discussion.

>                         Linus

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
