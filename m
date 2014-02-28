Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaB1Bce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 20:32:34 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:61407 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaB1Bcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 20:32:33 -0500
Date: Thu, 27 Feb 2014 20:34:34 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <530FC1C6.5040209@zytor.com>
Message-ID: <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <20140224172536.GD9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu> <530B841F.5050803@zytor.com>
 <alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu> <530B90A5.3090302@zytor.com> <20140224141329.1cd3bb52@gandalf.local.home> <20140224193043.GP6835@laptop.programming.kicks-ass.net>
 <530C12CA.6070308@zytor.com> <alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu> <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com> <20140225094352.73e0e28c@gandalf.local.home> <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu> <20140227173150.4e5ed747@gandalf.local.home> <530FC1C6.5040209@zytor.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, H. Peter Anvin wrote:

> On 02/27/2014 02:31 PM, Steven Rostedt wrote:
> > 
> > Yeah, something is getting mesed up.
> > 
> 
> What it *looks* like to me is that we try to nest the cr2 save/restore,
> which doesn't nest because it is a percpu variable.
> 
> ... except in the x86-64 case, we *ALSO* save/restore cr2 inside
> entry_64.S, which makes the stuff in do_nmi completely redundant and
> there for no good reason.
> 
> I would actually suggest we do the equivalent on i386 as well.
> 
> Vince, could you try this patch as an experiment?

OK with your patch applied it does not segfault.

The trace looks like you'd expect too:

     perf_fuzzer-2910  [000]   255.355331: page_fault_kernel:    address=irq_stack_union ip=copy_user_handle_tail error_code=0x0
     perf_fuzzer-2910  [000]   255.355331: function:                __do_page_fault
     perf_fuzzer-2910  [000]   255.355331: function:                   bad_area_nosemaphore
     perf_fuzzer-2910  [000]   255.355331: function:                      __bad_area_nosemaphore
     perf_fuzzer-2910  [000]   255.355332: function:                         no_context
     perf_fuzzer-2910  [000]   255.355332: function:                            fixup_exception
     perf_fuzzer-2910  [000]   255.355332: function:                               search_exception_tables
     perf_fuzzer-2910  [000]   255.355332: function:                                  search_extable
     perf_fuzzer-2910  [000]   255.355333: function:             perf_output_begin
     perf_fuzzer-2910  [000]   255.355333: bprint:               perf_output_begin: VMW: event type 2 config 2a st: 2c3e7
     perf_fuzzer-2910  [000]   255.355333: bprint:               perf_output_begin: VMW: before event->parent (nil)
     perf_fuzzer-2910  [000]   255.355334: bprint:               perf_output_begin: VMW: before rcu_dereference (nil)
     perf_fuzzer-2910  [000]   255.355334: function:             __do_page_fault
     perf_fuzzer-2910  [000]   255.355334: function:                down_read_trylock
     perf_fuzzer-2910  [000]   255.355334: function:                _cond_resched
     perf_fuzzer-2910  [000]   255.355335: function:                find_vma
     perf_fuzzer-2910  [000]   255.355335: function:                handle_mm_fault
     perf_fuzzer-2910  [000]   255.355335: function:                   __do_fault
     perf_fuzzer-2910  [000]   255.355335: bputs:                perf_mmap_fault: VMW: perf_mmap_fault
     perf_fuzzer-2910  [000]   255.355336: bprint:               perf_mmap_fault: VMW: perf_mmap_fault 0xffff8800cba6a980
     perf_fuzzer-2910  [000]   255.355336: function:             perf_mmap_to_page
     perf_fuzzer-2910  [000]   255.355336: function:             _cond_resched
     perf_fuzzer-2910  [000]   255.355336: function:                      unlock_page
     perf_fuzzer-2910  [000]   255.355336: function:                         page_waitqueue
     perf_fuzzer-2910  [000]   255.355337: function:                         __wake_up_bit
     perf_fuzzer-2910  [000]   255.355337: bputs:                perf_mmap_fault: VMW: perf_mmap_fault
     perf_fuzzer-2910  [000]   255.355337: function:             _cond_resched
     perf_fuzzer-2910  [000]   255.355337: function:                      _raw_spin_lock
     perf_fuzzer-2910  [000]   255.355337: function:                      page_add_file_rmap
     perf_fuzzer-2910  [000]   255.355338: function:                         __inc_zone_page_state
     perf_fuzzer-2910  [000]   255.355338: function:                            __inc_zone_state
     perf_fuzzer-2910  [000]   255.355338: function:                      set_page_dirty
     perf_fuzzer-2910  [000]   255.355338: function:                         page_mapping
     perf_fuzzer-2910  [000]   255.355338: function:                         anon_set_page_dirty
     perf_fuzzer-2910  [000]   255.355339: function:                      unlock_page


Vince

