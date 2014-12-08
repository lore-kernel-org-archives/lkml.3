Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbaLHQjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:39:17 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:53643 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaLHQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:39:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Hante Meuleman <meuleman@broadcom.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>, hauke@hauke-m.de
Subject: Re: using DMA-API on ARM
Date: Mon, 08 Dec 2014 17:38:57 +0100
Message-ID: <2048819.2EPzBi8E3T@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5485D054.7090109@broadcom.com>
References: <5481794E.4050406@broadcom.com> <2863746.4sUSEYqahB@wuerfel> <5485D054.7090109@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:2CkTiAofQJFzFf2jlZZCuEE5PtqcI5zTA0d7YlquXStvfhi4W7B
 wVcnYuLqz4xUrxEAlfkZB9fgbFsNt0BEF3K+/u79Nr1xha+FPEjzBVEgftJhDQdDKk0VcdE
 2/P5R65EIAq0XC/qzUp4j4bAY8748HdeChAkEqsxjyCVTbz2Grj5Db6OQylmq5Fm1pgAx/B
 M8XAUkMVgVZxRivpSSU1g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 17:22:44 Arend van Spriel wrote:
> >> The log: first the ring allocation info is printed. Starting at
> >> 16.124847, ring 2, 3 and 4 are rings used for device to host. In this
> >> log the failure is on a read of ring 3. Ring 3 is 1024 entries of each
> >> 16 bytes. The next thing printed is the kernel page tables. Then some
> >> OpenWRT info and the logging of part of the connection setup. Then at
> >> 1780.130752 the logging of the failure starts. The sequence number is
> >> modulo 253 with ring size of 1024 matches an "old" entry (read 40,
> >> expected 52). Then the different pointers are printed followed by
> >> the kernel page table. The code does then a cache invalidate on the
> >> dma_handle and the next read the sequence number is correct.
> >
> > How do you invalidate the cache? A dma_handle is of type dma_addr_t
> > and we don't define an operation for that, nor does it make sense
> > on an allocation from dma_alloc_coherent(). What happens if you
> > take out the invalidate?
> 
> dma_sync_single_for_cpu(, DMA_FROM_DEVICE) which ends up invalidating 
> the cache (or that is our suspicion).

I'm not sure about that:

static void arm_dma_sync_single_for_cpu(struct device *dev,
                dma_addr_t handle, size_t size, enum dma_data_direction dir)
{
        unsigned int offset = handle & (PAGE_SIZE - 1);
        struct page *page = pfn_to_page(dma_to_pfn(dev, handle-offset));
        __dma_page_dev_to_cpu(page, offset, size, dir);
}

Assuming a noncoherent linear (no IOMMU, no swiotlb, no dmabounce) mapping,
dma_to_pfn will return the correct pfn here, but pfn_to_page will return a
page pointer into the kernel linear mapping, which is not the same
as the pointer you get from __alloc_remap_buffer(). The pointer that
was returned from dma_alloc_coherent is a) non-cachable, and b) not the
same that you flush here.

	Arnd
