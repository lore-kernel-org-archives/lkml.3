Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3KVCga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:36:30 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:45153 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3KVCg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:36:28 -0500
MIME-Version: 1.0
In-Reply-To: <894043206.72860.1385085446389.JavaMail.zimbra@efficios.com>
References: <52803E5D.3050109@mentor.com>
	<1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
	<CA+55aFw923sA0E1RQNxFF0OWFtAfcaG-dBUc-0YYZGDSAsaQyg@mail.gmail.com>
	<528E2E8E.8080004@ahsoftware.de>
	<CA+55aFyNZun07BLoD2KQFT7cN1xsiQ2gE6hYwRvOGa3tCap4CQ@mail.gmail.com>
	<528E94E2.3080102@ahsoftware.de>
	<CANxoKds1iLpXK0yb1qW_Z4tLSRccrf69nYUV7mLSJBMwSrjwmQ@mail.gmail.com>
	<20131122003904.GT892@tucnak.redhat.com>
	<894043206.72860.1385085446389.JavaMail.zimbra@efficios.com>
Date: Thu, 21 Nov 2013 18:36:27 -0800
Message-ID: <CANxoKdsUjG4McOVR8A3dZekNmCwyEztJ7rabCJ8p-G7mNmjiLA@mail.gmail.com>
Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
From: Luis Lozano <llozano@google.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Jakub Jelinek <jakub@redhat.com>, Alexander Holler <holler@ahsoftware.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bhaskar Janakiraman <bjanakiraman@chromium.org>,
        Han Shen <shenhan@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Yes the problem we were seeing with GCC bug 58854 is that an interrupt
handler was corrupting the stack of a routine which had an invalid
value of SP (not really on "top" of the stack) for part of the
routine.
But in the assembly code you sent, I don't see where sp is being
modified... or where the access to "below" sp is happening.
In GCC bug 58854 it was pretty clear that the restore of the sp
register in the epilogue is moved to somewhere close to the prologue
of the routine.
Are we missing some diffs from the assembly comparison?

Thanks

Luis




On Thu, Nov 21, 2013 at 5:57 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> ----- Original Message -----
>> From: "Jakub Jelinek" <jakub@redhat.com>
>> To: "Luis Lozano" <llozano@google.com>
>> Cc: "Alexander Holler" <holler@ahsoftware.de>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Mathieu Desnoyers"
>> <mathieu.desnoyers@efficios.com>, "Richard Henderson" <rth@twiddle.net>, "Linux Kernel Mailing List"
>> <linux-kernel@vger.kernel.org>, "Will Deacon" <will.deacon@arm.com>, "Catalin Marinas" <catalin.marinas@arm.com>,
>> "Peter Zijlstra" <peterz@infradead.org>, lttng-dev@lists.lttng.org, "Nathan Lynch" <Nathan_Lynch@mentor.com>, "Paul
>> E. McKenney" <paulmck@linux.vnet.ibm.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Bhaskar Janakiraman"
>> <bjanakiraman@chromium.org>, "Han Shen" <shenhan@chromium.org>
>> Sent: Thursday, November 21, 2013 7:39:04 PM
>> Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
>>
>> On Thu, Nov 21, 2013 at 03:45:35PM -0800, Luis Lozano wrote:
>> > I think we need a reproducer. Without this we may all be going on the
>> > wrong path. This whole conversation started on an *assumption* that
>> > some accesses were being reordered.
>> >
>> > evidence of the reorder or reproducer please?
>>
>> Yeah, if a compiler bug is suspected, can anybody please open
>> a bugreport in http://gcc.gnu.org/bugzilla/ with the preprocessed source,
>> compiler version, flags and how it was configured and some hint in which
>> function to look for what exactly?  We don't necessarily need a runtime
>> small reproducer, but if it can be shown in the assembly what has been
>> reordered and why you think it shouldn't, with the above mentioned input
>> that ought to be sufficient.  Thanks.
>
> OK OK, let me reply on list first so I can share the result of a full day
> of bug hunting. We're not there yet, but many options have been eliminated.
>
> The issue shows up in stress test, when tracing with lttng-modules 2.4-rc1,
> on ARM. It's been reproduced with a Linux kernel 3.12 so far, with lttng-modules
> compiled against that kernel.
>
> First, I asked Nathan to compile his kernel with gcc 4.7, and lttng-modules
> with gcc 4.8.x (and vice-versa). The problem only appears when lttng-modules
> are compiled with gcc 4.8.x. The compiler version used to compile the rest
> of the kernel does not matter.
>
> Then I looked at gcc 4.8 changelog for ARM, new feature: -fno-sched-pressure
> (sched pressure is there by default). Nathan tried compiling lttng-modules with
> -fno-sched-pressure. The problem still reproduces.
>
> Knowing that adding barrier() outside of preempt_disable()/enable() was
> fixing the issue, we tried identifying which code location was responsible
> for working around the issue. Skipping a long investigation, here is the
> executive summary:
>
> http://git.lttng.org/?p=lttng-modules.git;a=blob;f=lttng-ring-buffer-client.h;h=50c47b3bf49f6c2dd24e250cf1a9b97808cd8e27;hb=HEAD
>
> Has the following function. We identified that adding a barrier() as shown below
> works around the issue:
>
> static
> int lttng_event_reserve(struct lib_ring_buffer_ctx *ctx,
>                       uint32_t event_id)
> {
>         struct lttng_channel *lttng_chan = channel_get_private(ctx->chan);
>         int ret, cpu;
>
>         cpu = lib_ring_buffer_get_cpu(&client_config);
>         if (cpu < 0)
>                 return -EPERM;
>         ctx->cpu = cpu;
>
>         switch (lttng_chan->header_type) {
>         case 1: /* compact */
>                 if (event_id > 30)
>                         ctx->rflags |= LTTNG_RFLAG_EXTENDED;
>                 break;
>         case 2: /* large */
>                 if (event_id > 65534)
>                         ctx->rflags |= LTTNG_RFLAG_EXTENDED;
>                 break;
>         default:
>                 WARN_ON_ONCE(1);
>         }
>
>         ret = lib_ring_buffer_reserve(&client_config, ctx);
>         if (ret)
>                 goto put;
>         lttng_write_event_header(&client_config, ctx, event_id);
>         return 0;
> put:
>         lib_ring_buffer_put_cpu(&client_config);
>         ---------------> barrier() added here; <----------------------------
>         return ret;
> }
>
> Where barrier() is the usual asm volatile with "memory" clobber, nothing else.
>
> Nathan gave me the binary diff for the assembly generated for this function without
> the barrier and with the barrier:
>
> --- /tmp/lttng_event_reserve-4.8.2.dump 2013-11-21 11:14:14.536495079 -0600
> +++ /tmp/lttng_event_reserve-with-barrier-4.8.2.dump    2013-11-21 14:12:52.997355907 -0600
> @@ -7,11 +7,11 @@
>       f10:      ebfffffe        bl      0 <__gnu_mcount_nc>
>       f14:      e5903000        ldr     r3, [r0]
>       f18:      e1a04000        mov     r4, r0
> -     f1c:      e50b1048        str     r1, [fp, #-72]  ; 0xffffffb8
> +     f1c:      e1a0000d        mov     r0, sp
>       f20:      e5936030        ldr     r6, [r3, #48]   ; 0x30
> -     f24:      e1a0000d        mov     r0, sp
> -     f28:      e3c03d7f        bic     r3, r0, #8128   ; 0x1fc0
> -     f2c:      e3c3303f        bic     r3, r3, #63     ; 0x3f
> +     f24:      e3c03d7f        bic     r3, r0, #8128   ; 0x1fc0
> +     f28:      e3c3303f        bic     r3, r3, #63     ; 0x3f
> +     f2c:      e50b1048        str     r1, [fp, #-72]  ; 0xffffffb8
>       f30:      e5932004        ldr     r2, [r3, #4]
>       f34:      e2822001        add     r2, r2, #1
>       f38:      e5832004        str     r2, [r3, #4]
> @@ -53,7 +53,7 @@
>       fc8:      e3c3303f        bic     r3, r3, #63     ; 0x3f
>       fcc:      e5933000        ldr     r3, [r3]
>       fd0:      e3130002        tst     r3, #2
> -     fd4:      0a000000        beq     fdc <lttng_event_reserve+0xe0>
> +     fd4:      0a0002be        beq     1ad4 <lttng_event_reserve+0xbd8>
>       fd8:      ebfffffe        bl      0 <preempt_schedule>
>       fdc:      ea0002bc        b       1ad4 <lttng_event_reserve+0xbd8>
>       fe0:      e3500000        cmp     r0, #0
>
> We tried disabling the ftrace function tracing to get mcount out of the way,
> and the problem still reproduces.
>
> I'm stopping here in terms of details about the disassembly, because I
> need to double check with Nathan that I get the right disassembly for the right
> cases. I also terribly need to setup a 4.8.2 ARM cross-compiler on my machine.
>
> I'm attaching Nathan's ARM configuration.
>
> It does look behave a bit like this bug pointed out by Luis:
>
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854
>
> AFAIU (please correct me if I am wrong), ARM's interrupt handler run
> on top of the thread stack (?). If it's the case, then anything stored
> on the stack below "sp" could be overwritten by an interrupt handler.
> This would fit well the reproduction scenario for this bug: Nathan runs
> LTTng tracing of kmem_cache_free tracepoint with hackbench running.
> A race between a short window of stack use below sp and interrupt handlers
> would trigger with this kind of stress-test.
>
> Thoughts ?
>
> Thanks,
>
> Mathieu
>
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com



-- 

Luis A. Lozano | Software Engineer | llozano@google.com | +1 (408)431-5164
