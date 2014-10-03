Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaJCQ5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:57:30 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52759 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753876AbaJCQ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:57:29 -0400
Date: Fri, 3 Oct 2014 17:57:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Ian.Campbell@citrix.com, linux-arm-kernel@lists.infradead.org,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v2 2/2] xen/arm: introduce GNTTABOP_cache_flush
Message-ID: <20141003165716.GW5182@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1410031549150.17038@kaball.uk.xensource.com> <1412348006-27884-2-git-send-email-stefano.stabellini@eu.citrix.com> <542EBB2A.6030104@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542EBB2A.6030104@citrix.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 04:05:14PM +0100, David Vrabel wrote:
> Are all these cache operations needed?  You do a clean on map regardless
> of the direction and INVAL on map seems unnecessary.
> 
> I would have thought it would be:
> 
> map && (TO_DEVICE || BOTH)
>    op = CLEAN
> 
> unmap && (FROM_DEVICE || BOTH)
>    op = INVAL

This is wrong.  You've failed to consider the case where you have dirty
cache lines in the cache before the DMA operation, and the DMA operation
is going to write to memory.  So, let's take this case, and work it
through.

At the map point, we do nothing.  This leaves dirty cache lines in the
cache.

DMA commences, and starts writing data into the memory.  Meanwhile, the
CPU goes off and does something else.

The cache then wants to evict a line, and picks one of the dirty lines
associated with this region.  The dirty data is written back to memory,
overwriting the newly DMA'd data.

Meanwhile, the CPU may speculatively load cache lines corresponding with
this memory, possibly from the part which has not yet been updated by the
DMA activity.

At the end of the DMA, we unmap, and at this point we invalidate the cache,
getting rid of any remaining dirty lines, and the speculatively loaded
lines.

We now have corrupted data in the memory region.  So, maybe you'll be
saying bye bye to your filesystem at this point...

You could always clean at map time, but in the case of DMA from the device,
this is a waste of bus cycles since you don't need the dirty lines in the
cache written back to memory.  If you can invalidate, you might as well do
that for this case and save writing back data to memory which you're about
to overwrite with DMA.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
