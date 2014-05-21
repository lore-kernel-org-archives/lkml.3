Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960AbaEUEAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:00:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:30320 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbaEUEAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:00:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,878,1392192000"; 
   d="scan'208";a="535240312"
Date: Wed, 21 May 2014 09:15:13 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Hongbo Zhang <hongbo.zhang@freescale.com>
Cc: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "leo.li@freescale.com" <leo.li@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "vkoul@infradead.org" <vkoul@infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v4 8/8] DMA: Freescale: add suspend resume functions
 for DMA driver
Message-ID: <20140521034513.GF21128@intel.com>
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-9-git-send-email-hongbo.zhang@freescale.com>
 <20140502164604.GB32284@intel.com>
 <536614E7.9050301@freescale.com>
 <1399451493.2677.11.camel@smile.fi.intel.com>
 <536B53E5.30506@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536B53E5.30506@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 05:52:37PM +0800, Hongbo Zhang wrote:
> 
> On 05/07/2014 04:31 PM, Shevchenko, Andriy wrote:
> >On Sun, 2014-05-04 at 18:22 +0800, Hongbo Zhang wrote:
> >>On 05/03/2014 12:46 AM, Vinod Koul wrote:
> >>>On Fri, Apr 18, 2014 at 04:17:51PM +0800, hongbo.zhang@freescale.com wrote:
> >>>>From: Hongbo Zhang <hongbo.zhang@freescale.com>
> >>>>
> >>>>This patch adds suspend resume functions for Freescale DMA driver.
> >>>>.prepare callback is used to stop further descriptors from being added into the
> >>>>pending queue, and also issue pending queues into execution if there is any.
> >>>>.suspend callback makes sure all the pending jobs are cleaned up and all the
> >>>>channels are idle, and save the mode registers.
> >>>>.resume callback re-initializes the channels by restore the mode registers.
> >>>>
> >>>>+
> >>>>+static const struct dev_pm_ops fsldma_pm_ops = {
> >>>>+	.prepare	= fsldma_prepare,
> >>>>+	.suspend	= fsldma_suspend,
> >>>>+	.resume		= fsldma_resume,
> >>>>+};
> >>>I think this is not correct. We discussed this sometime back on list. The
> >>>DMAengine drivers should use late resume and early suspend to ensure they get
> >>>suspended after clients (who should use normal ones) and resume before them
> >>>
> >>OK, will update it like this:
> >>use .suspend to take place of current .prepare
> >Could you remove this at all?
> >
> >Answering to your previous statements I could say that.
> >Device drivers (DMAc users) that don't implement .suspend callback are
> >on their own with troubles, you have not to care about them in the DMA
> >driver.
> 
> Thanks for pointing out this issue.
> Then how to handle the descriptors in the pending list if there is any?
> a. let them finished.
>     but if the DMA user has already suspended prior DMA controller,
> it is meaningless somehow and may even ask for trouble.
> b. don't touch them.
>     after resume these pending descriptors could be executed, it is
> also meaningless because the resumed DMA user may in different state
> from before being suspended.
> c. delete them.
>     should we do this? is is a bit crude?
> d. return a non-success value
>     then the whole suspend process is reversed, e.g. suspend fails.
> I've looked through some dma drivers, most of them is in case b.
Yes and that makese sense.

In calssic suspend case we maybe in middle so graceful behaviour would be to for
client to PAUSE or terminate and then suspend followed by DMA suspend.
You need to rely on client doing the right thing here

-- 
~Vinod
