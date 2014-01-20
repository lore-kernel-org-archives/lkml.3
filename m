Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaATOIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:08:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:53115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbaATOIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:08:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,690,1384329600"; 
   d="scan'208";a="467751816"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
Thread-Topic: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
Thread-Index: AQHPFd3XWkJVaGCzdkO8r2hEbHq2wJqNhJMAgAAh44A=
Date: Mon, 20 Jan 2014 14:08:32 +0000
Message-ID: <1390226911.7619.41.camel@smile>
References: <1386684373-24753-1-git-send-email-chiau.ee.chew@intel.com>
	 <20131210101025.GF29580@intel.com> <1386676582.1871.137.camel@smile>
	 <604BF5F4C5D71041942BC7E84ED659EA01520785@PGSMSX103.gar.corp.intel.com>
	 <20131218154955.GF16227@intel.com> <1387450289.1871.240.camel@smile>
	 <20140120092501.GS26823@intel.com> <1390222075.7619.29.camel@smile>
	 <20140120120714.GF26823@intel.com>
In-Reply-To: <20140120120714.GF26823@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C843F5CBC8D63C4B83DFA2F74483270A@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0KE8ndg004107

On Mon, 2014-01-20 at 17:37 +0530, Vinod Koul wrote:
> On Mon, Jan 20, 2014 at 06:17:56PM +0530, Shevchenko, Andriy wrote:
> > On Mon, 2014-01-20 at 14:55 +0530, Vinod Koul wrote:
> > > On Thu, Dec 19, 2013 at 12:51:29PM +0200, Andy Shevchenko wrote:
> > > > On Wed, 2013-12-18 at 21:19 +0530, Vinod Koul wrote:
> > > > > On Mon, Dec 16, 2013 at 01:51:47PM +0530, Chew, Chiau Ee wrote:
> > > > 
> > > > > > As mentioned by Andy, we are using *_noirq  verion of suspend/resume PM
> > > > > > callback whereby the callbacks would be executed after IRQ handlers have been
> > > > > > disabled. If using SET_SYSTEM_SLEEP_PM_OPS, it would be the normal
> > > > > > suspend/resume PM callback. Looking at the Desginware DMAC platform code
> > > > > > (drivers/dma/dw/platform.c), it is using the *_noirq suspend/resume PM
> > > > > > callback. Is it advisable to use the normal suspend/resume PM callback instead
> > > > > > of *_noirq suspend/PM callback? 
> > > > > 
> > > > > i dont see a reason why we need the noirq versions
> > > > 
> > > > Okay. I imagine the following use case.
> > > > 
> > > > For example we have compiled in DMA driver (dw_dmac) along with, for
> > > > example, SPI driver.
> > > > 
> > > > System was scheduled to go sleep.
> > > > 
> > > > An order of calling IIUC might be DMA first, then SPI (since they are
> > > > not in parent / child relations).
> > > > 
> > > > What was happened when SPI would like to do a DMA transfer and DMA is
> > > > going to sleep? I'm trying to understand if this is a case.
> > > In that case how does no irq version help us?
> > 
> > It guarantees that we have no user of DMA anymore, since there is no
> > interrupt going on.
> well how is that. It will gaurantee that there wont be interrupt. User can still
> submit a transaction or another transaction will be in progress...

This is how system suspend callback tree is called.

First it calls .suspend() for all devices, then .suspend_late(),
then .suspend_noirq().

There is set of assumptions per each callback round. After .suspend()
the device must be quiescent.

But...

> > > For these cases, I have been using suspend_late. Since the dmaengine driver is
> > > providing service to other clients (SPI), it needs to esnure that it suspends
> > > after SPI using suspend_late and resume using resume_early. That way dma is
> > > availble whenever the client is active
> > 
> > suspend_late is working in context that interrupt handler may be
> > invoked. Thus, to have DMA driver be properly shut down we have to
> > wait / terminate possible ongoing transfer.
> Well client is already suspended via .suspend. So where is the transaction :)

...as I already wrote before we have no parent-child relationship
between DMA and, for example, SPI. That means we may possible have the
case when SPI's .suspend() will be called later than DMA's one.

> > It seems for me all DMA drivers that are using
> > system .suspend()/.resume() are potentially buggy.
> Yup!

So, we have to decide what to do with them. .suspend_late() still seems
for me not the best approach. *Or* we have to check for ongoing
transaction and do something with it. *Or* just shut down the device and
rely on DMA transaction initiator that it handles the terminated
transaction properly.

What is you opinion?


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
