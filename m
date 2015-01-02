Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbbABSDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:03:25 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:39590 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbbABSDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:03:24 -0500
MIME-Version: 1.0
In-Reply-To: <54A6C34C02000078000C4AE4@mail.emea.novell.com>
References: <1419315745-20767-1-git-send-email-user@chenggang-laptop>
 <c027bde0-5f4f-441f-8d45-3e7f6f702231@alibaba-inc.com> <CALCETrVVvbnO-7bnyPCYhPbDoEg-hqmvVbfXL9ONbQPBTJNUZg@mail.gmail.com>
 <20141230190327.GB23965@worktop.programming.kicks-ass.net>
 <CALCETrWxPBdjY0+gCmPSwjYLB0u4Z4JgGtuR-XU=qwVzoDEBpA@mail.gmail.com>
 <CALCETrUEDuWoXyN+JrB5nWfL6B5odQJU37_y=-tzXN0vxr4tOQ@mail.gmail.com> <54A6C34C02000078000C4AE4@mail.emea.novell.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 2 Jan 2015 10:03:02 -0800
Message-ID: <CALCETrUbEpTuQKiUPKeT54nFSwDQh9uA2QHLXsZeTbLrMsqxoA@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkje+8mltQQVRDSF0gcGVyZiBjb3JlOiBVc2UgS1NUS19FU1AoKSBpbnN0ZQ==?=
	=?UTF-8?B?YWQgb2YgcHRfcmVncy0+c3Agd2hpbGUgb3V0cHV0IHVzZXIgcmVncw==?=
To: Jan Beulich <jbeulich@suse.com>
Cc: Chenggang Qin <chenggang.qcg@taobao.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>,
        root <chenggang.qin@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 2, 2015 8:11 AM, "Jan Beulich" <jbeulich@suse.com> wrote:
>
> >>> Andy Lutomirski <luto@amacapital.net> 12/31/14 3:00 AM >>>
> >On Tue, Dec 30, 2014 at 3:29 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >> Given how the x86_64* entry code works, using task_pt_regs from
> >> anywhere except explicitly supported contexts (including exceptions
> >> that originated in userspace and a small handful of system calls) is
> >> asking for trouble.  NMI context is especially bad.
> >>
> >> How important is this feature, and which registers matter?  It might
> >> be possible to use a dwarf unwinder on the kernel call stack to get
> >> most of the regs from most contexts, and it might also be possible to
> >> make small changes to the entry code to make it possible to get some
> >> of the registers reliably, but it's not currently possible to safely
> >> use task_pt_regs *at all* from NMI context unless you've at least
> >> blacklisted a handful of origin RIP values that give dangerously bogus
> >> results.  (Using do_nmi's regs parameter if user_mode_vm(regs) is a
> >> different story.)
> >
> >It's actually worse than just knowing the interrupted kernel RIP.  If
> >the call chain goes usermode -> IST exception -> NMI, then
> >task_pt_regs is entirely uninitialized.  Assuming all the CFI
> >annotations are correct, the unwinder could still do it from the
> >kernel.
> >
> >Note that, as far as I know, Jan Beulich is the only person who uses
> >the unwinder on kernel code.  Jan, how do you do this?
>
> Trying to guess what you mean by "this": A stack switch gets expressed by
> CFI annotations just like any other frame pointer adjustments. See for example
> the CFI_DEF_CFA_REGISTER use in the SAVE_ARGS_IRQ macro.
>
> If that wasn't your question, please be more precise.

Sorry, my question was vague.

Is there any way to consume these annotations at runtime in the
kernel?  The goal would be for perf's NMI handler to consume the CFI
data to figure out the userspace registers.  I'm guessing that the
answer might be no, because we seem to be compiling with
-fno-asynchronous-unwind-tables and we don't seem to be putting any
.eh_frame stuff into the final kernel image.

I had thought that someone implemented runtime DWARF unwinding, though.

--Andy

>
> Jan
>
