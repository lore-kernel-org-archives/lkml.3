Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3AOURQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:17:16 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:58457 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750963Ab3AOURP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:17:15 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX181yDVvUT+CjbDJTAWmVKsN+NfG4LSWORQ=
Date: Tue, 15 Jan 2013 15:16:17 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Soeren Moch <smoch@web.de>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linaro-mm-sig@lists.linaro.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Message-ID: <20130115201617.GC25500@titan.lakedaemon.net>
References: <20121119144826.f59667b2.akpm@linux-foundation.org>
 <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
 <50F3F289.3090402@web.de>
 <20130115165642.GA25500@titan.lakedaemon.net>
 <20130115175020.GA3764@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115175020.GA3764@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 09:50:20AM -0800, Greg KH wrote:
> On Tue, Jan 15, 2013 at 11:56:42AM -0500, Jason Cooper wrote:
> > Greg,
> > 
> > I've added you to the this thread hoping for a little insight into USB
> > drivers and their use of coherent and GFP_ATOMIC.  Am I barking up the
> > wrong tree by looking a the drivers?
> 
> I don't understand, which drivers are you referring to?  USB host
> controller drivers, or the "normal" drivers?

Sorry I wasn't clear, I was referring specifically to the usb dvb
drivers em28xx, drxk and dib0700.  These are the drivers reported to be
in heavy use when the error occurs.

sata_mv is also in use, however no other users of sata_mv have reported
problems.  Including myself. ;-)

> Most USB drivers use GFP_ATOMIC if they are creating memory during
> their URB callback path, as that is interrupt context.  But it
> shouldn't be all that bad, and the USB core hasn't changed in a while,
> so something else must be causing this.

Agreed, so I went and did more reading.  The key piece of the puzzle
that I was missing was in arch/arm/mm/dma-mapping.c 660-684.

/*
 * Allocate DMA-coherent memory space and return both the kernel
 * remapped
 * virtual and bus address for that space.
 */
void *arm_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
                    gfp_t gfp, struct dma_attrs *attrs)
{
        pgprot_t prot = __get_dma_pgprot(attrs, pgprot_kernel);
        void *memory;

        if (dma_alloc_from_coherent(dev, size, handle, &memory))
                return memory;

        return __dma_alloc(dev, size, handle, gfp, prot, false,
                           __builtin_return_address(0));
}

static void *arm_coherent_dma_alloc(struct device *dev, size_t size,
        dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
{
        pgprot_t prot = __get_dma_pgprot(attrs, pgprot_kernel);
        void *memory;

        if (dma_alloc_from_coherent(dev, size, handle, &memory))
                return memory;

        return __dma_alloc(dev, size, handle, gfp, prot, true,
                           __builtin_return_address(0));
}


My understanding of this code is that when a driver requests dma memory,
we will first try to alloc from the per-driver pool.  If that fails, we
will then attempt to allocate from the atomic_pool.

Once the atomic_pool is exhausted, we get the error:

  ERROR: 1024 KiB atomic DMA coherent pool is too small!
  Please increase it with coherent_pool= kernel parameter!

If my understanding is correct, one of the drivers (most likely one)
either asks for too small of a dma buffer, or is not properly
deallocating blocks from the per-device pool.  Either case leads to
exhaustion, and falling back to the atomic pool.  Which subsequently
gets wiped out as well.

Am I on the right track?

thx,

Jason.
