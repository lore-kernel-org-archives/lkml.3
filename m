Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab3LJVGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:06:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:30149 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab3LJVGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:06:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,866,1378882800"; 
   d="scan'208";a="450086043"
Message-ID: <1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: process 'stuck' at exit.
From: Darren Hart <dvhart@linux.intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Date: Tue, 10 Dec 2013 13:06:23 -0800
In-Reply-To: <20131210204925.GB27373@redhat.com>
References: <20131210154724.GA30020@redhat.com>
	 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	 <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 15:49 -0500, Dave Jones wrote:
> On Tue, Dec 10, 2013 at 09:35:59PM +0100, Oleg Nesterov wrote:
>  > Dave, I must have missed something, help.
>  > 
>  > I am looking at the first message and I can't understand who stuck
>  > "at exit".
>  > 
>  > The trace shows that the task with pid=10818 called sys_futex() ?
>  >
>  > Perhaps "exit" means the userspace paths?
> 
> pid 1131 is wait()'ing for 10818 to exit
> 
> pid 1130 is periodically sending SIGKILL to 10818 because it's gotten
> tired of waiting. 10818 is ignoring these because it's stuck in a loop
> somewhere in the kernel.
> 
> I tried attaching to 10818 with gdb, and it just hangs.
> (possibly because its weird stack situation [see 1st post])
> 
> by inspecting the shared mapping that all processes have (by gdb'ing 1130)
> I can see that 10818 did all its full run without incident, and the
> "exit child" flag in the fuzzer had been in set.
> 
> The last 'random syscall' the fuzzer did was to sys_accept4, so the futex call
> must come from somewhere in libc maybe ?

If that is the case, then Linus' requeue_pi path is highly unlikely as
FUTEX_CMP_REQUEUE_PI is not used by glibc (yet). That gives me hope as
that way there be dragons. Knowing exactly what syscall was made would
be very useful, but I don't know if that information is even available
anymore.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


