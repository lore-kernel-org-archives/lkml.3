Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbaDBQnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:43:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:45737 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335AbaDBQnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:43:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,780,1389772800"; 
   d="scan'208";a="513011311"
Date: Wed, 2 Apr 2014 22:05:19 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Hongbo Zhang <hongbo.zhang@freescale.com>
Cc: Vinod Koul <vkoul@infradead.org>, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, scottwood@freescale.com,
        LeoLi@freescale.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] DMA: Freescale: use spin_lock_bh instead of
 spin_lock_irqsave
Message-ID: <20140402163519.GU1976@intel.com>
References: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>
 <1389851246-8564-7-git-send-email-hongbo.zhang@freescale.com>
 <1395817294.6569.2.camel@vkoul-udesk3>
 <533517C1.8080208@freescale.com>
 <20140329134528.GQ1976@intel.com>
 <5338EA57.1000509@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5338EA57.1000509@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 12:08:55PM +0800, Hongbo Zhang wrote:
> 
> On 03/29/2014 09:45 PM, Vinod Koul wrote:
> >On Fri, Mar 28, 2014 at 02:33:37PM +0800, Hongbo Zhang wrote:
> >>On 03/26/2014 03:01 PM, Vinod Koul wrote:
> >>>On Thu, 2014-01-16 at 13:47 +0800, hongbo.zhang@freescale.com wrote:
> >>>>From: Hongbo Zhang <hongbo.zhang@freescale.com>
> >>>>
> >>>>The usage of spin_lock_irqsave() is a stronger locking mechanism than is
> >>>>required throughout the driver. The minimum locking required should be used
> >>>>instead. Interrupts will be turned off and context will be saved, it is
> >>>>unnecessary to use irqsave.
> >>>>
> >>>>This patch changes all instances of spin_lock_irqsave() to spin_lock_bh(). All
> >>>>manipulation of protected fields is done using tasklet context or weaker, which
> >>>>makes spin_lock_bh() the correct choice.
> >>>>
> >
> >>>>  /**
> >>>>@@ -1124,11 +1120,10 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
> >>>>  static void dma_do_tasklet(unsigned long data)
> >>>>  {
> >>>>  	struct fsldma_chan *chan = (struct fsldma_chan *)data;
> >>>>-	unsigned long flags;
> >>>>  	chan_dbg(chan, "tasklet entry\n");
> >>>>-	spin_lock_irqsave(&chan->desc_lock, flags);
> >>>>+	spin_lock_bh(&chan->desc_lock);
> >>>okay here is the problem :(
> >>>
> >>>You moved to _bh variant. So if you grab the lock in rest of the code
> >>>and irq gets triggered then here we will be spinning to grab the lock.
> >>>So effectively you made right locking solution into deadlock situation!
> >>If the rest code grabs lock by spin_lock_bh(), and if irq raised,
> >>the tasklet could not be executed because it has been disabled by
> >>the _bh variant function.
> >yes if you are accessing resources only in tasklet and rest of the code, then
> >_bh variant works well. The problem here is usage in irq handler
> >
> 
> The name dma_do_tasklet may mislead, it is tasklet handler, not irq
> handler, not a trigger to load tasklet.
> the irq handler is fsldma_chan_irq, and I don't use lock in it.
sorry my bad, i misread this as code in fsldma_chan_irq() insteadof
dma_do_tasklet(). In that case patch is doing the right thing.

-- 
~Vinod
> 
> If it is the problem, I would like to change dma_do_tasklet to
> dma_tasklet to eliminate misleading.
> 
> 
> 

-- 
