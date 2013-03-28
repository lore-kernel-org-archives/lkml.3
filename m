Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3C1L7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 07:59:03 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44760 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3C1L7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 07:59:01 -0400
Message-ID: <51543084.9070004@arm.com>
Date: Thu, 28 Mar 2013 11:59:00 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will@willdeacon.co.uk>, Lokesh Vutla <lokeshvutla@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if system
 supports 'has_ossr'
References: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com> <51406BA7.8010306@arm.com> <51407120.7030709@ti.com> <51417E58.5050501@ti.com> <20130315050014.GA15706@tiny-lites> <5146B972.1010002@ti.com> <20130318150724.GC28585@mudshark.cambridge.arm.com> <514736D4.4070906@ti.com> <20130318170649.GA29585@mudshark.cambridge.arm.com> <5148082A.3060503@ti.com> <20130319102803.GB22452@mudshark.cambridge.arm.com>
In-Reply-To: <20130319102803.GB22452@mudshark.cambridge.arm.com>
X-MC-Unique: 113032811585902701
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/13 10:28, Will Deacon wrote:
> On Tue, Mar 19, 2013 at 06:39:38AM +0000, Santosh Shilimkar wrote:
>> On Monday 18 March 2013 10:36 PM, Will Deacon wrote:
>>> Any chance you could follow up with your firmware/hardware guys about this
>>> please? I'd really like to understand how we end up in this state in case we
>>> can do something in the architecture to stop it from happening in future.
>>>
>> I will check on this part and update you when I hear from them.
>
> Ok, thanks.
>
> Dietmar -- I seem to remember that you thought GDB did actually work with
> hardware breakpoints on Pandaboard across low-power states. Can you
> confirm/deny this please?

Sorry for the late response.

I did some testing on my Pandaboard trying to set hwbp from gdb.

System is a vanilla Linaro 13.02.
gdb is (GNU gdb (GDB) 7.5.1), build from tag gdb_7_5_1-2012-11-29-release

(gdb) hb *0x00008440
Hardware assisted breakpoint 2 at 0x8440: file test.c, line 14.
(gdb) c
Continuing.
Unexpected error setting breakpoint address: No such device.

With additional kernel logs:

[<c0011597>] (unwind_backtrace+0x1/0x92) from [<c0012603>]
(arch_validate_hwbkpt_settings+0x23/0x1d4)
[<c0012603>] (arch_validate_hwbkpt_settings+0x23/0x1d4) from
[<c0088aa9>] (register_perf_hw_breakpoint+0x19/0x30)
[<c0088aa9>] (register_perf_hw_breakpoint+0x19/0x30) from [<c0088ae9>]
(hw_breakpoint_event_init+0x29/0x48)
[<c0088ae9>] (hw_breakpoint_event_init+0x29/0x48) from [<c0086c81>]
(perf_init_event+0x79/0xcc)
[<c0086c81>] (perf_init_event+0x79/0xcc) from [<c0086e97>]
(perf_event_alloc+0x1c3/0x32c)
[<c0086e97>] (perf_event_alloc+0x1c3/0x32c) from [<c00871eb>]
(perf_event_create_kernel_counter+0x19/0xc6)
[<c00871eb>] (perf_event_create_kernel_counter+0x19/0xc6) from
[<c00885e9>] (register_user_hw_breakpoint+0x2d/0x38)
[<c00885e9>] (register_user_hw_breakpoint+0x2d/0x38) from [<c03dd723>]
(ptrace_hbp_create+0x53/0x5c)
[<c03dd723>] (ptrace_hbp_create+0x53/0x5c) from [<c000e0d7>]
(ptrace_sethbpregs+0x95/0x1a6)
[<c000e0d7>] (ptrace_sethbpregs+0x95/0x1a6) from [<c000e777>]
(arch_ptrace+0x3bf/0x3ec)
[<c000e777>] (arch_ptrace+0x3bf/0x3ec) from [<c002f621>]
(sys_ptrace+0x251/0x278)
[<c002f621>] (sys_ptrace+0x251/0x278) from [<c000c781>]
(ret_fast_syscall+0x1/0x52)
perf_event_create_kernel_counter:6721 ret=-19
ptrace_sethbpregs:557 ret=-19

The call to monitor_mode_enabled() in arch_validate_hwbkpt_settings()
fails since DSCR.15 MDBGen is not set:

monitor_mode_enabled:239 dscr=0x1030002

I don't get the warning "Failed to enable monitor mode on CPU" during
system start-up though.

Doing the same on my TC2 gives me:

monitor_mode_enabled:239 dscr=0x2008002

So I guess that setting hwbp from self-hosted debugger on Pandaboard is
not possible at all.

There is no CPUidle enabled on Linaro 13.02 Pandaboard.

-- Dietmar


>
>>> Well, we could just add the warn_once prints but that doesn't stop debug
>>> from breaking after the first pm/suspend/hotplug operation.
>>>
>> Probably we should drop the $subject patch approach and use warn_once
>> at least for current rc. Ofcourse it doesn't help to get working
>> hw_breakpoint support. Patch end of the email with warn_once.
>
> Yeah, I'll merge that, but it's a real shame that this breaks hardware debug
> on one of the few platforms where it was reported to work.
>
> Will
>

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

