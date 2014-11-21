Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbaKUM3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:29:09 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:58434 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaKUM3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:29:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Date: Fri, 21 Nov 2014 13:27:56 +0100
Message-ID: <3361735.Hm5JJchlei@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141121113618.GD19783@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com> <2310899.ejrSzj6BIr@wuerfel> <20141121113618.GD19783@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fyBhzpDGXr9vYzuQWD5t1m8JYLq/IbwQ+T8wwhbEDlT
 Y0S2yWo4QNrnFJVMucIbWwlNH8/g9G7v3swVTuKSJFGFNYkUpH
 oWC67D+Az1T6pvkRy2cl786X2Ipj2HXU1V/x1ueRH9f8fBYWcL
 0cDb976v3sKBEwVxBfB4SqZHXePrSPTpNgyGJW5120IRcznrNR
 8nhfEubSvEkMgjhlqeoV++DhVzCaVD7Q7NKWTYm/LaiGUo7itv
 TToD0ciiQbW8Hn9u2LdSmv4p82PIyRRxLcwVIjIVdxAYaySRWW
 fe+5ioUcyITdBQZMfi8evTpf0aOOfmNxROnc4qvOvmamQVzMQc
 ifZrRIx8cCoCbXCR/Sak=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 11:36:18 Catalin Marinas wrote:
> On Fri, Nov 21, 2014 at 11:26:45AM +0000, Arnd Bergmann wrote:
> > On Friday 21 November 2014 11:06:10 Catalin Marinas wrote:
> > > On Wed, Nov 19, 2014 at 03:56:42PM +0000, Arnd Bergmann wrote:
> > > > On Wednesday 19 November 2014 15:46:35 Catalin Marinas wrote:
> > > > > Going back to original topic, the dma_supported() function on arm64
> > > > > calls swiotlb_dma_supported() which actually checks whether the swiotlb
> > > > > bounce buffer is within the dma mask. This transparent bouncing (unlike
> > > > > arm32 where it needs to be explicit) is not always optimal, though
> > > > > required for 32-bit only devices on a 64-bit system. The problem is when
> > > > > the driver is 64-bit capable but forgets to call
> > > > > dma_set_mask_and_coherent() (that's not the only question I got about
> > > > > running out of swiotlb buffers).
> > > > 
> > > > I think it would be nice to warn once per device that starts using the
> > > > swiotlb. Really all 32-bit DMA masters should have a proper IOMMU
> > > > attached.
> > > 
> > > It would be nice to have a dev_warn_once().
> > > 
> > > I think it makes sense on arm64 to avoid swiotlb bounce buffers for
> > > coherent allocations altogether. The __dma_alloc_coherent() function
> > > already checks coherent_dma_mask and sets GFP_DMA accordingly. If we
> > > have a device that cannot even cope with a 32-bit ZONE_DMA, we should
> > > just not support DMA at all on it (without an IOMMU). The arm32
> > > __dma_supported() has a similar check.
> > 
> > If we ever encounter this case, we may have to add a smaller ZONE_DMA
> > and use ZONE_DMA32 for the normal dma allocations.
> 
> Traditionally on x86 I think ZONE_DMA was for ISA and ZONE_DMA32 had to
> cover the 32-bit physical address space. On arm64 we don't expect ISA,
> so we only use ZONE_DMA (which is 4G, similar to IA-64, sparc). We had
> ZONE_DMA32 originally but it broke swiotlb which assumes ZONE_DMA for
> its bounce buffer.

Right, I'm just saying that we might encounter some broken hardware
that needs e.g. a 31-bit dma mask for one device, and we decide that
this chip is important enough that we have to support it.

We can of course hope that this won't happen.

	Arnd
