Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaLELLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:11:38 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39035 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138AbaLELLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:11:36 -0500
Date: Fri, 5 Dec 2014 11:11:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: using DMA-API on ARM
Message-ID: <20141205111114.GQ11285@n2100.arm.linux.org.uk>
References: <5481794E.4050406@broadcom.com>
 <4565667.WCBuNmaazQ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4565667.WCBuNmaazQ@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:52:02AM +0100, Arnd Bergmann wrote:
> I'm still puzzled why you'd need a single dma_sync_single_for_cpu()
> after dma_alloc_coherent though, you should not need any. Is it possible
> that the driver accidentally uses __raw_readl() instead of readl()
> in some places and you are just lacking an appropriate barrier?

Digging into the driver, it looks like individual DMA buffers are
allocated (via brcmf_pcie_init_dmabuffer_for_device) and registered
into a "commonring" layer.

Whenever the buffer is written to, space is first allocated via a call
to brcmf_commonring_reserve_for_write() or
brcmf_commonring_reserve_for_write_multiple(), data written to the
buffer, followed by a call to brcmf_commonring_write_complete().

brcmf_commonring_write_complete() calls two methods at that point:
cr_write_wptr() and cr_ring_bell(), which will be
brcmf_pcie_ring_mb_write_wptr() and brcmf_pcie_ring_mb_ring_bell().

The first calls brcmf_pcie_write_tcm16(), which uses iowrite16(),
which contains the appropriate barrier.  The bell ringing functions
also use ioread*/iowrite*().

So, on the write side, it looks fine from the barrier perspective.

On the read side, brcmf_commonring_get_read_ptr() is used before
a read access to the ring - which calls the cr_update_wptr() method,
which in turn uses an ioread16() call.  After the CPU has read data
from the ring, brcmf_commonring_read_complete() is used, which uses
iowrite16().

So, I don't see a barrier problem on the read side.

However, I did trip over this:

static void *
brcmf_pcie_init_dmabuffer_for_device(struct brcmf_pciedev_info *devinfo,
                                     u32 size, u32 tcm_dma_phys_addr,
                                     dma_addr_t *dma_handle)
{
        void *ring;
        long long address;

        ring = dma_alloc_coherent(&devinfo->pdev->dev, size, dma_handle,
                                  GFP_KERNEL);
        if (!ring)
                return NULL;

        address = (long long)(long)*dma_handle;

Casting to (long) will truncate the DMA handle to 32-bits on a 32-bit
architecture, even if it supports 64-bit DMA addresses.  There's a couple
of other places where this same truncation occurs:

        address = (long long)(long)devinfo->shared.scratch_dmahandle;

and

        address = (long long)(long)devinfo->shared.ringupd_dmahandle;

In any case, wouldn't using a u64 type for "address" be better - isn't
"long long" 128-bit on 64-bit architectures?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
