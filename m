Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3CKB3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 21:29:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:54524 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab3CKB3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 21:29:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,819,1355126400"; 
   d="scan'208";a="212406286"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: "lenb@kernel.org" <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] intel_idle: Removing the redundant calculating for
 dev->state_count
Thread-Topic: [PATCH 2/3] intel_idle: Removing the redundant calculating for
 dev->state_count
Thread-Index: AQHOHHI/WB1m9clQO0KmVa2MPqCO/piftiNg
Date: Mon, 11 Mar 2013 01:29:01 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A254DC5@SHSMSX101.ccr.corp.intel.com>
References: <1362674529.31506.17.camel@cliu38-desktop-build>
  <1362754926.31506.42.camel@cliu38-desktop-build>
 <1362755074.31506.45.camel@cliu38-desktop-build>
 <513AA5C0.2020604@linaro.org>
In-Reply-To: <513AA5C0.2020604@linaro.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2B1THc2004824



> -----Original Message-----
> From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
> Sent: Saturday, March 09, 2013 11:00 AM
> To: Liu, Chuansheng
> Cc: lenb@kernel.org; Brown, Len; linux-pm@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/3] intel_idle: Removing the redundant calculating for
> dev->state_count
> 
> On 03/08/2013 04:04 PM, Chuansheng Liu wrote:
> >
> > In function intel_idle_cpu_init() and intel_idle_cpuidle_driver_init(),
> > they are having the same for(;;) loop.
> >
> > Here in intel_idle_cpu_init(), the dev->state_count can be assigned by
> > drv->state_count directly.
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  drivers/idle/intel_idle.c |   30 ++----------------------------
> >  1 files changed, 2 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> > index 17c9cf9..503b401 100644
> > --- a/drivers/idle/intel_idle.c
> > +++ b/drivers/idle/intel_idle.c
> > @@ -599,38 +599,12 @@ static int intel_idle_cpuidle_driver_init(void)
> >   */
> >  static int intel_idle_cpu_init(int cpu)
> >  {
> > -	int cstate;
> >  	struct cpuidle_device *dev;
> > +	struct cpuidle_driver *drv = &intel_idle_driver;
> >
> >  	dev = per_cpu_ptr(intel_idle_cpuidle_devices, cpu);
> >
> > -	dev->state_count = 1;
> > -
> > -	for (cstate = 0; cstate < CPUIDLE_STATE_MAX; ++cstate) {
> > -		int num_substates, mwait_hint, mwait_cstate, mwait_substate;
> > -
> > -		if (cpuidle_state_table[cstate].enter == NULL)
> > -			break;
> > -
> > -		if (cstate + 1 > max_cstate) {
> > -			printk(PREFIX "max_cstate %d reached\n", max_cstate);
> > -			break;
> > -		}
> > -
> > -		mwait_hint = flg2MWAIT(cpuidle_state_table[cstate].flags);
> > -		mwait_cstate = MWAIT_HINT2CSTATE(mwait_hint);
> > -		mwait_substate = MWAIT_HINT2SUBSTATE(mwait_hint);
> > -
> > -		/* does the state exist in CPUID.MWAIT? */
> > -		num_substates = (mwait_substates >> ((mwait_cstate + 1) * 4))
> > -					& MWAIT_SUBSTATE_MASK;
> > -
> > -		/* if sub-state in table is not enumerated by CPUID */
> > -		if ((mwait_substate + 1) > num_substates)
> > -			continue;
> > -
> > -		dev->state_count += 1;
> > -	}
> > +	dev->state_count = drv->state_count;
> 
> The cpuidle_register_device function already does this initialization.
Thanks your remind, will send patch V2 to remove it.

> 
> Probably you can get rid of this initialization and certainly factor out
> a bit the code in this case.
> 
> 
> --
>  <http://www.linaro.org/> Linaro.org â”‚ Open source software for ARM SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
