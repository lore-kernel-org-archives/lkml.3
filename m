Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3CLAWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:22:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:52614 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab3CLAWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:22:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,827,1355126400"; 
   d="scan'208";a="268894586"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] genirq: Do not consider the irqs with disabling and
 IRQF_NO_SUSPEND
Thread-Topic: [PATCH 2/3] genirq: Do not consider the irqs with disabling
 and IRQF_NO_SUSPEND
Thread-Index: AQHOHp7LH2zfqcxkK0mIM6JqFIJTSZihMboQ
Date: Tue, 12 Mar 2013 00:21:56 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A256178@SHSMSX101.ccr.corp.intel.com>
References: <1363024396.31506.60.camel@cliu38-desktop-build>
 <1363024631.31506.64.camel@cliu38-desktop-build>
 <alpine.LFD.2.02.1303112217180.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303112217180.22263@ionos>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Tuesday, March 12, 2013 5:24 AM
> To: Liu, Chuansheng
> Cc: mingo@redhat.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/3] genirq: Do not consider the irqs with disabling and
> IRQF_NO_SUSPEND
> 
> On Tue, 12 Mar 2013, Chuansheng Liu wrote:
> > According to commit 9c6079aa1bf(genirq: Do not consider disabled
> > wakeup irqs), we should not break the suspend when one irq is pending
> > but has been disabled before suspending.
> >
> > But there is another case missed, that one irq with flag IRQF_NO_SUSPEND,
> > which has been disabled before suspending, and irq pending there,
> > in this case, we still should not break the suspending, otherwise,
> > the suspend abort over and over.
> >
> > Here also checking if the desc->istate & IRQS_SUSPENDED is true.
> 
> So what you are saying is:
> 
> If an interrupt which is marked IRQF_NO_SUSPEND has been disabled
> before suspend invocation then desc->depth is 1 and therefor it should
> not be checked for IRQS_PENDING in check_wakeup_irqs().
> 
> Makes sense, though the changelog needs to be more clear and the code
> wants to have a proper comment.
Thanks, will copy your saying into comments, and send patch V2.

> 
> Thanks,
> 
> 	tglx
> 
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  kernel/irq/pm.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> > index cb228bf..1470c1b 100644
> > --- a/kernel/irq/pm.c
> > +++ b/kernel/irq/pm.c
> > @@ -109,7 +109,8 @@ int check_wakeup_irqs(void)
> >  		 * can abort suspend.
> >  		 */
> >  		if (irqd_is_wakeup_set(&desc->irq_data)) {
> > -			if (desc->depth == 1 && desc->istate & IRQS_PENDING)
> > +			if (desc->depth == 1 && (desc->istate & IRQS_PENDING)
> > +				&& (desc->istate & IRQS_SUSPENDED))
> >  				return -EBUSY;
> >  			continue;
> >  		}
> > --
> > 1.7.0.4
> >
> >
> >
> >
