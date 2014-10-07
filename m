Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaJGPFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:05:09 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:56558 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaJGPFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:05:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Vinod Koul <vinod.koul@intel.com>,
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
Date: Tue, 07 Oct 2014 18:05:15 +0300
Message-ID: <2491176.7TIClHxUkE@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20141007145226.GA17925@lukather>
References: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com> <5433D9AF.8020508@atmel.com> <20141007145226.GA17925@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2014 16:52:26 Maxime Ripard wrote:
> On Tue, Oct 07, 2014 at 02:16:47PM +0200, Nicolas Ferre wrote:
> > On 06/10/2014 14:09, Laurent Pinchart :
> > > On Friday 26 September 2014 17:40:35 Maxime Ripard wrote:
> > >> The dmaengine is neither trivial nor properly documented at the moment,
> > >> which means a lot of trial and error development, which is not that
> > >> good for such a central piece of the system.
> > >> 
> > >> Attempt at making such a documentation.
> > >> 
> > >> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > >> ---
> > >> 
> > >>  Documentation/dmaengine/provider.txt | 358 +++++++++++++++++++++++++++
> > >>  1 file changed, 358 insertions(+)
> > >>  create mode 100644 Documentation/dmaengine/provider.txt
> > >> 
> > >> diff --git a/Documentation/dmaengine/provider.txt
> > >> b/Documentation/dmaengine/provider.txt new file mode 100644
> > >> index 000000000000..ba407e706cde
> > >> --- /dev/null
> > >> +++ b/Documentation/dmaengine/provider.txt
> > >> @@ -0,0 +1,358 @@

[snip]

> > >> +Device operations
> > >> +-----------------
> > >> +
> > >> +Our dma_device structure also requires a few function pointers in
> > >> +order to implement the actual logic, now that we described what
> > >> +operations we were able to perform.
> > >> +
> > >> +The functions that we have to fill in there, and hence have to
> > >> +implement, obviously depend on the transaction types you reported as
> > >> +supported.
> > >> +
> > >> +   * device_alloc_chan_resources
> > >> +   * device_free_chan_resources
> > >> +     - These functions will be called whenever a driver will call
> > >> +       dma_request_channel or dma_release_channel for the first/last
> > >> +       time on the channel associated to that driver.
> > >> +     - They are in charge of allocating/freeing all the needed
> > >> +       resources in order for that channel to be useful for your
> > >> +       driver.
> > >> +     - These functions can sleep.
> > >> +
> > >> +   * device_prep_dma_*
> > >> +     - These functions are matching the capabilities you registered
> > >> +       previously.
> > >> +     - These functions all take the buffer or the scatterlist relevant
> > >> +       for the transfer being prepared, and should create a hardware
> > >> +       descriptor or a list of descriptors from it
> > >> +     - These functions can be called from an interrupt context
> > >> +     - Any allocation you might do should be using the GFP_NOWAIT
> > >> +       flag, in order not to potentially sleep, but without depleting
> > >> +       the emergency pool either.
> > > 
> > > You could add "Drivers should try to preallocate the data structures
> > > they require to prepare a transfer."
> > > 
> > >> +
> > >> +     - It should return a unique instance of the
> > >> +       dma_async_tx_descriptor structure, that further represents this
> > >> +       particular transfer.
> > >> +
> > >> +     - This structure can be allocated using the function
> > >> +       dma_async_tx_descriptor_init.
> > > 
> > > That function only initializes the tx descriptor, it doesn't allocate
> > > it.
> > 
> > Beware, it can be confusing when mixing "descriptors" and "hardware
> > descriptors". The ones used by the DMA controller itself to describe the
> > chunks of data (hardware descriptors) and the ones that would represent
> > them in the driver (tx descriptors). However, it's true that both must
> > be prepared by this set of functions.
> 
> There's a few "hardware" missing indeed, but we can't really avoid the
> confusion here, since it does rely also on a dma_async_tx_descriptor.

How about always specifying whether we refer to a "hardware descriptor" or a 
"transaction descriptor" ?

> > >> +     - You'll also need to set two fields in this structure:
> > >> +       + flags:
> > >> +		TODO: Can it be modified by the driver itself, or
> > >> +		should it be always the flags passed in the arguments
> > >> +
> > >> +       + tx_submit:	A pointer to a function you have to implement,
> > >> +			that is supposed to push the current descriptor
> > >> +			to a pending queue, waiting for issue_pending to
> > >> +			be called.
> > 
> > The question remains: why wait when all the information is already
> > prepared and available for the DMA controller to start the job?
> > Actually, we don't wait in at_hdmac, just to be more efficient, but I
> > known that we kind of break this "requirement"... But sorry, it is
> > another discussion which should be lead elsewhere.

>From my recollection of a discussion I've had with Russell King, I believe the 
main reason to separate transaction submission (queueing) issue (start) is to 
let DMA engine drivers issuing several queued requests in one go when hardware 
supports chaining requests only when none of them are running. It's thus just 
an optimization. Russell, could you confirm (or infirm) that ?

> It's just a guess, but maybe you might not be able to schedule the
> transfer right away? Think about a very dumb 1-channel (or a more
> realistic more-DRQ-than-channel) device. You might have all the
> channels busy doing some other transfers, and it's not really part of
> the client driver job to address that kind of contention: it just
> wants to queue some work for a later transfer.

-- 
Regards,

Laurent Pinchart

