Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3HVKMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:12:05 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:53982 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab3HVKME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:12:04 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "ccross@android.com" <ccross@android.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 22 Aug 2013 03:11:04 -0700
Subject: RE: [PATCH] cpuidle: coupled: fix dead loop corner case
Thread-Topic: [PATCH] cpuidle: coupled: fix dead loop corner case
Thread-Index: Ac6doHSZuq4gka2oScWx0QXqlc+SPwBft8cA
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE3DBD2B9800@SC-VEXCH4.marvell.com>
References: <1376975864-31487-1-git-send-email-zhangwm@marvell.com>
 <26502976.vPDNddhvVv@vostro.rjw.lan>
In-Reply-To: <26502976.vPDNddhvVv@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7MACG61029950

Daniel & Colin,

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: 2013å¹´8æœˆ20æ—¥ 20:37
> To: Neil Zhang; Daniel Lezcano
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] cpuidle: coupled: fix dead loop corner case
> 
> On Tuesday, August 20, 2013 01:17:44 PM Neil Zhang wrote:
> > There is a corener case when no peripheral irqs route to secondary
> > cores.
> > Let's take dual core system for example, the sequence is as following:
> >
> > 		Core 0			        Core1
> > 1.			           set waiting bit and enter waiting loop
> > 2. set waiting bit and poke core1
> > 3. 				   clear poke in irq and enter safe state
> > 4. set ready bit and enter ready loop
> >
> > Since there is no peripheral irq route to core 1, so it will stay in
> > safe state forever, and core 0 will dead loop in the following code.
> > 	while (!cpuidle_coupled_cpus_ready(coupled)) {
> > 		/* Check if any other cpus bailed out of idle. */
> > 		if (!cpuidle_coupled_cpus_waiting(coupled))
> > 	}
> >
> > The solution is don't let secondary core enter safe state when it has
> > already handled the poke interrupt.
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > Reviewed-by: Fangsuo Wu <fswu@marvell.com>
> 
> Daniel, can you please have a look at this?
> 
> Rafael
> 

What's your opinion?
Thanks.

> 
> > ---
> >  drivers/cpuidle/coupled.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> > index 2a297f8..a37c718 100644
> > --- a/drivers/cpuidle/coupled.c
> > +++ b/drivers/cpuidle/coupled.c
> > @@ -119,6 +119,7 @@ struct cpuidle_coupled {
> >  #define CPUIDLE_COUPLED_NOT_IDLE	(-1)
> >
> >  static DEFINE_MUTEX(cpuidle_coupled_lock);
> > +static DEFINE_PER_CPU(bool, poke_sync);
> >  static DEFINE_PER_CPU(struct call_single_data,
> > cpuidle_coupled_poke_cb);
> >
> >  /*
> > @@ -295,6 +296,7 @@ static void cpuidle_coupled_poked(void *info)  {
> >  	int cpu = (unsigned long)info;
> >  	cpumask_clear_cpu(cpu, &cpuidle_coupled_poked_mask);
> > +	__this_cpu_write(poke_sync, true);
> >  }
> >
> >  /**
> > @@ -473,6 +475,7 @@ retry:
> >  	 * allowed for a single cpu.
> >  	 */
> >  	while (!cpuidle_coupled_cpus_waiting(coupled)) {
> > +		__this_cpu_write(poke_sync, false);
> >  		if (cpuidle_coupled_clear_pokes(dev->cpu)) {
> >  			cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
> >  			goto out;
> > @@ -483,6 +486,10 @@ retry:
> >  			goto out;
> >  		}
> >
> > +		if (cpuidle_coupled_cpus_waiting(coupled)
> > +			&& __this_cpu_read(poke_sync))
> > +			break;
> > +
> >  		entered_state = cpuidle_enter_state(dev, drv,
> >  			dev->safe_state_index);
> >  	}
> >
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
