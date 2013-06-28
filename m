Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3F1UZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:25:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:13006 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab3F1UZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:25:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,961,1363158000"; 
   d="scan'208";a="361304675"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Peng Tao <bergwolf@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/11] staging/lustre: fix build error on non-x86
 platforms
Thread-Topic: [PATCH 07/11] staging/lustre: fix build error on non-x86
 platforms
Thread-Index: AQHOcTnUNMJzu5fVW0i9d9vAV44YFZlGKKUAgAAIBwD//8zOPYABBFmAgAEl7YCAA4HWAA==
Date: Fri, 28 Jun 2013 20:25:33 +0000
Message-ID: <CDF347C9.4D880%andreas.dilger@intel.com>
In-Reply-To: <CA+a=Yy48DH0q7-m8J0r-0oBGLbEBx5AwrBKCEb2pZ3AsPJg-Xw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.24.153]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9C17AB6BB281A641B08147B1DEE10350@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/26/06 2:52 AM, "Peng Tao" <bergwolf@gmail.com> wrote:
>On Tue, Jun 25, 2013 at 11:20 PM, Greg Kroah-Hartman
><gregkh@linuxfoundation.org> wrote:
>> On Tue, Jun 25, 2013 at 06:48:14AM +0000, Dilger, Andreas wrote:
>>> On 2013-06-24, at 20:51, "Peng Tao" <bergwolf@gmail.com> wrote:
>>> > On Tue, Jun 25, 2013 at 10:22 AM, Greg Kroah-Hartman
>>> > <gregkh@linuxfoundation.org> wrote:
>>> >> On Tue, Jun 25, 2013 at 08:15:21AM +0800, Peng Tao wrote:
>>> >>> dump_trace() is only available on X86. Without it, Lustre's own
>>> >>> watchdog is broken. We can only dump current task's stack.
>>> >>>
>>> >>> We may switch to kernel's watchdog eventually?
>>> >>>
>>> >>> Signed-off-by: Peng Tao <tao.peng@emc.com>
>>> >>> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>>> >>> ---
>>> >>> .../lustre/lustre/libcfs/linux/linux-debug.c       |   16
>>>++++++++++------
>>> >>> 1 file changed, 10 insertions(+), 6 deletions(-)
>>> >>>
>>> >>> diff --git 
>>>a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
>>>b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
>>> >>> index e2c195b..5cc5138 100644
>>> >>> --- a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
>>> >>> +++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
>>> >>> @@ -179,28 +179,25 @@ void lbug_with_loc(struct
>>>libcfs_debug_msg_data *msgdata)
>>> >>>              schedule();
>>> >>> }
>>> >>>
>>> >>> -
>>> >>> +#ifdef CONFIG_X86
>>> >>> #include <linux/nmi.h>
>>> >>> #include <asm/stacktrace.h>
>>> >>>
>>> >>> -
>>> >>> static int print_trace_stack(void *data, char *name)
>>> >>> {
>>> >>>      printk(" <%s> ", name);
>>> >>>      return 0;
>>> >>> }
>>> >>>
>>> >>> -# define RELIABLE reliable
>>> >>> -# define DUMP_TRACE_CONST const
>>> >>> static void print_trace_address(void *data, unsigned long addr,
>>>int reliable)
>>> >>> {
>>> >>>      char fmt[32];
>>> >>>      touch_nmi_watchdog();
>>> >>> -     sprintf(fmt, " [<%016lx>] %s%%s\n", addr, RELIABLE ? "": "?
>>>");
>>> >>> +     sprintf(fmt, " [<%016lx>] %s%%s\n", addr, reliable ? "": "?
>>>");
>>> >>>      __print_symbol(fmt, addr);
>>> >>
>>> >> Please just delete this function, and all of the other tracing
>>>code, as
>>> >> it's not needed, the kernel provides all of this for you just fine.
>>> >>
>>> > Andreas mentioned that the default timeout of kernel watchdog is too
>>> > short for Lustre. Other than that, are there any other reasons for
>>> > keeping Lustre private watchdog, Andreas? We may ask users to
>>>increase
>>> > the default timeout if 120s is too short, can we?
>>>
>>> The other problem with the kernel tracing code is that it doesn't allow
>>> dumping the stack of some other thread, which this code allows.
>>
>> Then fix the kernel tracing code, don't go reinventing things in
>> individual drivers.
>>
>Andreas,
>
>I've taken a look at Lustre's timer-based watchdog implementation.
>Since it is the first time I looked at the piece of code, my
>understanding might be wrong. Please correct me if it is.

No, looks like you understand what is going on.

>From the code, Lustre has a global watchdog item list, and for every
>ptlrpc service thread, once it is waked up and running, it must finish
>servicing and go to sleep again within the timeout limit set during
>creating the watchdog item. Otherwise, Lustre private watchdog wakes
>up and dumps all timeout ptlrpc threads (and that's where we need the
>ability to dump stacks of other threads).

Right.  This watchdog works regardless of NMI or other hardware support.

>In the meantime, kernel's watchdog is still working for Lustre
>threads, because we don't have methods to disable it unless users
>explicitly do it via proc.
>
>And I'm wondering the purpose of Lustre private watchdog. IMO it can
>detect three kinds of issues:
>1. stuck process due to long server/disk response time or real
>deadlock. It can be detected by kernel's soft/hard lockup watchdog as
>well.
>2. live lock. Kernel's watchdog cannot detect this kind of issues.
>3. really long service time without deadlocking/livelocking. Lustre
>prints a warning message when servicing is done.
>
>1 is replaceable with kernel's watchdog.

I believe (1) only works if a thread is running for a very long time
without any schedule or blocking operation.

> 3 can be re-implemented with a time check at the start and end of each
>servicing round.

That is only useful if the RPC operation actually finishes.  It doesn't
help
if the thread is sleeping forever in a distributed lock enqueue or so.  The
message printed at the end is mostly just to help debugging if the thread
eventually came back to life (this can happen sometimes if a client holding
a lock is evicted, or some lengthy timeout expires), but the important
thing
is the stack trace of when the thread was actually blocked, and presumably
the other threads that also get blocked if it is a deadlock.

The other useful difference with the Lustre watchdog is that it has
variable
timeouts on a per-thread basis, not a single global timeout for all kernel
threads, since we know which threads are accessing disks, which are doing
network RPCs, which are in-memory only, etc.

>2 is left in question. So I want to confirm with you if detecting live
>locks is
>the real reason for Lustre to implement the private watchdog. If we do
>need the feature, I think we should push it to generic watchdog as a
>new watchdog implementation in addition to softlockup/hardlockup
>watchdogs. Otherwise, we can just remove the private watchdog. Please
>share your thoughts. Thanks!

I think both (2) and (3) are not available in the existing kernel NMI
watchdog.
I'd of course be fine if this functionality is available in the kernel
watchdog
code

>>> So if the current kernel code can do this, great, we can change over to
>>> using that, but if it doesn't I'd rather keep this functionality in
>>>place until
>>> it can.
>>
>> Again, no, don't do things in a driver like "tracing" that should be in
>> the kernel core properly.
>>
>>> I also think it makes sense to fix these kinds of issues in separate
>>>patches,
>>> instead of tying them all into the same patches to fix built problems
>>>on
>>> various architectures. Otherwise, the patches start getting bigger and
>>> bigger as they drag in more fixes.
>>
>> I agree, but deleting tracing code that doesn't work on all arches is a
>> simple patch to apply :)
>>
>> Given that my tree is now closed for 3.11 stuff, you all have plenty of
>> time to get things working properly.
>
>Since it takes time to patch kernel's generic watchdog, can we get
>this patch in so that we have a build-able Lustre base, and then we
>can work on push necessary bits to kernel watchdog? I understand that
>we shouldn't reinvent things. Just don't want it to be a blocking
>issue for build and if we simply delete it, we lose a feature that is
>still missing in kernel watchdog.

I would tend to agree with this.  The goal of the staging tree isn't to fix
everything in Lustre at once, but to give us the chance to fix it
incrementally,
and to be included in the kernel development process instead of remaining
outside.  If we keep getting blocked for weeks (?) having to develop new
functionality and get it accepted into the mainline kernel (staging doesn't
take any patches outside drivers/staging, AFAIK) in order to fix
compilation
bugs, it means that Lustre will continue to be disabled and missing out on
build/test in -next while these longer-term issues are fixed.

My preference would be to fix the compilation bugs in the obvious manner,
and
then fix the structural issues incrementally while keeping the code
building
and testing under drivers/staging/.  We've been developing Lustre for over
ten
years, so I don't think the code will be cleaned up overnight, nor is
there a
risk we will "dump and run" once it is in drivers/staging in the upstream
kernel.

I expect it to take a year or more to clean up the code to be acceptable
to move
into fs/lustre, and this will also require porting the upstream kernel
changes
back to the Lustre master branch, so they both stay in sync.  There are
ongoing
feature developments on the Lustre master branch, and we can't stop
development
for a year waiting until the client is accepted into the kernel, and I
also don't
want the two versions to get too far out of sync.

So, while I agree with moving this watchdog code into the main kernel
(assuming
it will be accepted, I don't think that is a given) I don't think it
should be a
blocker.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


