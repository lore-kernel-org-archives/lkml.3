Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaCWWVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 18:21:52 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:42170 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaCWWVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 18:21:51 -0400
MIME-Version: 1.0
In-Reply-To: <532F2C48.6050509@codeaurora.org>
References: <1392339850-18686-1-git-send-email-keescook@chromium.org>
	<1392339850-18686-3-git-send-email-keescook@chromium.org>
	<20140214162257.GB2331@e103592.cambridge.arm.com>
	<CAGXu5jLmYLQpu9CDhoL-2OTdwxqrfVCFbojmpjpcpLqmA=wWYA@mail.gmail.com>
	<20140217123415.GA2182@e103592.cambridge.arm.com>
	<532F2C48.6050509@codeaurora.org>
Date: Sun, 23 Mar 2014 16:21:50 -0600
X-Google-Sender-Auth: MA-q3KC44Fxk75ablycVyQ0cAzM
Message-ID: <CAGXu5jK_8adL=6DoF9gFBMWxKcxKUHw7238ighE2agFU7cqhWg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: mm: keep rodata non-executable
From: Kees Cook <keescook@chromium.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Dave Martin <Dave.Martin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Larry Bassel <lbassel@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Jiang Liu <liuj97@gmail.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 12:47 PM, Laura Abbott <lauraa@codeaurora.org> wrote:
> On 2/17/2014 4:34 AM, Dave Martin wrote:
>> On Fri, Feb 14, 2014 at 11:11:07AM -0800, Kees Cook wrote:
>>> On Fri, Feb 14, 2014 at 8:22 AM, Dave Martin <Dave.Martin@arm.com> wrote:
>>>> On Thu, Feb 13, 2014 at 05:04:10PM -0800, Kees Cook wrote:
>>>>> Introduce "CONFIG_DEBUG_RODATA" to mostly match the x86 config, though
>>>>> the behavior is different: it depends on STRICT_KERNMEM_PERMS, which
>>>>> sets rodata read-only (but executable), where as this option additionally
>>>>> splits rodata from the kernel text (resulting in potentially more memory
>>>>> lost to padding) and sets it non-executable as well. The end result is
>>>>> that on builds with CONFIG_DEBUG_RODATA=y (like x86) the rodata with be
>>>>> marked purely read-only.
>>>>
>>>> This triggers an Oops in kexec, because we have a block of code in .text
>>>> which is a template for generating baremetal code to relocate the new
>>>> kernel, and some literal words are written into it before copying.
>>>
>>> You're writing into the text area? I would imagine that
>>> CONFIG_ARM_KERNMEM_PERMS would break that. However, that's not the
>>> right place to be building code -- shouldn't the module area be used
>>> for that?
>>>
>>>> Possibly this should be in .rodata, not .text.
>>>
>>> Well, rodata should be neither writable nor executable.
>>
>> We're not writing into code exactly.
>>
>> This code is never executed in-place in vmlinux.  It gets copied, and
>> only copies are ever executed.
>>
>> Some pointers and offsets get poked into the code to configure it.
>>
>> I think it would be better simply to put the code in .rodata, and
>> poke paramaters into the copy, not the original -- but that's a bit
>> more awkward to code up, since the values can't be poked simply by
>> writing global variables.
>>
>>>
>>>> There may be a few other instances of this kind of thing.
>>>
>>> This config will certainly find them! :) But, that's why it's behind a config.
>>
>> I haven't tested exhaustively, but it think this is sufficient for a
>> Tested-by.  The patch does seem to be doing what it is intended to
>> do, and doesn't seem to be triggering false positives all over the
>> place.
>>
>>>
>>>> Are you aware of similar situations on other arches?
>>>
>>> I think there were some problems a long time ago on x86 for rodata too.
>>
>> It would be good to get this kexec case fixed -- I'll try to hack up
>> a separate patch.
>>
>
> FWIW, we've hit issues not just with kexec but kprobes as well. The same
> problems exist with this series:

For this stage, how about I make this "depends on KEXEC=n &&
KPROBES=n"? Then as these areas get fixed, we can drop those
requirements.

-Kees

>
> / # echo p:nl 0xc01d5c00 >> /sys/kernel/debug/tracing/kprobe_events
> / # echo 1 > /sys/kernel/debug/tracing/events/kprobes/nl/enable
> [ 1639.739629] Unable to handle kernel paging request at virtual address c01d5c00
> [ 1639.739655] pgd = edbc4000
> [ 1639.745730] [c01d5c00] *pgd=0001141e(bad)
> [ 1639.752413] Internal error: Oops: 80d [#1] PREEMPT SMP ARM
> [ 1639.752503] Modules linked in:
> [ 1639.760920] CPU: 0 PID: 58 Comm: sh Not tainted 3.14.0-rc7-next-20140318-00004-ga0191b7-dirty #170
> [ 1639.761015] task: edb90d80 ti: ed018000 task.ti: ed018000
> [ 1639.769870] PC is at patch_text+0x4/0x10
> [ 1639.775333] LR is at arm_kprobe+0x28/0x38
> [ 1639.779327] pc : [<c058acec>]    lr : [<c058bcc4>]    psr: 20000013
> [ 1639.779327] sp : ed019f10  ip : a0000013  fp : 01e7fb34
> [ 1639.783241] r10: 00000000  r9 : 01e80ab8  r8 : 00000002
> [ 1639.794517] r7 : ed019f80  r6 : ed900bc4  r5 : edb19fa0  r4 : edb19f08
> [ 1639.799727] r3 : c01d5c00  r2 : ed019f08  r1 : e7f001f8  r0 : c01d5c00
> [ 1639.806326] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [ 1639.812837] Control: 10c5787d  Table: 2dbc406a  DAC: 00000015
> [ 1639.820040] Process sh (pid: 58, stack limit = 0xed018240)
> [ 1639.825768] Stack: (0xed019f10 to 0xed01a000)
> [ 1639.831150] 9f00:                                     00000000 c058bd5c ed900ba0 c018b724
> [ 1639.835584] 9f20: ed6fab00 00000000 edb2d240 00000002 ed019f80 c018bdc4 ffffffff 00000001
> [ 1639.843743] 9f40: edb2d240 01e80ab8 ed019f80 00000002 00000002 c01e1b1c 01e7fb34 c011c3c0
> [ 1639.851902] 9f60: 00000003 00000000 00000000 edb2d240 edb2d240 00000002 01e80ab8 c01e2108
> [ 1639.860063] 9f80: 00000000 00000000 00200200 00157ecc 00000001 01e80ab8 00000004 c0106e64
> [ 1639.868222] 9fa0: ed018000 c0106ce0 00157ecc 00000001 00000001 01e80ab8 00000002 00000000
> [ 1639.876381] 9fc0: 00157ecc 00000001 01e80ab8 00000004 00000020 01e7fb48 01e7fb14 01e7fb34
> [ 1639.884542] 9fe0: 00000000 bef4562c 0001ee5d 0000a8cc 60000010 00000001 00000000 00000000
> [ 1639.892709] [<c058acec>] (patch_text) from [<c058bcc4>] (arm_kprobe+0x28/0x38)
> [ 1639.900862] [<c058bcc4>] (arm_kprobe) from [<c058bd5c>] (enable_kprobe+0x88/0x94)
> [ 1639.907983] [<c058bd5c>] (enable_kprobe) from [<c018b724>] (__ftrace_event_enable_disable+0x13c/0x200)
> [ 1639.915537] [<c018b724>] (__ftrace_event_enable_disable) from [<c018bdc4>] (event_enable_write+0x78/0xd4)
> [ 1639.924741] [<c018bdc4>] (event_enable_write) from [<c01e1b1c>] (vfs_write+0xac/0x188)
> [ 1639.934372] [<c01e1b1c>] (vfs_write) from [<c01e2108>] (SyS_write+0x40/0x94)
> [ 1639.942187] [<c01e2108>] (SyS_write) from [<c0106ce0>] (ret_fast_syscall+0x0/0x30)
> [ 1639.949386] Code: e4831004 e1a01003 eaee298d e1a03000 (e4831004)
> [ 1639.956766] ---[ end trace b548269e2c7a3190 ]---
>
>
> We had some functions that allowed the text to be temporarily made writable but something
> uniform for kexec would be useful as well (our kexec solution has been 'turn it off')
>
>
>> Cheers
>> ---Dave
>>
>
> Thanks,
> Laura
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation



-- 
Kees Cook
Chrome OS Security
