Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaLOVZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:25:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:39350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaLOVZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:25:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,581,1413270000"; 
   d="scan'208";a="624195965"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wu, Fengguang" <fengguang.wu@intel.com>
CC: Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        "Jacob Pan (jacob.jun.pan@linux.intel.com)" 
	<jacob.jun.pan@linux.intel.com>,
        "Zijlstra, Peter" <peter.zijlstra@intel.com>
Subject: RE: [nohz] 2a16fc93d2c: kernel lockup on idle injection
Thread-Topic: [nohz] 2a16fc93d2c: kernel lockup on idle injection
Thread-Index: AQHQFXqOSic2YoYVZ02pHzYLw2fbkZyMYOIAgARq/ICAACNRgIAAAywAgAA8PfA=
Date: Mon, 15 Dec 2014 21:24:51 +0000
Message-ID: <DD415AA12F8FF042BF4EA69DF123C1478AF76532@ORSMSX106.amr.corp.intel.com>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com>
 <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
 <548E8D01.9050707@linux.vnet.ibm.com>
 <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com>
 <548EAD4A.6070506@linux.vnet.ibm.com>
In-Reply-To: <548EAD4A.6070506@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBFLPGmt002286



-----Original Message-----
From: Preeti U Murthy [mailto:preeti@linux.vnet.ibm.com] 
Sent: Monday, December 15, 2014 1:44 AM
To: Viresh Kumar; Thomas Gleixner; Wu, Fengguang
Cc: Frederic Weisbecker; Pan, Jacob jun; LKML; LKP
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection

On 12/15/2014 03:02 PM, Viresh Kumar wrote:
> On 15 December 2014 at 12:55, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> Hi Viresh,
>>
>> Let me explain why I think this is happening.
>>
>> 1. tick_nohz_irq_enter/exit() both get called *only if the cpu is 
>> idle* and receives an interrupt.
> 
> Bang on target. Yeah that's the part we missed while writing this 
> patch :)
> 
>> 2. Commit 2a16fc93d2c9568e1, cancels programming of tick_sched timer 
>> in its handler, assuming that tick_nohz_irq_exit() will take care of 
>> programming the clock event device appropriately, and hence it would 
>> requeue or cancel the tick_sched timer.
> 
> Correct.
> 
>> 3. But the intel_powerclamp driver injects an idle period only.
>> *The CPU however is not idle*. It has work on its runqueue and the
>> rq->curr != idle. This means that *tick_nohz_irq_enter()/exit() will 
>> rq->not
>> get called on any interrupt*.
> 
> Still good..
> 
>> 4. As a consequence, when we get a hrtimer interrupt during the 
>> period that the powerclamp driver is mimicking idle, the exit path of 
>> the interrupt never calls tick_nohz_irq_exit(). Hence the tick_sched 
>> timer that would have got removed due to the above commit will not 
>> get enqueued back on for any pending timers that there might be. 
>> Besides this, *jiffies never gets updated*.
> 
> Jiffies can be updated by any CPU and there is something called a 
> control cpu with powerclamp driver. BUT we may have got interrupted 
> before the powerclamp timer expired and so we are stuck in the
> 
> while (time_before(jiffies, target_jiffies))
> 
> loop for ever.
> 
>> Hope the above explanation makes sense.
> 
> Mostly good. Thanks for helping out.
> 
> Now, what's the right solution going forward ?
> 
> - Revert the offending commit ..
> - Or still try to avoid reprogramming if we can ..
> 
> This is what I could come up with to still avoid reprogramming of tick:
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c index 
> cc0a5b6f741b..49f4278f69e2 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -1100,7 +1100,7 @@ static enum hrtimer_restart 
> tick_sched_timer(struct hrtimer *timer)
>                 tick_sched_handle(ts, regs);
> 
>         /* No need to reprogram if we are in idle or full dynticks mode */
> -       if (unlikely(ts->tick_stopped))
> +       if (unlikely(ts->tick_stopped && (is_idle_task(current) ||
> !ts->inidle)))
>                 return HRTIMER_NORESTART;
> 
>         hrtimer_forward(timer, now, tick_period);
> 
> 

Looks good to me. You can add my Reviewed-by to the above patch.

> 
> Above change checks why we have stopped tick..
> - The cpu has gone idle (really): is_idle_task(current)
> - The cpu isn't in idle mode, i.e. its in nohz-full mode: !ts->inidle
> 
> This fixed the issues with powerclamp in my case.
> 
> @Fengguang: Can you please check if this fixes it for you as well?
> 
I have tested this fix and confirm powerclamp is working properly now.

However, we also have a planned patch for consolidated idle loop. With this patch it causes some erratic behavior in idle injection.
I canâ€™t seem to synchronize/align idle time around jiffies with this patch + fix.

Any suggestions welcome.
https://lkml.org/lkml/2014/6/4/56

+peter

> @Thomas: Please let me know if you want me to send this fix or you 
> want to revert the original commit itself.

Regards
Preeti U Murthy
> 
> Thanks.
> 
> --
> Viresh
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
