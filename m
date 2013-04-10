Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965167Ab3DJXCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:02:40 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40147 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937392Ab3DJXCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:02:39 -0400
Date: Wed, 10 Apr 2013 18:02:35 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Robin Holt <holt@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130410230234.GB8112@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130403193743.GB29151@sgi.com>
 <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
 <20130408165916.GA3672@sgi.com>
 <20130410111620.GB29752@gmail.com>
 <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
 <20130410152911.GA3011@sgi.com>
 <20130410165934.GB21951@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410165934.GB21951@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 06:59:34PM +0200, Ingo Molnar wrote:
> * Russ Anderson <rja@sgi.com> wrote:
> 
> > Yes, I have a test patch that replaces for_each_online_cpu(cpu) with a cpu 
> > bitmask in disable_nonboot_cpus().  The lower level routines already take a 
> > bitmask.  It allows __stop_machine() to be called just once.  That change 
> > reduces shutdown time on a 1024 cpu machine from 16 minutes 4 minutes.  
> > Significant improvement, but not good enough.
> > 
> > The next significant bottleneck is __cpu_notify().  Tried creating worker 
> > threads to parallelize the shutdown, but the problem is __cpu_notify() is not 
> > thread safe.  Putting a lock around it caused all the worker threads to fight 
> > over the lock.
> 
> 4 minutes bootup is 240 seconds, with 1024 CPUs that's about 240 msecs per CPU.
> 
> That sounds a lot, given that unlike bootup there's not much real work to be done 
> during shutdown - we don't initialize anything, etc.
> 
> Maybe much of those 240 msecs are spent in some stupid udelay loop or so, which 
> could be made parallel?

I was hoping for a stupid udelay when I first started looking
at this code, but found nothing obvious.

The bulk of the time (after making the cpu bitmask change) is
spent in __cpu_notify(), as explained above.


> Would it be possible to create a 'reboot but stop at the end and reactivate all 
> CPUs again' reboot flag, so that it can all be NMI-profiled, to see where the true 
> bottleneck is? A naked disable_nonboot_cpus() call in essence.

My testing was similar.  I hacked a kernel module to call
disable_nonboot_cpus() and enable_nonboot_cpus() and used
printks to narrow down the slow functions.  That points
at the cpu notifier call chain.  It's not clear if any
of the functions on the call chain take a long time, or
just going sequentially through the list for all cpus just
takes a long time.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
