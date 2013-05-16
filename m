Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3EPPnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:43:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39130 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265Ab3EPPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:43:17 -0400
Date: Thu, 16 May 2013 16:35:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: "djbw@fb.com" <djbw@fb.com>, "vinod.koul@intel.com" <vinod.koul@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "andriy.shevchenko@linux.intel.com" 
	<andriy.shevchenko@linux.intel.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
Subject: Re: dmatest regression in 3.10-rc1
Message-ID: <20130516153553.GI11706@mudshark.cambridge.arm.com>
References: <20130515152803.GL23869@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515152803.GL23869@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 04:28:03PM +0100, Will Deacon wrote:
> I've been observing a regression in the dmatest module with 3.10-rc1. It
> manifests as either:
> 
>  - a spurious timeout on one or more of the channel threads
>  - a complete kernel lockup (loss of console)
>  - a panic (see below, noting that the callback [dmatest_callback] is
>    dereferencing a NULL pointer)
> 
> If I revert 77101ce578bb ("dmatest: cancel thread immediately when asked
> for") then things are rosy again, but I'm not sure if this is hiding another
> problem.

Right, so I think I understand what's causing this, but I'll leave it to
Andriy to suggest a fix. The problem comes about because the dmatest
module is now driven from debugfs, making it possible to unload the module
whilst a test run is in progress. In this case:

	- The DMA threads will return from wait_event_freezable_timeout(...)
	  due to kthread_should_stop() returning true, and subsequently
	  report failure because done.done is false.

	- The DMA engines may not be idle, so the asynchronous callback can
	  be invoked after we've started cleaning up, explaining the NULL
	  dereference I'm seeing.

The solutions are either fixing the module exit code to cope with concurrent
DMA transfers or to revert 77101ce578bb and not allow the channel threads to
return mid-transfer.

Will
