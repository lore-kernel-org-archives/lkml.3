Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853Ab3KWFA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 00:00:57 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57006 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3KWFAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 00:00:55 -0500
MIME-Version: 1.0
In-Reply-To: <20131122120733.GP3866@twins.programming.kicks-ass.net>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
	<tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
	<CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
	<20131121150344.GG10022@twins.programming.kicks-ass.net>
	<CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
	<20131122120733.GP3866@twins.programming.kicks-ass.net>
Date: Fri, 22 Nov 2013 21:00:54 -0800
X-Google-Sender-Auth: nImb3hmrPWY5Kfcxobz2ZlZCBa8
Message-ID: <CAE9FiQX4++Y_eK8qP0vsJMmE9xXHECjpAZwqD4iv569HGJAziQ@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 4:07 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Nov 21, 2013 at 09:22:24AM -0800, Yinghai Lu wrote:
>> On Thu, Nov 21, 2013 at 7:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >>
>> >> This one seems fix NULL reference in compute_group_power.
>> >>
>> >> but get following on current Linus tree plus tip/sched/urgent.
>> >>
>> >> divide error: 0000 [#1]  SMP
>> >> [   28.190477] Modules linked in:
>> >> [   28.192012] CPU: 11 PID: 484 Comm: kworker/u324:0 Not tainted
>> >> 3.12.0-yh-10487-g4b94e59-dirty #2044
>> >> [   28.210488] Hardware name: Oracle Corporation  Sun Fire
>> >> [   28.229877] task: ffff88ff25205140 ti: ffff88ff2520a000 task.ti:
>> >> ffff88ff2520a000
>> >> [   28.236139] RIP: 0010:[<ffffffff810d9ff4>]  [<ffffffff810d9ff4>]
>> >> find_busiest_group+0x2b4/0x8a0
>> >
>> > Hurmph.. what kind of hardware is that? and is there anything funny you
>> > do to make it do this?
>>
>> intel nehanem-ex or westmere-ex 8 sockets system.
>>
>> I tried without my local patches, the problem is still there.
>
> And I suppose a kernel before
>
>   863bffc80898 ("sched/fair: Fix group power_orig computation")
>
> work fine, eh?
>
> I'll further assume that your RIP points to:
>
>         sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
>
> indicating that sds.total_pwr := 0.
>
> update_sd_lb_stats() computes it like:
>
>                 sds->total_pwr += sgs->group_power;
>
> which comes out of update_sg_lb_stats() like:
>
>         sgs->group_power = group->sgp->power;
>
> Which we compute in update_group_power() similarly to how we did before
> 863bffc80898.
>
> Which leaves me a bit puzzled.

Hi,
for linus tree i need to revert commit-863bffc.
   commit-863bffc

for linus tree + sched/urgent, I need to revert
   commit-42eb088
   commit-9abf24d
   commit-863bffc
.
If only revert commit-42eb088, still have problem.
if only revert  commit-9abf24d, commit-863bffc, still have problem.

Assume you need to dump sched/urgent,
and revert commit-863bffc directly from Linus's tree.

Thanks

Yinghai
