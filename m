Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3EQNK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:10:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:55938 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab3EQNKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,692,1363158000"; 
   d="scan'208";a="243014904"
Date: Fri, 17 May 2013 18:04:23 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "andriy.shevchenko@linux.intel.com" 
	<andriy.shevchenko@linux.jf.intel.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
Subject: Re: dmatest regression in 3.10-rc1
Message-ID: <20130517123423.GR14863@intel.com>
References: <20130515152803.GL23869@mudshark.cambridge.arm.com>
 <20130516153553.GI11706@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516153553.GI11706@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 04:35:53PM +0100, Will Deacon wrote:
> On Wed, May 15, 2013 at 04:28:03PM +0100, Will Deacon wrote:
> > I've been observing a regression in the dmatest module with 3.10-rc1. It
> > manifests as either:
> > 
> >  - a spurious timeout on one or more of the channel threads
> >  - a complete kernel lockup (loss of console)
> >  - a panic (see below, noting that the callback [dmatest_callback] is
> >    dereferencing a NULL pointer)
> > 
> > If I revert 77101ce578bb ("dmatest: cancel thread immediately when asked
> > for") then things are rosy again, but I'm not sure if this is hiding another
> > problem.
> 
> Right, so I think I understand what's causing this, but I'll leave it to
> Andriy to suggest a fix. The problem comes about because the dmatest
> module is now driven from debugfs, making it possible to unload the module
> whilst a test run is in progress. In this case:
> 
> 	- The DMA threads will return from wait_event_freezable_timeout(...)
> 	  due to kthread_should_stop() returning true, and subsequently
> 	  report failure because done.done is false.
> 
> 	- The DMA engines may not be idle, so the asynchronous callback can
> 	  be invoked after we've started cleaning up, explaining the NULL
> 	  dereference I'm seeing.
> 
> The solutions are either fixing the module exit code to cope with concurrent
> DMA transfers or to revert 77101ce578bb and not allow the channel threads to
> return mid-transfer.
We need to properly abort the channels on removal. This is already handled in
the code but the kthread_stop is called after the transactions are aborted. It
should be the other way round. Can you try with below patch

---

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index d8ce4ec..4e8d581 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -822,6 +822,9 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
 	struct dmatest_thread	*_thread;
 	int			ret;
 
+	/* terminate all transfers on specified channels */
+	dmaengine_terminate_all(dtc->chan);
+
 	list_for_each_entry_safe(thread, _thread, &dtc->threads, node) {
 		ret = kthread_stop(thread->task);
 		pr_debug("dmatest: thread %s exited with status %d\n",
@@ -830,9 +833,6 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
 		kfree(thread);
 	}
 
-	/* terminate all transfers on specified channels */
-	dmaengine_terminate_all(dtc->chan);
-
 	kfree(dtc);
 }

--
~Vinod 
