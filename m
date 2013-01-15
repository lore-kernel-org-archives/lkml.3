Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3AOAyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:54:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:11855 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216Ab3AOAyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:54:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,469,1355126400"; 
   d="scan'208";a="191087623"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] genirq: Give warning when setup an already-setup
 non-shared irq
Thread-Topic: [PATCH] genirq: Give warning when setup an already-setup
 non-shared irq
Thread-Index: AQHN8kikefkpUiL9mkmDdP3wIMIbnZhJjo1w
Date: Tue, 15 Jan 2013 00:54:06 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A203FC1@SHSMSX101.ccr.corp.intel.com>
References: <1357833301.21958.10.camel@cliu38-desktop-build>
 <alpine.LFD.2.02.1301141211500.7475@ionos>
In-Reply-To: <alpine.LFD.2.02.1301141211500.7475@ionos>
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
> Sent: Monday, January 14, 2013 7:16 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] genirq: Give warning when setup an already-setup
> non-shared irq
> 
> On Thu, 10 Jan 2013, Chuansheng Liu wrote:
> >
> > Meet the case when the request_threaded_irq() with the same irq
> > is called twice continually, get the below mismatch info:
> > "IRQ handler type mismatch for IRQ 323"
> 
> I have no idea where you get that from. The mismatch is printed with:
> 
>         if (!(new->flags & IRQF_PROBE_SHARED)) {
> 	   pr_err("Flags mismatch irq %d. %08x (%s) vs. %08x (%s)\n",
>                        irq, new->flags, new->name, old->flags,
> old->name);
	if (!(new->flags & IRQF_PROBE_SHARED)) {
		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
		if (old_name)
			printk(KERN_ERR "current handler: %s\n", old_name);
		dump_stack();
	}
The "IRQ handler type mismatch for IRQ 323" message is coming from the above code,
which is something older than you pasted, but it is the same place.

> 
> And its only printed when IRQF_PROBE_SHARED is not set. Your change
> would cause printouts where no printouts are due and it'd change the
> return value from EBUSY to EINVAL.
My test case is below:
request_irq(323, func1,
				IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING,
				name, dev);
After succeeded, then called it again:
request_irq(323, func1,
				IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING,
				name, dev);

After the test case, I will get the "mismatch" info.
But in this case, it should not be the "mismatch" case, so I want to give another warning
in case of duplicated setup the same irq with non-shared.
Not sure if it is right. Thanks your pointing out.
> 
> Thanks,
> 
> 	tglx
