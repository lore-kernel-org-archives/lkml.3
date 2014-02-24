Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaBXRIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:08:51 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:43522 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaBXRIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:08:50 -0500
Date: Mon, 24 Feb 2014 12:10:44 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com>
Message-ID: <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211732290.11615@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402212342090.17416@vincent-weaver-1.um.maine.edu>
 <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu> <530AD71E.50800@zytor.com> <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
 <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, H. Peter Anvin wrote:

> On February 24, 2014 8:34:30 AM PST, Vince Weaver <vincent.weaver@maine.edu> wrote:
> >On Mon, 24 Feb 2014, Vince Weaver wrote:
> >
> >> Just touching the mmap page with a write of a single byte (it doesn't
> >
> >> matter where) is enough to trigger the bug.
> >
> >OK, investigating this more.
> >
> >perf_fuzzer-2971  [000]   154.944114: page_fault_user:      
> >address=0xf7729000 ip=0x41efab error_code=0x6
> >perf_fuzzer-2971  [000]   154.944118: function:             
> >ip=0xffffffff810d40e7 parent_ip=0xffffffff810d0840
> >perf_fuzzer-2971  [000]   154.944119: function:             
> >ip=0xffffffff812a91a5 parent_ip=0xffffffff81013ff5
> >perf_fuzzer-2971  [000]   154.944120: function:             
> >ip=0xffffffff8153837c parent_ip=0xffffffff81535432
> >perf_fuzzer-2971  [000]   154.944121: page_fault_kernel:    
> >address=0x22e0 ip=0xffffffff812a7d5c error_code=0x0

> Ok, so the obvious question is what is at that kernel address?
> 

It's in copy_user_generic_string()
	rep movsq %ds:(%rsi),%es:(%rdi)

And looking at the ftrace:
     perf_fuzzer-2979  [000]   161.475920: page_fault_user:      address=__per_cpu_end ip=__per_cpu_end error_code=0x6
     perf_fuzzer-2979  [000]   161.475922: function:             perf_callchain
     perf_fuzzer-2979  [000]   161.475922: function:             copy_from_user_nmi
     perf_fuzzer-2979  [000]   161.475923: function:             trace_do_page_fault
     perf_fuzzer-2979  [000]   161.475924: page_fault_kernel:    address=irq_stack_union ip=copy_user_generic_string error_code=0x0

What is likely happening is the user page fault is triggering 
code to do a "perf_callchain" dump, which is calling copy_from_user_nmi()
which calls copy_user_generic_string() which is somehow getting the user
RBP in the RDI register somehow?

Vince

