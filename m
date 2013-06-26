Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab3FZIx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:53:27 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61209 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3FZIwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:52:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130625152003.GB20244@kroah.com>
References: <1372119326-3565-1-git-send-email-bergwolf@gmail.com>
 <1372119326-3565-8-git-send-email-bergwolf@gmail.com> <20130625022244.GG18752@kroah.com>
 <CA+a=Yy6GD6xAG=qULGbwOA1wCt-seVtCv1tufGvmmO-jpbgL3A@mail.gmail.com>
 <220AF645-E299-4B35-9E15-858C7A10FF3E@intel.com> <20130625152003.GB20244@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 26 Jun 2013 16:52:03 +0800
Message-ID: <CA+a=Yy48DH0q7-m8J0r-0oBGLbEBx5AwrBKCEb2pZ3AsPJg-Xw@mail.gmail.com>
Subject: Re: [PATCH 07/11] staging/lustre: fix build error on non-x86 platforms
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Removing devel@driverdev.osuosl.org because I am getting delivery
failure report for every mail sent to it... ]
[ Adding LKML so that we can have a public record of the discussion
(and possibly wilder opinions). ]

On Tue, Jun 25, 2013 at 11:20 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jun 25, 2013 at 06:48:14AM +0000, Dilger, Andreas wrote:
>> On 2013-06-24, at 20:51, "Peng Tao" <bergwolf@gmail.com> wrote:
>> > On Tue, Jun 25, 2013 at 10:22 AM, Greg Kroah-Hartman
>> > <gregkh@linuxfoundation.org> wrote:
>> >> On Tue, Jun 25, 2013 at 08:15:21AM +0800, Peng Tao wrote:
>> >>> dump_trace() is only available on X86. Without it, Lustre's own
>> >>> watchdog is broken. We can only dump current task's stack.
>> >>>
>> >>> We may switch to kernel's watchdog eventually?
>> >>>
>> >>> Signed-off-by: Peng Tao <tao.peng@emc.com>
>> >>> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>> >>> ---
>> >>> .../lustre/lustre/libcfs/linux/linux-debug.c       |   16 ++++++++++------
>> >>> 1 file changed, 10 insertions(+), 6 deletions(-)
>> >>>
>> >>> diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
>> >>> index e2c195b..5cc5138 100644
>> >>> --- a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
>> >>> +++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
>> >>> @@ -179,28 +179,25 @@ void lbug_with_loc(struct libcfs_debug_msg_data *msgdata)
>> >>>              schedule();
>> >>> }
>> >>>
>> >>> -
>> >>> +#ifdef CONFIG_X86
>> >>> #include <linux/nmi.h>
>> >>> #include <asm/stacktrace.h>
>> >>>
>> >>> -
>> >>> static int print_trace_stack(void *data, char *name)
>> >>> {
>> >>>      printk(" <%s> ", name);
>> >>>      return 0;
>> >>> }
>> >>>
>> >>> -# define RELIABLE reliable
>> >>> -# define DUMP_TRACE_CONST const
>> >>> static void print_trace_address(void *data, unsigned long addr, int reliable)
>> >>> {
>> >>>      char fmt[32];
>> >>>      touch_nmi_watchdog();
>> >>> -     sprintf(fmt, " [<%016lx>] %s%%s\n", addr, RELIABLE ? "": "? ");
>> >>> +     sprintf(fmt, " [<%016lx>] %s%%s\n", addr, reliable ? "": "? ");
>> >>>      __print_symbol(fmt, addr);
>> >>
>> >> Please just delete this function, and all of the other tracing code, as
>> >> it's not needed, the kernel provides all of this for you just fine.
>> >>
>> > Andreas mentioned that the default timeout of kernel watchdog is too
>> > short for Lustre. Other than that, are there any other reasons for
>> > keeping Lustre private watchdog, Andreas? We may ask users to increase
>> > the default timeout if 120s is too short, can we?
>>
>> The other problem with the kernel tracing code is that it doesn't allow
>> dumping the stack of some other thread, which this code allows.
>
> Then fix the kernel tracing code, don't go reinventing things in
> individual drivers.
>
Andreas,

I've taken a look at Lustre's timer-based watchdog implementation.
Since it is the first time I looked at the piece of code, my
understanding might be wrong. Please correct me if it is.

>From the code, Lustre has a global watchdog item list, and for every
ptlrpc service thread, once it is waked up and running, it must finish
servicing and go to sleep again within the timeout limit set during
creating the watchdog item. Otherwise, Lustre private watchdog wakes
up and dumps all timeout ptlrpc threads (and that's where we need the
ability to dump stacks of other threads).

In the meantime, kernel's watchdog is still working for Lustre
threads, because we don't have methods to disable it unless users
explicitly do it via proc.

And I'm wondering the purpose of Lustre private watchdog. IMO it can
detect three kinds of issues:
1. stuck process due to long server/disk response time or real
deadlock. It can be detected by kernel's soft/hard lockup watchdog as
well.
2. live lock. Kernel's watchdog cannot detect this kind of issues.
3. really long service time without deadlocking/livelocking. Lustre
prints a warning message when servicing is done.

1 is replaceable with kernel's watchdog. 3 can be re-implemented with
a time check at the start and end of each servicing round. 2 is left
in question. So I want to confirm with you if detecting live locks is
the real reason for Lustre to implement the private watchdog. If we do
need the feature, I think we should push it to generic watchdog as a
new watchdog implementation in addition to softlockup/hardlockup
watchdogs. Otherwise, we can just remove the private watchdog. Please
share your thoughts. Thanks!

>> So if the current kernel code can do this, great, we can change over to
>> using that, but if it doesn't I'd rather keep this functionality in place until
>> it can.
>
> Again, no, don't do things in a driver like "tracing" that should be in
> the kernel core properly.
>
>> I also think it makes sense to fix these kinds of issues in separate patches,
>> instead of tying them all into the same patches to fix built problems on
>> various architectures. Otherwise, the patches start getting bigger and
>> bigger as they drag in more fixes.
>
> I agree, but deleting tracing code that doesn't work on all arches is a
> simple patch to apply :)
>
> Given that my tree is now closed for 3.11 stuff, you all have plenty of
> time to get things working properly.
>
Greg,

Since it takes time to patch kernel's generic watchdog, can we get
this patch in so that we have a build-able Lustre base, and then we
can work on push necessary bits to kernel watchdog? I understand that
we shouldn't reinvent things. Just don't want it to be a blocking
issue for build and if we simply delete it, we lose a feature that is
still missing in kernel watchdog.

Thanks,
Tao
