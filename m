Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaHUCNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:13:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:48411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaHUCNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:13:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,906,1400050800"; 
   d="scan'208";a="587790419"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: RE: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
 idle cpu
Thread-Topic: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up
 the idle cpu
Thread-Index: AQHPvOLRmd9q8ZSNyk6REpYBhefA1ZvaT36w
Date: Thu, 21 Aug 2014 02:12:49 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E5F7BC@SHSMSX101.ccr.corp.intel.com>
References: <1408351052-25075-1-git-send-email-chuansheng.liu@intel.com>
 <53F5514A.5050007@linaro.org>
In-Reply-To: <53F5514A.5050007@linaro.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7L2DLsT002675

Hello Daniel,

> -----Original Message-----
> From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
> Sent: Thursday, August 21, 2014 9:54 AM
> To: Liu, Chuansheng; luto@amacapital.net; peterz@infradead.org;
> rjw@rjwysocki.net; mingo@redhat.com
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Liu, Changcheng;
> Wang, Xiaoming; Chakravarty, Souvik K
> Subject: Re: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
> idle cpu
> 
> On 08/18/2014 10:37 AM, Chuansheng Liu wrote:
> > Implementing one new API wake_up_if_idle(), which is used to
> > wake up the idle CPU.
> 
> Is this patchset tested ? Did you check it solves the issue you were
> facing ?
We have done the basic test, and found the cores can exit C0 quickly with this patchset.
Basically once the _TIF_NEED_RESCHED is set, then the poll_idle() can be broken.

Please correct me if something is wrong, thanks.

> 
> > Suggested-by: Andy Lutomirski <luto@amacapital.net>
> > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> > ---
> >   include/linux/sched.h |    1 +
> >   kernel/sched/core.c   |   16 ++++++++++++++++
> >   2 files changed, 17 insertions(+)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 857ba40..3f89ac1 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1024,6 +1024,7 @@ struct sched_domain_topology_level {
> >   extern struct sched_domain_topology_level *sched_domain_topology;
> >
> >   extern void set_sched_topology(struct sched_domain_topology_level *tl);
> > +extern void wake_up_if_idle(int cpu);
> >
> >   #ifdef CONFIG_SCHED_DEBUG
> >   # define SD_INIT_NAME(type)		.name = #type
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 1211575..adf104f 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1620,6 +1620,22 @@ static void ttwu_queue_remote(struct
> task_struct *p, int cpu)
> >   	}
> >   }
> >
> > +void wake_up_if_idle(int cpu)
> > +{
> > +	struct rq *rq = cpu_rq(cpu);
> > +	unsigned long flags;
> > +
> > +	if (set_nr_if_polling(rq->idle)) {
> > +		trace_sched_wake_idle_without_ipi(cpu);
> > +	} else {
> > +		raw_spin_lock_irqsave(&rq->lock, flags);
> > +		if (rq->curr == rq->idle)
> > +			smp_send_reschedule(cpu);
> > +		/* Else cpu is not in idle, do nothing here */
> > +		raw_spin_unlock_irqrestore(&rq->lock, flags);
> > +	}
> > +}
> > +
> >   bool cpus_share_cache(int this_cpu, int that_cpu)
> >   {
> >   	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
> >
> 
> 
> --
>   <http://www.linaro.org/> Linaro.org â”‚ Open source software for ARM
> SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
