Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaLEJwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 04:52:21 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:55056 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaLEJwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 04:52:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Arend van Spriel <arend@broadcom.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: using DMA-API on ARM
Date: Fri, 05 Dec 2014 10:52:02 +0100
Message-ID: <4565667.WCBuNmaazQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5481794E.4050406@broadcom.com>
References: <5481794E.4050406@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:dNe+OBLdd34aix4POs8gSm/AvPCblLKqtUsxUmXFvxVJ89WJijP
 IbKk0+DeA8bzdqeImsfRlu4vWoZtlhilNMkxcV2b8DOnn3fW55YC+gxIa5ciSqufQrJ+FNt
 RMjDtS1YIROzavOJivXamVyyB7xsgatC7hO/WTdKUdhq/p2rb9L1a5g3LfyPdtexxNIp0DH
 mxxazvlZRDtPVkkB4MdBw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2014 10:22:22 Arend van Spriel wrote:
> Hi Russell,
> 
> For our brcm80211 development we are working on getting brcmfmac driver
> up and running on a Broadcom ARM-based platform. The wireless device is
> a PCIe device, which is hooked up to the system behind a PCIe host
> bridge, and we transfer information between host and device using a
> descriptor ring buffer allocated using dma_alloc_coherent(). We mostly
> tested on x86 and seen no issue. However, on this ARM platform
> (single-core A9) we detect occasionally that the descriptor content is
> invalid. When this occurs we do a dma_sync_single_for_cpu() and this is
> retried a number of times if the problem persists. Actually, found out
> that someone made a mistake by using virt_to_dma(va) to get the
> dma_handle parameter. So probably we only provided a delay in the retry
> loop. After fixing that a single call to dma_sync_single_for_cpu() is
> sufficient. The DMA-API-HOWTO clearly states that:
> 
> """
> the hardware should guarantee that the device and the CPU can access the
> data in parallel and will see updates made by each other without any
> explicit software flushing.
> """
> 
> So it seems incorrect that we would need to do a dma_sync for this
> memory. That we do need it seems like this memory can end up in
> cache(?), or whatever happens, in some rare condition. Is there anyway
> to investigate this situation either through DMA-API or some low-level
> ARM specific functions.

I think the problem comes down to not following the advice from this
comment in asm/dma-mapping.h:

/*
 * dma_to_pfn/pfn_to_dma/dma_to_virt/virt_to_dma are architecture private
 * functions used internally by the DMA-mapping API to provide DMA
 * addresses. They must not be used by drivers.
 */

The previous behavior of the driver is clearly wrong and cannot work
on any architecture that has noncoherent PCI DMA or uses swiotlb, and
that includes some older 64-bit x86 machines (Pentium D and similar).

I'm still puzzled why you'd need a single dma_sync_single_for_cpu()
after dma_alloc_coherent though, you should not need any. Is it possible
that the driver accidentally uses __raw_readl() instead of readl()
in some places and you are just lacking an appropriate barrier?

	Arnd
