Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3CFHNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:13:52 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29581 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3CFHNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:13:51 -0500
Message-ID: <1362554012.7242.9.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 05 Mar 2013 23:13:32 -0800
In-Reply-To: <CA+55aFx5pAsC9Ej2h9mniEU89oD=1mq6iPA+R2MBX-z74J0B5Q@mail.gmail.com>
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFx5pAsC9Ej2h9mniEU89oD=1mq6iPA+R2MBX-z74J0B5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 07:40 -0800, Linus Torvalds wrote:
> On Tue, Mar 5, 2013 at 1:35 AM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> >
> > The following set of patches are based on the discussion of holding the
> > ipc lock unnecessarily, such as for permissions and security checks:
> 
> Ok, looks fine from a quick look (but then, so did your previous patch-set ;)
> 
> You still open-code the spinlock in at least a few places (I saw
> sem_getref), but I still don't care deeply.
> 
> >> 2) While on an Oracle swingbench DSS (data mining) workload the
> > improvements are not as exciting as with Rik's benchmark, we can see
> > some positive numbers. For an 8 socket machine the following are the
> > percentages of %sys time incurred in the ipc lock:
> 
> Ok, I hoped for it being more noticeable. Since that benchmark is less
> trivial than Rik's, can you do a perf record -fg of it and give a more
> complete picture of what the kernel footprint is - and in particular
> who now gets that ipc lock function? Is it purely semtimedop, or what?
> Look out for inlining - ipc_rcu_getref() looks like it would be
> inlined, for example.
> 
> It would be good to get a "top twenty kernel functions" from the
> profile, along with some call data on where the lock callers are.. I
> know that Rik's benchmark *only* had that one call-site, I'm wondering
> if the swingbench one has slightly more complex behavior...

For a 400 user workload (the kernel functions remain basically the same
for any amount of users):

    17.86%           oracle  [kernel.kallsyms]   [k] _raw_spin_lock                             
     8.46%          swapper  [kernel.kallsyms]   [k] intel_idle                                 
     5.51%           oracle  [kernel.kallsyms]   [k] try_atomic_semop                           
     5.05%           oracle  [kernel.kallsyms]   [k] update_sd_lb_stats                         
     2.81%           oracle  [kernel.kallsyms]   [k] tg_load_down                               
     2.41%          swapper  [kernel.kallsyms]   [k] update_blocked_averages                    
     2.38%           oracle  [kernel.kallsyms]   [k] idle_cpu                                   
     2.37%          swapper  [kernel.kallsyms]   [k] native_write_msr_safe                      
     2.28%           oracle  [kernel.kallsyms]   [k] update_cfs_rq_blocked_load                 
     1.84%           oracle  [kernel.kallsyms]   [k] update_blocked_averages                    
     1.79%           oracle  [kernel.kallsyms]   [k] update_queue                               
     1.73%          swapper  [kernel.kallsyms]   [k] update_cfs_rq_blocked_load                 
     1.29%           oracle  [kernel.kallsyms]   [k] native_write_msr_safe                      
     1.07%             java  [kernel.kallsyms]   [k] update_sd_lb_stats                         
     0.91%          swapper  [kernel.kallsyms]   [k] poll_idle                                  
     0.86%           oracle  [kernel.kallsyms]   [k] try_to_wake_up                             
     0.80%             java  [kernel.kallsyms]   [k] tg_load_down                               
     0.72%           oracle  [kernel.kallsyms]   [k] load_balance                               
     0.67%           oracle  [kernel.kallsyms]   [k] __schedule                                 
     0.67%           oracle  [kernel.kallsyms]   [k] cpumask_next_and                           

Digging into the _raw_spin_lock call:

 17.86%           oracle  [kernel.kallsyms]   [k] _raw_spin_lock                            
                     |
                     --- _raw_spin_lock
                        |          
                        |--49.55%-- sys_semtimedop
                        |          |          
                        |          |--77.41%-- system_call
                        |          |          semtimedop
                        |          |          skgpwwait
                        |          |          ksliwat
                        |          |          kslwaitctx


Thanks,
Davidlohr


