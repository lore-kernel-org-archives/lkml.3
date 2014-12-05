Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaLELtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:49:51 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:36020 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaLELtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:49:50 -0500
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="52197840"
From: Hante Meuleman <meuleman@broadcom.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arend Van Spriel <arend@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: using DMA-API on ARM
Thread-Topic: using DMA-API on ARM
Thread-Index: AQHQEGz8Uq/ZoaNhbU+cR76RcmjkiZyBR34AgAAWIQD//4JWoA==
Date: Fri, 5 Dec 2014 11:49:48 +0000
Message-ID: <F51492713EF10846800D8C0ED37A7DCE01901691@SJEXCHMB15.corp.ad.broadcom.com>
References: <5481794E.4050406@broadcom.com> <4565667.WCBuNmaazQ@wuerfel>
 <20141205111114.GQ11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141205111114.GQ11285@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for investigating. Your analysis matches what was intended to be done. Regarding the cast, you're right, I'll improve it. My idea was that long long is always 64bit, but when casting directly to long long I get a compiler (when using C=2) warning: "warning: right shift by bigger than source value". Probably I concluded wrongly that I should cast it to long first. On the targets used the high address was always 0, so I got away with it thusfar, but indeed it should and shall be fixed.

Regards,
Hante

-----Original Message-----
From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] 
Sent: vrijdag 5 december 2014 12:11
To: Arnd Bergmann
Cc: linux-arm-kernel@lists.infradead.org; Arend Van Spriel; linux-wireless; brcm80211-dev-list; David Miller; linux-kernel@vger.kernel.org
Subject: Re: using DMA-API on ARM

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
