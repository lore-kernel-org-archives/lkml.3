Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaA0KRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:17:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:29804 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaA0KRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:17:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,728,1384329600"; 
   d="scan'208";a="445115964"
Message-ID: <1390817840.7619.102.camel@smile>
Subject: Re: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 27 Jan 2014 12:17:20 +0200
In-Reply-To: <20140126111734.GA10628@intel.com>
References: <1386684373-24753-1-git-send-email-chiau.ee.chew@intel.com>
	 <20131210101025.GF29580@intel.com> <1386676582.1871.137.camel@smile>
	 <604BF5F4C5D71041942BC7E84ED659EA01520785@PGSMSX103.gar.corp.intel.com>
	 <20131218154955.GF16227@intel.com> <1387450289.1871.240.camel@smile>
	 <20140120092501.GS26823@intel.com> <1390222075.7619.29.camel@smile>
	 <20140120120714.GF26823@intel.com> <1390226911.7619.41.camel@smile>
	 <20140126111734.GA10628@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-26 at 16:47 +0530, Vinod Koul wrote:

> > > > > For these cases, I have been using suspend_late. Since the dmaengine driver is
> > > > > providing service to other clients (SPI), it needs to esnure that it suspends
> > > > > after SPI using suspend_late and resume using resume_early. That way dma is
> > > > > availble whenever the client is active
> > > > 
> > > > suspend_late is working in context that interrupt handler may be
> > > > invoked. Thus, to have DMA driver be properly shut down we have to
> > > > wait / terminate possible ongoing transfer.
> > > Well client is already suspended via .suspend. So where is the transaction :)
> > 
> > ...as I already wrote before we have no parent-child relationship
> > between DMA and, for example, SPI. That means we may possible have the
> > case when SPI's .suspend() will be called later than DMA's one.
> > 
> > > > It seems for me all DMA drivers that are using
> > > > system .suspend()/.resume() are potentially buggy.
> > > Yup!
> > 
> > So, we have to decide what to do with them. .suspend_late() still seems
> > for me not the best approach. *Or* we have to check for ongoing
> > transaction and do something with it. *Or* just shut down the device and
> > rely on DMA transaction initiator that it handles the terminated
> > transaction properly.
> 
> As you clearly said, we dont have a parent-child relatation though we have big
> dependency. I think this is true for DMA clients, i ran into similar situation
> with i2c few days back!
> 
> So only think which can give us a good system behaviour would be clients getting
> suspended first and then then service providing subsystems.

Agree.

>  (same reason why we
> do dma driver loading and init much before others drivers)

Yes, it would be done via deferred probe.

> So yes in the .suspend callback of the client, it needs to
> 1) abort any transactions it has
> 2) make the client quiscent
> 
> then the .late_suspend kicks in and suspend the core drivers like dma.
> 
> This is how it has worked reliably for me in production systems. I am all ears
> if we have a better and cleaner apprach to this problem :)

Yes, summarize everything we discussed we have to:
 - provide suspend_late, resume_early callbacks in the DMA driver
instead of *_noirq versions
 - ensure that all clients on our platforms follow the described
scenario

Chiau Ee, I think you may to change your patch accordingly.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

