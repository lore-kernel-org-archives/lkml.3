Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbaD3Wvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:51:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:56250 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759629AbaD3Wvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:51:32 -0400
Date: Thu, 1 May 2014 00:51:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1404301701260.15279@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.02.1404302310530.6261@ionos.tec.linutronix.de>
References: <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
 <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404301701260.15279@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014, Vince Weaver wrote:

> On Wed, 30 Apr 2014, Peter Zijlstra wrote:
> 
> > 
> > Vince, could you add the below to whatever tracing muck you already
> > have?
> > 
> > After staring at your traces all day with Thomas, we have doubts about
> > the refcount integrity.
> 
> I've been staring at traces all day too.  Will try your patch tomorrow.
> 
> >From my staring, what looks like is happening in the trace is:
> 
> task_sched_in in parent adds our freed (but alive in child) event:

And that's the issue which puzzles us. Let's look at what we expect:

event create:	
       parent_evt->refcount = 1
       parent_fd = fd(file)
       file->refcnt = 1

mmap:
       file->refcnt = 2

clone:
       child_fd = dup(parent_fd)
         file->refcnt = 3

       child_evt = dup(parent_evt)
       	 parent_evt->refcount = 2

unmap:
       file->refcnt = 2

close(parent_fd)
       file->refcnt = 1

kill child

child exits:

   exit_files()
     close(child_fd)
       file->refcnt = 0
          perf_release()
       	    parent_evt->refcount = 1

   perf_event_exit_task()
     kill child_evt
       parent_evt->refcount = 0
       	---> destroy parent

Now the trace shows a different story:

     perf_fuzzer-4387  [001]  1802.628659: sys_enter:            NR 298 (69bb58, 0, ffffffff, 12, 0, 0)
     perf_fuzzer-4387  [001]  1802.628659: function:             SyS_perf_event_open
     perf_fuzzer-4387  [001]  1802.628660: function:             perf_event_alloc
     perf_fuzzer-4387  [001]  1802.628663: kmalloc:              (perf_event_alloc+0x5a) call_site=ffffffff8113a8fa ptr=0xffff8800a3122800 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-4387  [001]  1802.628663: function:                perf_init_event
     perf_fuzzer-4387  [001]  1802.628664: function:                   perf_tp_event_init
     perf_fuzzer-4387  [001]  1802.628664: function:                   perf_swevent_init
     perf_fuzzer-4387  [001]  1802.628667: function:             perf_lock_task_context
     perf_fuzzer-4387  [001]  1802.628669: kmem_cache_alloc:     (__d_alloc+0x25) call_site=ffffffff811cfa75 ptr=0xffff8800b37ddeb8 bytes_req=288 bytes_alloc=312 gfp_flags=GFP_KERNEL
     perf_fuzzer-4387  [001]  1802.628671: kmem_cache_alloc:     (get_empty_filp+0x5c) call_site=ffffffff811b7b7c ptr=0xffff880117502ac0 bytes_req=448 bytes_alloc=448 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-4387  [001]  1802.628672: function:             perf_install_in_context
     perf_fuzzer-4387  [001]  1802.628672: function:             __perf_install_in_context
     perf_fuzzer-4387  [001]  1802.628672: function:                perf_pmu_disable
     perf_fuzzer-4387  [001]  1802.628673: function:                   perf_pmu_nop_void
     perf_fuzzer-4387  [001]  1802.628673: function:             perf_event__header_size
     perf_fuzzer-4387  [001]  1802.628673: function:             perf_event__header_size
     perf_fuzzer-4387  [001]  1802.628673: function:             perf_event_sched_in
     perf_fuzzer-4387  [001]  1802.628674: function:             perf_pmu_enable
     perf_fuzzer-4387  [001]  1802.628674: function:                perf_pmu_nop_void
     perf_fuzzer-4387  [001]  1802.628675: function:             perf_unpin_context
     perf_fuzzer-4387  [001]  1802.628676: function:             perf_event__header_size
     perf_fuzzer-4387  [001]  1802.628676: function:             perf_event__id_header_size.isra.19
     perf_fuzzer-4387  [001]  1802.628677: bprint:               SYSC_perf_event_open: Opened: 1 8 0
     perf_fuzzer-4387  [001]  1802.628677: sys_exit:             NR 298 = 41

parent_evt->refcount = 1
file->refcount = 1

Now mmap:

     perf_fuzzer-4387  [001]  1802.628678: sys_enter:            NR 9 (0, 3000, 3, 1, 29, 0)
     perf_fuzzer-4387  [001]  1802.628680: kmem_cache_alloc:     (mmap_region+0x348) call_site=ffffffff811771c8 ptr=0xffff8800b54255d0 bytes_req=184 bytes_alloc=208 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-4387  [001]  1802.628680: function:             perf_mmap
     perf_fuzzer-4387  [001]  1802.628682: kmalloc:              (rb_alloc+0x38) call_site=ffffffff8113c858 ptr=0xffff88003766bb00 bytes_req=208 bytes_alloc=256 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-4387  [001]  1802.628682: function:             perf_mmap_alloc_page
     perf_fuzzer-4387  [001]  1802.628683: mm_page_alloc:        page=0xffffea00027abf60 pfn=41598816 order=0 migratetype=0 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-4387  [001]  1802.628683: function:             perf_mmap_alloc_page
     perf_fuzzer-4387  [001]  1802.628684: mm_page_alloc:        page=0xffffea00027abf28 pfn=41598760 order=0 migratetype=0 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-4387  [001]  1802.628684: function:             perf_mmap_alloc_page
     perf_fuzzer-4387  [001]  1802.628685: mm_page_alloc:        page=0xffffea00027abef0 pfn=41598704 order=0 migratetype=0 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-4387  [001]  1802.628686: function:             perf_event_update_userpage
     perf_fuzzer-4387  [001]  1802.628692: function:             perf_event_mmap
     perf_fuzzer-4387  [001]  1802.628698: kmalloc:              (perf_event_mmap+0x90) call_site=ffffffff81139d40 ptr=0xffff880083d0d000 bytes_req=4096 bytes_alloc=4096 gfp_flags=GFP_KERNEL
     perf_fuzzer-4387  [001]  1802.628699: function:                perf_event_aux
     perf_fuzzer-4387  [001]  1802.628699: function:                   perf_event_aux_ctx
     perf_fuzzer-4387  [001]  1802.628699: function:                   perf_event_aux_ctx
     perf_fuzzer-4387  [001]  1802.628699: function:                   perf_event_aux_ctx
     perf_fuzzer-4387  [001]  1802.628699: function:                      perf_event_mmap_output
     perf_fuzzer-4387  [001]  1802.628700: function:                   perf_event_aux_ctx
     perf_fuzzer-4387  [001]  1802.628700: function:                   perf_event_aux_ctx
     perf_fuzzer-4387  [001]  1802.628700: function:                   perf_event_aux_ctx
     perf_fuzzer-4387  [001]  1802.628701: kfree:                (perf_event_mmap+0x175) call_site=ffffffff81139e25 ptr=0xffff880083d0d000
     perf_fuzzer-4387  [001]  1802.628702: sys_exit:             NR 9 = 140141108113408 (0x7f7524f7b000)

file->refcount = 2

And here the clone:

     perf_fuzzer-4387  [002]  1803.570829: sys_enter:            NR 56 (1200011, 0, 0, 7f7524f899d0, 0, 1123)

     perf_fuzzer-4387  [002]  1803.570855: function:             perf_event_init_task

Somewhere in this maze we copy the parent event so in theory:

parent_evt->refcount = 2

Now we copy the file descriptors:

     perf_fuzzer-4387  [002]  1803.571065: kmem_cache_alloc:     (dup_fd+0x33) call_site=ffffffff811d4a23 ptr=0xffff8800ce29e100 bytes_req=704 bytes_alloc=704 gfp_flags=GFP_KERNEL

file->refcount = 3

     perf_fuzzer-4387  [002]  1803.571239: sys_exit:             NR 56 = 5504

Fork is done and we unmap:

     perf_fuzzer-4387  [002]  1803.582330: sys_enter:            NR 11 (7f7524f7b000, 3000, 3000, 7f7524d760a4, 7f7524d76108, 7f7524d76120)
     perf_fuzzer-4387  [002]  1803.582335: function:             perf_mmap_close
     perf_fuzzer-4387  [002]  1803.582339: kmem_cache_free:      (remove_vma+0x63) call_site=ffffffff811742f3 ptr=0xffff8800b54255d0
     perf_fuzzer-4387  [002]  1803.582344: sys_exit:             NR 11 = 0

file->refcount = 2

Now we close the file descriptor

     perf_fuzzer-4387  [002]  1803.582345: sys_enter:            NR 3 (29, 3000, 3000, 7f7524d760a4, 7f7524d76108, 7f7524d76120)
     perf_fuzzer-4387  [002]  1803.582345: sys_exit:             NR 3 = 0

file->refcount = 1

Now the child gets killed

     perf_fuzzer-4387  [003]  1803.590145: sys_enter:            NR 62 (1580, 9, 7, 7f7524d760b8, 7f7524d760b8, 7f7524d76120)
     perf_fuzzer-4387  [003]  1803.590148: kmem_cache_alloc:     (__sigqueue_alloc+0x9c) call_site=ffffffff81073c0c ptr=0xffff8800897825e0 bytes_req=160 bytes_alloc=184 gfp_flags=GFP_ATOMIC|GFP_NOTRACK
     perf_fuzzer-4387  [003]  1803.590149: sys_exit:             NR 62 = 0

And the child exits and calls exit_files() and that decrements
file->refcount to 0, so perf_release is called:

     perf_fuzzer-5504  [004]  1803.590311: function:             perf_release

After that the dentry which is associated to the parent event is
released:

     perf_fuzzer-5504  [004]  1803.590353: kmem_cache_free:      (__d_free+0x42) call_site=ffffffff811cc1f2 ptr=0xffff8800b37ddeb8

That's fine, but the issue is, that perf_release() also calls:

     perf_fuzzer-5504  [004]  1803.590312: function:             perf_event_release_kernel

And that means that the parent_evt->refcount was not 2 as one would
expect. It was 1, otherwise put_event() which is called from
perf_release() would have returned right away due to:

	if (!atomic_long_dec_and_test(&event->refcount))
		return;

So after exit_files() is done perf_event_exit_task() is invoked

     perf_fuzzer-5504  [004]  1803.590365: function:             perf_event_exit_task

That cleans up the child events. So the child still has a reference to
the parent event which was destroyed before. It's still not kfree'd as
that happens via RCU way later

     ksoftirqd/4-28    [004]  1803.609802: kfree:                (free_event_rcu+0x2f) call_site=ffffffff8113177f ptr=0xffff8800a3122800

But of course the child cleanup will poke in the by now invalid parent
and leave some references to that at some other place, which will
later on be detected as slab corruption or some other kind of
wreckage.

Thanks,

	tglx



