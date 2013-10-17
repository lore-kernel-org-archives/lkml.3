Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3JQKqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:46:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:8290 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab3JQKqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:46:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,513,1378882800"; 
   d="scan'208";a="394334019"
Date: Thu, 17 Oct 2013 15:23:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
Message-ID: <20131017095308.GF14013@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
 <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
 <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
 <20131017020745.GA14013@intel.com>
 <Pine.LNX.4.64.1310170851230.27369@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1310170851230.27369@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 10:27:13AM +0200, Guennadi Liakhovetski wrote:
> On Thu, 17 Oct 2013, Vinod Koul wrote:
> 
> > On Wed, Oct 16, 2013 at 11:45:48AM -0700, Dan Williams wrote:
> > > On Wed, Oct 16, 2013 at 11:29 AM, Guennadi Liakhovetski
> > > >
> > > > Doesn't this break kernel compilation for a total of 27 commits? Or am I
> > > > missing anything?
> > > 
> > > Yes, I think at the start DMA_COMPLETE should just be a alias for
> > > DMA_SUCCESS, then after all the driver renames are in delete
> > > DMA_SUCCESS.
> > Oops, taht was bad of me. ffixes in v2 and sending patch 29 for removal case
> 
> Ok, yes, this should work now. I'm wondering though - is DMA_COMPLTE 
> really a better name? AFAICS, we can only differentiate between 2 
> possibilities with the current API: a transfer is "in progress" - between 
> last used and last completed, and "unknown" - either completed, or 
> aborted, or not yet submitted - if the cookie is larger, than last 
> completed and we assume, that it has wrapped.
well, once you submit N, and chekcing status, if you get last > N, then you
assume it completed. If last is M then M is completed and M + 1 running and rest
in queue. You know which one is last submitted in client

> Actually for a driver, that I'm currently working on, I implemented a 
> cache of N last cookies (e.g. 128), which is a bitfield, where I just 
> record a 1, if that descriptor has failed, and a 0, if completed 
> successfully. That way I can report one of 4 states: cookie on queue, 
> completed successfully, failed, unknown. I'm not sure, whether I'll keep 
> this in the final version, this doesn't really fit the present dmaengine 
> API concept. We could make this generic, if desired. Otherwise your 
> proposed error callback should help too. But in either case I think with 
> the current implementation we cannot find out whether a specific cookie 
> completed successfully or failed.
The propsed error callback will tell you if dmaengine detected a failure or not.
That should with above cover well

> One more observation: I looked at a couple of drivers, using the DMA_ERROR 
> state. E.g. mmp_tdma.c, mxs-dma.c. They store errors in a .status field in 
> their private data. Then they return that status in their 
> .device_tx_status() methods - independent on the cookie! This doesn't look 
> right to me... at_hdmac.c does something similarly strange.
Yup bunch of ones arent being good citizens..

~Vinod
-- 
