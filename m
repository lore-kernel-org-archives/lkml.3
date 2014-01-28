Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaA1HWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:22:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:20644 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaA1HWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:22:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,734,1384329600"; 
   d="scan'208";a="473591651"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>
CC: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
Thread-Topic: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
Thread-Index: AQHO9ZALDQwoxUs3N0WSdT+GfCUKwppMzJUAgAmy7SCAAyDZgIA0CQf7//+hEAD///ShAIAAIeQAgAk+OACAAYGBAIAB5s5Q
Date: Tue, 28 Jan 2014 07:21:17 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA01532E9C@PGSMSX103.gar.corp.intel.com>
References: <1386684373-24753-1-git-send-email-chiau.ee.chew@intel.com>
	 <20131210101025.GF29580@intel.com> <1386676582.1871.137.camel@smile>
	 <604BF5F4C5D71041942BC7E84ED659EA01520785@PGSMSX103.gar.corp.intel.com>
	 <20131218154955.GF16227@intel.com> <1387450289.1871.240.camel@smile>
	 <20140120092501.GS26823@intel.com> <1390222075.7619.29.camel@smile>
	 <20140120120714.GF26823@intel.com> <1390226911.7619.41.camel@smile>
	 <20140126111734.GA10628@intel.com> <1390817840.7619.102.camel@smile>
In-Reply-To: <1390817840.7619.102.camel@smile>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0S7MTY7013580



> -----Original Message-----
> From: Andy Shevchenko [mailto:andriy.shevchenko@linux.intel.com]
> Sent: Monday, January 27, 2014 6:17 PM
> To: Koul, Vinod
> Cc: Andy Shevchenko; Chew, Chiau Ee; Viresh Kumar; Williams, Dan J;
> dmaengine@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
> DW_DMAC.
> 
> On Sun, 2014-01-26 at 16:47 +0530, Vinod Koul wrote:
> 
> > > > > > For these cases, I have been using suspend_late. Since the
> > > > > > dmaengine driver is providing service to other clients (SPI),
> > > > > > it needs to esnure that it suspends after SPI using
> > > > > > suspend_late and resume using resume_early. That way dma is
> > > > > > availble whenever the client is active
> > > > >
> > > > > suspend_late is working in context that interrupt handler may be
> > > > > invoked. Thus, to have DMA driver be properly shut down we have
> > > > > to wait / terminate possible ongoing transfer.
> > > > Well client is already suspended via .suspend. So where is the
> > > > transaction :)
> > >
> > > ...as I already wrote before we have no parent-child relationship
> > > between DMA and, for example, SPI. That means we may possible have
> > > the case when SPI's .suspend() will be called later than DMA's one.
> > >
> > > > > It seems for me all DMA drivers that are using system
> > > > > .suspend()/.resume() are potentially buggy.
> > > > Yup!
> > >
> > > So, we have to decide what to do with them. .suspend_late() still
> > > seems for me not the best approach. *Or* we have to check for
> > > ongoing transaction and do something with it. *Or* just shut down
> > > the device and rely on DMA transaction initiator that it handles the
> > > terminated transaction properly.
> >
> > As you clearly said, we dont have a parent-child relatation though we
> > have big dependency. I think this is true for DMA clients, i ran into
> > similar situation with i2c few days back!
> >
> > So only think which can give us a good system behaviour would be
> > clients getting suspended first and then then service providing subsystems.
> 
> Agree.
> 
> >  (same reason why we
> > do dma driver loading and init much before others drivers)
> 
> Yes, it would be done via deferred probe.
> 
> > So yes in the .suspend callback of the client, it needs to
> > 1) abort any transactions it has
> > 2) make the client quiscent
> >
> > then the .late_suspend kicks in and suspend the core drivers like dma.
> >
> > This is how it has worked reliably for me in production systems. I am
> > all ears if we have a better and cleaner apprach to this problem :)
> 
> Yes, summarize everything we discussed we have to:
>  - provide suspend_late, resume_early callbacks in the DMA driver instead of
> *_noirq versions
>  - ensure that all clients on our platforms follow the described scenario
> 
> Chiau Ee, I think you may to change your patch accordingly.

Ok. Noted

> 
> 
> --
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
