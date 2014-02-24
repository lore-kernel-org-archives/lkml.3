Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaBXTWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:22:09 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49242 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752836AbaBXTWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:22:07 -0500
Date: Mon, 24 Feb 2014 19:21:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joel Fernandes <joelf@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: Ideas/suggestions to avoid repeated locking and reducing too
	many lists with dmaengine?
Message-ID: <20140224192152.GV27282@n2100.arm.linux.org.uk>
References: <530B9784.5060904@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B9784.5060904@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrapping... (I've had to manually edit this.)

On Mon, Feb 24, 2014 at 01:03:32PM -0600, Joel Fernandes wrote:
> Just wanted your thoughts/suggestions on how we can avoid overhead in
> the EDMA dmaengine driver. I am seeing a lots of performance drop
> specially for small transfers with EDMA versus before raw EDMA was
> moved to DMAEngine framework (atleast 25%).
> 
> One of the things I am thinking about is the repeated (spin)
> locking/unlocking of the virt_dma_chan->lock or vc->lock. In many
> cases, there's only 1 user or thread requiring to do a DMA, so I
> feel the locking is unnecessary and potential overhead. If there's
> a sane way to detect this an avoid locking altogether, that
> would be great.

For the case where there's no contention, spinlocks /should/ be light.
What will make them more expensive is if you have things like lockdep
enabled, which adds much more code into those paths to do state tracking.
It's a known side effect of using that debug.

So, if you're developing, then you should always have turned lockdep on.
If you're testing for performance, you should have lockdep and spinlock
debugging turned off.

>  Also with respect to virt_dma (which is used by edma to manage all the
> descriptors and lists) there are too many lists: submitted, issued,
> completed etc and the descriptor moves from one to the other. I am
> thinking if there is a way we can avoid using so many lists and just
> have 2 lists and move the desc from one list to the other, That could
> avoid using the intermediate list altogether and classify dma requests
> as "done" or "not done".

The reason I created separate submitted and issued lists is that it's
much easier to manage than having everything on a single list.

We could deal with the submitted vs issued list, and that's to have the
channel store the cookie for the last issued descriptor - but I wonder
if it's worth the effort.

What I'd suggest is to try some profiling, and post some profiling
results which show where the problems are, rather than pointing at
bits of code you might not particularly like.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
