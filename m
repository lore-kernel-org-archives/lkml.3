Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab3BVKGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:06:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40162 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3BVKGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:06:36 -0500
Message-ID: <5127436E.4040100@ti.com>
Date: Fri, 22 Feb 2013 15:37:42 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Liu <liu.h.jason@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com> <alpine.LFD.2.02.1302201400400.22263@ionos> <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com> <alpine.LFD.2.02.1302211015270.22263@ionos> <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com> <alpine.LFD.2.02.1302211436300.22263@ionos> <51263975.20906@ti.com> <alpine.LFD.2.02.1302212214020.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1302212214020.22263@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Friday 22 February 2013 03:49 AM, Thomas Gleixner wrote:
> On Thu, 21 Feb 2013, Santosh Shilimkar wrote:
>> On Thursday 21 February 2013 07:18 PM, Thomas Gleixner wrote:
>>> find below a completely untested patch, which should address that issue.
>>>
>> After looking at the thread, I tried to see the issue on OMAP and could
>> see the same issue as Jason.
>
> That's interesting. We have the same issue on x86 since 2007 and
> nobody noticed ever. It's basically the same problem there, but it
> seems that on x86 getting out of those low power states is way slower
> than the minimal reprogramming delta which is used to enforce the
> local timer to fire after the wakeup.
>
> I'm still amazed that as Jason stated a 1us reprogramming delta is
> sufficient to get this ping-pong going. I somehow doubt that, but
> maybe ARM is really that fast :)
>
>> Your patch fixes the retries on both CPUs on my dual core machine. So
>> you use my tested by if you need one.
>
> They are always welcome.
>
BTW, Lorenzo off-list mentioned to me about warning in boot-up
which I missed while testing your patch. It will take bit more
time for me to look into it and hence thought of reporting it.

[    2.186126] ------------[ cut here ]------------
[    2.190979] WARNING: at kernel/time/tick-broadcast.c:501 
tick_broadcast_oneshot_control+0x1c0/0x21c()
[    2.200622] Modules linked in:
[    2.203826] [<c001bfe4>] (unwind_backtrace+0x0/0xf0) from 
[<c0047d6c>] (warn_slowpath_common+0x4c/0x64)
[    2.213653] [<c0047d6c>] (warn_slowpath_common+0x4c/0x64) from 
[<c0047da0>] (warn_slowpath_null+0x1c/0x24)
[    2.223754] [<c0047da0>] (warn_slowpath_null+0x1c/0x24) from 
[<c009336c>] (tick_broadcast_oneshot_control+0x1c0/0x21c)
[    2.234924] [<c009336c>] (tick_broadcast_oneshot_control+0x1c0/0x21c) 
from [<c00928dc>] (tick_notify+0x23c/0x42c)
[    2.245666] [<c00928dc>] (tick_notify+0x23c/0x42c) from [<c0539a3c>] 
(notifier_call_chain+0x44/0x84)
[    2.255218] [<c0539a3c>] (notifier_call_chain+0x44/0x84) from 
[<c0071068>] (raw_notifier_call_chain+0x18/0x20)
[    2.265686] [<c0071068>] (raw_notifier_call_chain+0x18/0x20) from 
[<c0091c70>] (clockevents_notify+0x2c/0x174)
[    2.276123] [<c0091c70>] (clockevents_notify+0x2c/0x174) from 
[<c0035294>] (omap_enter_idle_smp+0x3c/0x120)
[    2.286315] [<c0035294>] (omap_enter_idle_smp+0x3c/0x120) from 
[<c042e504>] (cpuidle_enter+0x14/0x18)
[    2.295928] [<c042e504>] (cpuidle_enter+0x14/0x18) from [<c042ef14>] 
(cpuidle_wrap_enter+0x34/0xa0)
[    2.305389] [<c042ef14>] (cpuidle_wrap_enter+0x34/0xa0) from 
[<c042eb20>] (cpuidle_idle_call+0xe0/0x328)
[    2.315307] [<c042eb20>] (cpuidle_idle_call+0xe0/0x328) from 
[<c0015100>] (cpu_idle+0x8c/0x11c)
[    2.324401] [<c0015100>] (cpu_idle+0x8c/0x11c) from [<c073d7ac>] 
(start_kernel+0x2b0/0x300)
[    2.333129] ---[ end trace 6fe1f7b4606a9e20 ]---


