Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3JHHwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:52:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:11465 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab3JHHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:52:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1055,1371106800"; 
   d="scan'208";a="407070372"
Date: Tue, 8 Oct 2013 15:51:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131008075151.GA15689@localhost>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Oct 07, 2013 at 11:47:39AM -0700, Linus Torvalds wrote:
> On Sat, Oct 5, 2013 at 4:44 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >
> > I got the below dmesg and the first bad commit is
> >
> > commit 0c44c2d0f459 ("x86: Use asm goto to implement better modify_and_test() functions"
> 
> Hmm. I'm looking at the final version of that patch, and I'm not
> seeing anything wrong. It may trigger a compiler bug - there aren't
> that many "asm goto" users, and using them for the bitops adds a lot
> of new cases.
> 
> Your oops makes very little sense, it looks like task_work_run() just
> called out to random crap, probably because the work was already
> released, so "work->func()" ends up being bad. I'm adding Oleg to the
> participants anyway, just in case there is some race. The comment says
> that it can race with task_work_cancel() playing with *work. Oleg,
> comments?
> 
> However, I don't see any actual bit-op code in task_work_run() itself,
> so it's something else that got miscompiled and corrupted memory. In
> that respect, the oops you have looks more like the oopses you got
> with DEBUG_KOBJECT_RELEASE. Are you sure that wasn't set?

The options was set:

DEBUG_KOBJECT_RELEASE=y
 
I tried disabled it, and find the error still remains:

[    9.719060] Write protecting the kernel text: 6116k
[    9.720356] Write protecting the kernel read-only data: 2616k
[    9.721586] NX-protecting the kernel data: 6172k
[    9.750420] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    9.750870] IP: [<  (null)>]   (null)
[    9.750870] *pdpt = 00000000072be001 *pde = 0000000000000000
[    9.750870] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    9.750870] CPU: 0 PID: 84 Comm: rc.local Not tainted 3.12.0-rc1-00081-g6bfa687 #4
[    9.750870] task: 872c4000 ti: 872c6000 task.ti: 872c6000
[    9.750870] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    9.750870] EIP is at 0x0
[    9.750870] EAX: 82076134 EBX: 872b2780 ECX: 00000000 EDX: 82076134
[    9.750870] ESI: 872c4000 EDI: 872c4388 EBP: 872c7f9c ESP: 872c7f8c
[    9.750870]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    9.750870] CR0: 8005003b CR2: 00000000 CR3: 072bd000 CR4: 000006b0
[    9.750870] Stack:
[    9.750870]  810545b9 00000001 789ecf58 7767dff4 872c7fac 81002358 00000000 78a03903
[    9.750870]  872c6000 815f6bd0 00000000 00000000 00000000 00000000 00000000 00000000
[    9.750870]  00000000 0000007b 0000007b 00000000 00000000 0000000b 777d81d0 00000073
[    9.750870] Call Trace:
[    9.750870]  [<810545b9>] ? task_work_run+0x79/0xb0
[    9.750870]  [<81002358>] do_notify_resume+0x58/0x70
[    9.750870]  [<815f6bd0>] work_notifysig+0x2b/0x3b
[    9.750870] Code:  Bad EIP value.
[    9.750870] EIP: [<00000000>] 0x0 SS:ESP 0068:872c7f8c
[    9.750870] CR2: 0000000000000000
[    9.769399] ---[ end trace da54692b95c91495 ]---
[    9.777566] BUG: unable to handle kernel paging request at 05140060
[    9.778845] IP: [<81054594>] task_work_run+0x54/0xb0
[    9.779774] *pdpt = 0000000000000000 *pde = f000ff53f000ff53
[    9.780708] Oops: 0000 [#2] DEBUG_PAGEALLOC
[    9.781431] CPU: 0 PID: 85 Comm: hostname Tainted: G      D      3.12.0-rc1-00081-g6bfa687 #4
[    9.781721] task: 872c8000 ti: 872ca000 task.ti: 872ca000
[    9.781721] EIP: 0060:[<81054594>] EFLAGS: 00010206 CPU: 0
[    9.781721] EIP is at task_work_run+0x54/0xb0
[    9.781721] EAX: 05140060 EBX: 8729b900 ECX: 00000000 EDX: 05140060
[    9.781721] ESI: 872c8000 EDI: 872c8388 EBP: 872cbf3c ESP: 872cbf30
[    9.781721]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    9.781721] CR0: 8005003b CR2: 05140060 CR3: 072cc000 CR4: 000006b0
[    9.781721] Stack:
[    9.781721]  ffffffff 872af400 872c8000 872cbf8c 8103a02a 00000014 776cefb8 8105b49b
[    9.781721]  00000000 872cbfac 00000001 00000015 61636f6c 736f686c 6f6c2e74 872af458
[    9.781721]  69616d6f 872af46e 872af458 00000000 00000000 872ae980 872c8000 872cbfa4
[    9.781721] Call Trace:
[    9.781721]  [<8103a02a>] do_exit+0x2aa/0x920
[    9.781721]  [<8105b49b>] ? up_write+0x1b/0x30
[    9.781721]  [<8103a732>] do_group_exit+0x52/0xb0
[    9.781721]  [<8103a7a8>] SyS_exit_group+0x18/0x20
[    9.781721]  [<815f7130>] sysenter_do_call+0x12/0x3c
[    9.781721] Code: 36 31 c9 89 d0 0f b1 0f 39 c2 75 eb 85 d2 74 67 8d b4 26 00 00 00 00 f3 90 8b 86 c0 03 00 00 85 c0 74 f4 31 db eb 04 89 d3 89 c2 <8b> 02 89 1a 85 c0 75 f4 eb 16 66 90 f6 46 0c 04 74 c4 b9 04 d0
[    9.781721] EIP: [<81054594>] task_work_run+0x54/0xb0 SS:ESP 0068:872cbf30
[    9.781721] CR2: 0000000005140060
[    9.802246] ---[ end trace da54692b95c91496 ]---
[    9.802881] Fixing recursive fault but reboot is needed!
[    9.811986] BUG: unable to handle kernel paging request at 0805a000
[    9.812911] IP: [<81054594>] task_work_run+0x54/0xb0
[    9.813683] *pdpt = 00000000072e2001 *pde = 00000000072cf067 *pte = 0000000000000000
[    9.815024] Oops: 0000 [#3] DEBUG_PAGEALLOC
[    9.815623] CPU: 0 PID: 86 Comm: plymouthd Tainted: G      D      3.12.0-rc1-00081-g6bfa687 #4
[    9.816819] task: 872da000 ti: 872dc000 task.ti: 872dc000
[    9.817617] EIP: 0060:[<81054594>] EFLAGS: 00010206 CPU: 0
[    9.818394] EIP is at task_work_run+0x54/0xb0
[    9.819000] EAX: 0805a000 EBX: 872d3060 ECX: 00000000 EDX: 0805a000
[    9.819864] ESI: 872da000 EDI: 872da388 EBP: 872ddf3c ESP: 872ddf30
[    9.820769]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    9.820908] CR0: 8005003b CR2: 0805a000 CR3: 072b8000 CR4: 000006b0
[    9.820908] Stack:
[    9.820908]  00000001 00000405 00000000 872ddf4c 8104738c 872da000 00000001 872ddf94
[    9.820908]  810fb04b 00000002 00000001 00000000 810faf3a 872b92d8 872b9280 00000056
[    9.820908]  00000001 872d3408 00000056 085c82a8 00000000 872da214 00000000 872d2000
[    9.820908] Call Trace:
[    9.820908]  [<8104738c>] ptrace_notify+0x5c/0xa0
[    9.820908]  [<810fb04b>] do_execve+0x5fb/0x6f0
[    9.820908]  [<810faf3a>] ? do_execve+0x4ea/0x6f0
[    9.820908]  [<810fb37c>] SyS_execve+0x5c/0x70
[    9.820908]  [<815f7130>] sysenter_do_call+0x12/0x3c
[    9.820908] Code: 36 31 c9 89 d0 0f b1 0f 39 c2 75 eb 85 d2 74 67 8d b4 26 00 00 00 00 f3 90 8b 86 c0 03 00 00 85 c0 74 f4 31 db eb 04 89 d3 89 c2 <8b> 02 89 1a 85 c0 75 f4 eb 16 66 90 f6 46 0c 04 74 c4 b9 04 d0
[    9.820908] EIP: [<81054594>] task_work_run+0x54/0xb0 SS:ESP 0068:872ddf30
[    9.820908] CR2: 000000000805a000
[    9.836265] ---[ end trace da54692b95c91497 ]---
[    9.842439] BUG: unable to handle kernel paging request at 02c00060
[    9.843426] IP: [<81054594>] task_work_run+0x54/0xb0
[    9.844709] *pdpt = 00000000072c1001 *pde = 0000000000000000

> That said, Fengguang, can you try two things just to check:
> 
>  - add "cc" to the clobbers list for the asm goto (technically it
> should be on the non-asm-goto as well, but we never had that, and
> maybe the fact that gcc always ends up testing a register afterwards
> hides the need for the clobber).
> 
> So it would look like this in arch/x86/include/asm/rmwcc.h
> 
>   #define __GEN_RMWcc(fullop, var, cc, ...) \
>   do { \
>       asm volatile goto (fullop "; j" cc " %l[cc_label]" \
>           : : "m" (var), ## __VA_ARGS__ \
>           : "memory", "cc" : cc_label); \
>       return 0; \
>   cc_label: \
>       return 1; \
> 
> (where that "cc" thing is new). I'm not sure if "cc" really matters on
> x86 at all (it didn't use to, long long ago), but maybe it does these
> days..

Tests show that it makes no difference by adding the "cc" this way:

-                       : "memory" : cc_label);                         \
+                       : "memory", "cc" : cc_label);                           \
 
> If that makes no difference, please just verify that the non-asm-goto
> version works fine, by changing the
> 
>   #ifdef CC_HAVE_ASM_GOTO
> 
> into a simple "#if 0" to disable the asm-goto version.

Yeah, this will quiet the oops messages:

-#ifdef CC_HAVE_ASM_GOTO
+#if 0
 
 #define __GEN_RMWcc(fullop, var, cc, ...)                              \

Thanks,
Fengguang
