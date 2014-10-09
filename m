Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaJII4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:56:55 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:58034 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaJII4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:56:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 2/2] Documentation: dmaengine: Add a documentation for the dma controller API
Date: Thu, 09 Oct 2014 11:56:50 +0300
Message-ID: <2833617.unopUXe32J@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20141008121902.GU1638@intel.com>
References: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com> <2491176.7TIClHxUkE@avalon> <20141008121902.GU1638@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Wednesday 08 October 2014 17:49:02 Vinod Koul wrote:
> On Tue, Oct 07, 2014 at 06:05:15PM +0300, Laurent Pinchart wrote:
> >>> Beware, it can be confusing when mixing "descriptors" and "hardware
> >>> descriptors". The ones used by the DMA controller itself to describe
> >>> the
> >>> chunks of data (hardware descriptors) and the ones that would
> >>> represent
> >>> them in the driver (tx descriptors). However, it's true that both must
> >>> be prepared by this set of functions.
> >> 
> >> There's a few "hardware" missing indeed, but we can't really avoid the
> >> confusion here, since it does rely also on a dma_async_tx_descriptor.
> > 
> > How about always specifying whether we refer to a "hardware descriptor" or
> > a "transaction descriptor" ?
> > 
> >>>>> +     - You'll also need to set two fields in this structure:
> >>>>> +       + flags:
> >>>>> +		TODO: Can it be modified by the driver itself, or
> >>>>> +		should it be always the flags passed in the arguments
> >>>>> +
> >>>>> +       + tx_submit:	A pointer to a function you have to implement,
> >>>>> +			that is supposed to push the current descriptor
> >>>>> +			to a pending queue, waiting for issue_pending to
> >>>>> +			be called.
> >>> 
> >>> The question remains: why wait when all the information is already
> >>> prepared and available for the DMA controller to start the job?
> >>> Actually, we don't wait in at_hdmac, just to be more efficient, but I
> >>> known that we kind of break this "requirement"... But sorry, it is
> >>> another discussion which should be lead elsewhere.
> > 
> > From my recollection of a discussion I've had with Russell King, I believe
> > the main reason to separate transaction submission (queueing) issue
> > (start) is to let DMA engine drivers issuing several queued requests in
> > one go when hardware supports chaining requests only when none of them
> > are running. It's thus just an optimization. Russell, could you confirm
> > (or infirm) that ?
> 
> There are few reasons
> - Allow the dmaengine driver to collect and issue all pending txns in shot
> (which is not happening today with drivers)

Right, that's what I was trying to explain.

> - Allow clients to prepare the txns ahead of time and send them when ready

That's how I would have liked the DMA engine API to work, with the prep calls 
being allowed to sleep, and client drivers preparing transactions in advance. 
As all prep calls must be allowed from atomic context this pretty much defeats 
the purpose.

> > > It's just a guess, but maybe you might not be able to schedule the
> > > transfer right away? Think about a very dumb 1-channel (or a more
> > > realistic more-DRQ-than-channel) device. You might have all the
> > > channels busy doing some other transfers, and it's not really part of
> > > the client driver job to address that kind of contention: it just
> > > wants to queue some work for a later transfer.

-- 
Regards,

Laurent Pinchart

