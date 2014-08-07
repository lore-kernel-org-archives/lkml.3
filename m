Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaHGRdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:33:44 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:52845 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbaHGRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:33:43 -0400
Message-ID: <53E3B874.80008@gmail.com>
Date: Thu, 07 Aug 2014 10:33:40 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Wei.Yang@windriver.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH v1] MIPS: perf: Mark pmu interupt IRQF_NO_THREAD
References: <1407217067-1144-1-git-send-email-Wei.Yang@windriver.com> <20140807114831.GB29898@linux-mips.org>
In-Reply-To: <20140807114831.GB29898@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 04:48 AM, Ralf Baechle wrote:
> On Tue, Aug 05, 2014 at 01:37:47PM +0800, Wei.Yang@windriver.com wrote:
>
>> From: Yang Wei <Wei.Yang@windriver.com>
>>
>> In RT kernel, I ran into the following calltrace, so PMU interrupts cannot
>> be threaded
>>
>> in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/0
>> INFO: lockdep is turned off.
>> Call Trace:
>> [<ffffffff8088595c>] dump_stack+0x1c/0x50
>> [<ffffffff801a958c>] __might_sleep+0x13c/0x148
>> [<ffffffff80891c54>] rt_spin_lock+0x3c/0xb0
>> [<ffffffff801ad29c>] __wake_up+0x3c/0x80
>> [<ffffffff80243ba4>] perf_event_wakeup+0x8c/0xf8
>> [<ffffffff80243c50>] perf_pending_event+0x40/0x78
>> [<ffffffff8023d88c>] irq_work_run+0x74/0xc0
>> [<ffffffff80152640>] mipsxx_pmu_handle_shared_irq+0x110/0x228
>> [<ffffffff8015276c>] mipsxx_pmu_handle_irq+0x14/0x30
>> [<ffffffff801ffda4>] handle_irq_event_percpu+0xbc/0x470
>> [<ffffffff80204478>] handle_percpu_irq+0x98/0xc8
>> [<ffffffff801ff284>] generic_handle_irq+0x4c/0x68
>> [<ffffffff8089748c>] do_IRQ+0x2c/0x48
>> [<ffffffff80105864>] plat_irq_dispatch+0x64/0xd0
>
> Hm...  I don't see why based on this backtrace you concluce the
> handler needs to be marked IRQF_NO_THREAD.  However there's another
> reason to mark it IRQF_NO_THREAD.  IRQ threads may be rescheduled to
> other CPUs but this handler is fiddling with per-CPU resources.
>

Also by its nature, the profiling code needs synchronous access to the 
register state of the interrupted code.  If you are running on a 
different thread, then I don't think this would be available.

> See https://patchwork.linux-mips.org/patch/2818/ for a similar
> scenario a few years ago.
>
>    Ralf
>
>

