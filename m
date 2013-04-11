Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab3DKVJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:09:03 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42757 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753808Ab3DKVI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:08:58 -0400
Date: Thu, 11 Apr 2013 16:08:55 -0500
From: Robin Holt <holt@sgi.com>
To: Russ Anderson <rja@sgi.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Robin Holt <holt@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Bulk CPU Hotplug (Was Re: [PATCH] Do not force shutdown/reboot
 to boot cpu.)
Message-ID: <20130411210855.GJ3658@sgi.com>
References: <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
 <20130408165916.GA3672@sgi.com>
 <20130410111620.GB29752@gmail.com>
 <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
 <20130411053106.GA9042@drongo>
 <5166B05E.8010904@linux.vnet.ibm.com>
 <20130411142301.GB27990@sgi.com>
 <5166CC87.5060301@linux.vnet.ibm.com>
 <20130411200820.GA10167@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411200820.GA10167@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 03:08:20PM -0500, Russ Anderson wrote:
> On Thu, Apr 11, 2013 at 08:15:27PM +0530, Srivatsa S. Bhat wrote:
> > On 04/11/2013 07:53 PM, Russ Anderson wrote:
> > > On Thu, Apr 11, 2013 at 06:15:18PM +0530, Srivatsa S. Bhat wrote:
> > >>
> > >> One more thing we have to note is that, there are 4 notifiers for taking a
> > >> CPU offline:
> > >>
> > >> CPU_DOWN_PREPARE
> > >> CPU_DYING
> > >> CPU_DEAD
> > >> CPU_POST_DEAD
> > >>
> > >> The first can be run in parallel as mentioned above. The second is run in
> > >> parallel in the stop_machine() phase as shown in Russ' patch. But the third
> > >> and fourth set of notifications all end up running only on CPU0, which will
> > >> again slow down things.
> > > 
> > > In my testing the third and fourth set were a small part of the overall
> > > time.  Less than 10%, with cpu notifiers 90+% of the time.
> > 
> > *All* of them are cpu notifiers! All of them invoke __cpu_notify() internally.
> > So how did you differentiate between them and find out that the third and
> > fourth sets take less time?
> 
> I reran a test on a 1024 cpu system, using my test patch to only call
> __stop_machine() once.  Added printks to show the kernel timestamp
> at various points.
> 
> When calling disable_nonboot_cpus() and enable_nonboot_cpus() just after
> booting the system:
>  The loop calling __cpu_notify(CPU_DOWN_PREPARE) took 376.6 seconds.
>  The loop calling cpu_notify_nofail(CPU_DEAD) took 8.1 seconds.
> 
> My guess is that notifiers do more work in the CPU_DOWN_PREPARE case.
> 
> I also added a loop calling a new notifier (CPU_TEST) which none of
> notifiers would recognize, to measure the time it took to spin through
> the call chain without the notifiers doing any work.  It took
> 0.0067 seconds.
> 
> On the actual reboot, as the system was shutting down:
>  The loop calling __cpu_notify(CPU_DOWN_PREPARE) took 333.8 seconds.
>  The loop calling cpu_notify_nofail(CPU_DEAD) took 2.7 seconds.

How about if you take the notifier_call_chain function copy it
to kernel/sys.c, and time each notifier_call() callout individually.

Robin
