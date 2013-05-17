Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3EQOTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:19:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62495 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158Ab3EQOTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:19:39 -0400
Date: Fri, 17 May 2013 15:18:57 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "andriy.shevchenko@linux.intel.com" 
	<andriy.shevchenko@linux.jf.intel.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
Subject: Re: dmatest regression in 3.10-rc1
Message-ID: <20130517141857.GM23112@mudshark.cambridge.arm.com>
References: <20130515152803.GL23869@mudshark.cambridge.arm.com>
 <20130516153553.GI11706@mudshark.cambridge.arm.com>
 <20130517123423.GR14863@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517123423.GR14863@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

Thanks for the reply.

On Fri, May 17, 2013 at 01:34:23PM +0100, Vinod Koul wrote:
> On Thu, May 16, 2013 at 04:35:53PM +0100, Will Deacon wrote:
> > Right, so I think I understand what's causing this, but I'll leave it to
> > Andriy to suggest a fix. The problem comes about because the dmatest
> > module is now driven from debugfs, making it possible to unload the module
> > whilst a test run is in progress. In this case:
> > 
> > 	- The DMA threads will return from wait_event_freezable_timeout(...)
> > 	  due to kthread_should_stop() returning true, and subsequently
> > 	  report failure because done.done is false.
> > 
> > 	- The DMA engines may not be idle, so the asynchronous callback can
> > 	  be invoked after we've started cleaning up, explaining the NULL
> > 	  dereference I'm seeing.
> > 
> > The solutions are either fixing the module exit code to cope with concurrent
> > DMA transfers or to revert 77101ce578bb and not allow the channel threads to
> > return mid-transfer.
> We need to properly abort the channels on removal. This is already handled in
> the code but the kthread_stop is called after the transactions are aborted. It
> should be the other way round. Can you try with below patch

Unfortunately, I can trigger the exact same panic with this patch applied.

Isn't there a race between terminating the dmaengine transfers
(dmaengine_terminate_all) and killing the test threads (kthread_stop) where
a new transfer could be kicked off by dmatest_func?

Will
