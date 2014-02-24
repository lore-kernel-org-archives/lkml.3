Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaBXSFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:05:16 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45347 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaBXSFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:05:14 -0500
Date: Mon, 24 Feb 2014 13:07:16 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>
References: <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu> <530AD71E.50800@zytor.com> <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
 <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com> <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu> <20140224172536.GD9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
 <530B841F.5050803@zytor.com> <alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Vince Weaver wrote:

> On Mon, 24 Feb 2014, H. Peter Anvin wrote:
> 
> > On 02/24/2014 09:32 AM, Vince Weaver wrote:
> > >>
> > >> Peter, does x32 have a slightly different ABI/calling convention that
> > >> would make any of these patches just slightly 'off'?
> > > 
> > > I do note that 
> > > 	perf_callchain_user();
> > > 
> > > Does
> > > 	fp = (void __user *)regs->bp;
> > > 	
> > > 	...
> > > 
> > > 	bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
> > > 
> > > 
> > > And in my particular executable RBP has nothing to do with a frame 
> > > pointer, but is instead being used as a general purpose register.
> > > 
> > > Am I missing something here?  Though in that case I'm not sure why this 
> > > wouldn't be easier to trigger.
> > > 
> > 
> > Neither x86-64 nor x32 are typically compiled with fixed frame pointers
> > (which would be %rbp if they are).  So I'm guessing the perf_callchain
> > logic is only applicable to a user-space binary explicitly compiled with
> > frame pointers turned on.
> > 
> > So copy_from_user_nmi() stumbles onto a nonexistent page and takes a
> > page fault.  This isn't a big deal, because perf_callchain_user() is set
> > up to handle that (and just terminates the trace), *except* now CR2 is
> > corrupt, and we took this event while handling a page fault already...
> > and apparently before we even did read_cr2() in __do_page_fault.
> > 
> > The description of copy_from_user_nmi() states:
> > 
> > /*
> >  * We rely on the nested NMI work to allow atomic faults from the NMI
> > path; the
> >  * nested NMI paths are careful to preserve CR2.
> >  */
> > 
> > ... but that doesn't seem to happen here for whatever reason.
> > 
> > There is no hint in your trace what happens after the kernel page fault
> > so that makes it hard to know.
> 
> Ahh, ftrace, the cause of and solution to all my perf_fuzzing problems.
> 
> Anyway I've attached the full tail end of the trace if you want to see 
> everything that happens.

and then I note there are *two* kernel page faults.

     perf_fuzzer-2979  [000]   161.475924: page_fault_kernel:    address=irq_stack_union ip=copy_user_generic_string error_code=0x0
address=0x1 ip=0xffffffff812a7d9c error_code=0x0
     perf_fuzzer-2979  [000]   161.475924: function:                __do_page_fault
     perf_fuzzer-2979  [000]   161.475924: function:                   bad_area_nosemaphore
     perf_fuzzer-2979  [000]   161.475925: function:                      __bad_area_nosemaphore
     perf_fuzzer-2979  [000]   161.475925: function:                         no_context
     perf_fuzzer-2979  [000]   161.475925: function:                            fixup_exception
     perf_fuzzer-2979  [000]   161.475926: function:                               search_exception_tables
     perf_fuzzer-2979  [000]   161.475926: function:                                  search_extable
     perf_fuzzer-2979  [000]   161.475927: function:             copy_user_handle_tail
     perf_fuzzer-2979  [000]   161.475927: function:             trace_do_page_fault
     perf_fuzzer-2979  [000]   161.475928: page_fault_kernel:    address=irq_stack_union ip=copy_user_handle_tail error_code=0x0
address=0x1 ip=0xffffffff812a92bb error_code=0x0
     perf_fuzzer-2979  [000]   161.475928: function:                __do_page_fault
     perf_fuzzer-2979  [000]   161.475928: function:                   bad_area_nosemaphore
     perf_fuzzer-2979  [000]   161.475929: function:                      __bad_area_nosemaphore
     perf_fuzzer-2979  [000]   161.475929: function:                         no_context
     perf_fuzzer-2979  [000]   161.475929: function:                            fixup_exception
     perf_fuzzer-2979  [000]   161.475929: function:                               search_exception_tables
     perf_fuzzer-2979  [000]   161.475930: function:                                  search_extable
     perf_fuzzer-2979  [000]   161.475931: function:             perf_output_begin
     perf_fuzzer-2979  [000]   161.475931: function:             perf_output_copy

That second one is in copy_user_handle_tail()

Sorry for the sloppy analysis here, I did most of the initial tracing last 
night at 1am typing one-handed with a sick crying baby draped over one
shoulder, so not really operating at my best.

Vince
