Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935388Ab3DKNsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:48:42 -0400
Received: from relay3.sgi.com ([192.48.152.1]:53952 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932200Ab3DKNsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:48:40 -0400
Date: Thu, 11 Apr 2013 08:48:37 -0500
From: Robin Holt <holt@sgi.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Robin Holt <holt@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Bulk CPU Hotplug (Was Re: [PATCH] Do not force shutdown/reboot
 to boot cpu.)
Message-ID: <20130411134837.GE3672@sgi.com>
References: <20130403193743.GB29151@sgi.com>
 <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
 <20130408165916.GA3672@sgi.com>
 <20130410111620.GB29752@gmail.com>
 <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
 <20130411053106.GA9042@drongo>
 <5166B05E.8010904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5166B05E.8010904@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the v3.9 release, can we consider my awful patch?

Thanks,
Robin

On Thu, Apr 11, 2013 at 06:15:18PM +0530, Srivatsa S. Bhat wrote:
> On 04/11/2013 11:01 AM, Paul Mackerras wrote:
> > On Wed, Apr 10, 2013 at 08:10:05AM -0700, Linus Torvalds wrote:
> >> The optimal solution would be to just speed up the
> >> disable_nonboot_cpus() code so much that it isn't an issue. That would
> >> be good for suspending too, although I guess suspend isn't a big issue
> >> if you have a thousand CPU's.
> >>
> >> Has anybody checked whether we could do the cpu_down() on non-boot
> >> CPU's in parallel? Right now we serialize the thing completely, with
> > 
> > I thought Srivatsa S. Bhat had a patchset that did exactly that.
> > Srivatsa?
> > 
> 
> Thanks for the CC, Paul! Adding some more people to CC.
> 
> Actually, my patchset was about removing stop_machine() from the CPU
> offline path.
> http://lwn.net/Articles/538819/
> 
> And here is the performance improvement I had measured in the version
> prior to that:
> http://article.gmane.org/gmane.linux.kernel/1435249
> 
> I'm planning to revive this patchset after the 3.10 merge window closes,
> because it depends on doing a tree-wide sweep, and I think its a little
> late to do it in time for the upcoming 3.10 merge window itself.
> 
> Anyway, that's about removing stop_machine from CPU hotplug.
> 
> Coming to bulk CPU hotplug, yes, I had ideas similar to what Russ suggested.
> But I believe we can do more than that.
> 
> As Russ pointed out, the notifiers are not thread-safe, so calling them
> in parallel with different CPUs as arguments isn't going to work.
> 
> So, first, we can convert all the CPU hotplug notifiers to take a cpumask
> instead of a single CPU. So assuming that there are 'n' notifiers in total,
> the number of function calls would become n, instead of n*1024.
> But that itself most likely won't give us much benefit over the for-loop
> that Russ has done in his patch, because it'll simply do longer processing
> in each of those 'n' notifiers, by iterating over the cpumask inside each
> notifier.
> 
> Now comes the interesting thing:
> 
> Consider a notifier chain that looks like this:
> Priority 0: A->B->C->D
> 
> We can't invoke say notifier callback A simultaneously on 2 CPUs with 2
> different hotcpus as argument. *However*, since A, B, C, D all (more or less)
> belong to different subsystems, we can call A, B, C and D in parallel on
> different CPUs. They won't even serialize amongst themselves because they
> take locks (if any) of different subsystems. And since they are of same
> priority, the ordering (A after B or B after A) doesn't matter as well.
> 
> So with this, if we combine the idea I wrote above about giving a cpumask
> to each of these notifiers to work with, we end up in this:
> 
> CPU 0          CPU 1          CPU2           ....
> A(cpumask)     B(cpumask)     C(cpumask)     ....
> 
> So, for example, the CPU_DOWN_PREPARE notification can be processed in parallel
> on multiple CPUs at a time, for a given cpumask! That should definitely
> give us a good speed-up.
> 
> One more thing we have to note is that, there are 4 notifiers for taking a
> CPU offline:
> 
> CPU_DOWN_PREPARE
> CPU_DYING
> CPU_DEAD
> CPU_POST_DEAD
> 
> The first can be run in parallel as mentioned above. The second is run in
> parallel in the stop_machine() phase as shown in Russ' patch. But the third
> and fourth set of notifications all end up running only on CPU0, which will
> again slow down things.
> 
> So I suggest taking down the 1024 CPUs in multiple phases, like a binary search.
> First, take 512 CPUs down, then 256 CPUs, then 128 CPUs etc. So at every bulk
> CPU hotplug, we have enough online CPUs to handle the notifier load, and that
> helps speed things up. Moreover, a handful of calls to stop_machine() is OK
> because, stop_machine() takes progressively lesser and lesser time because
> lesser CPUs are online on each iteration (and hence it reduces the
> synchronization overhead of the stop-machine phase).
> 
> The only downside to this whole idea of running the notifiers of a given
> priority in parallel, is error handling - if a notifier fails, it would be
> troublesome to rollback I guess. But if we forget that for a moment, we can
> give this idea a try!
> 
> Regards,
> Srivatsa S. Bhat
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
