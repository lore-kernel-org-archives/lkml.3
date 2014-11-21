Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaKUL1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:27:02 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57950 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaKUL1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:27:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Date: Fri, 21 Nov 2014 12:26:45 +0100
Message-ID: <2310899.ejrSzj6BIr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141121110609.GC19783@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com> <3918100.vD6471iH9k@wuerfel> <20141121110609.GC19783@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LF0qIIwSd6uI6+Yc7gJA1U6iyc5cCXy0opzFR7AQ9gh
 LVhoytpO6yDJvkrJI/Jwv+WD1Uwsnr7z4e+gCT7XWovUJ62IQt
 7Rl0Av1PSWpmgZXr1CcYCpvvedUwQGtXWmWFOBqXRMqHL1t4jw
 787kZYJjwTvHlEHN47ODQ6krObdgZ0wuha72hSoR2uVQpFGcew
 CP9Uwk79FXgd5Oxbcq/Q46RM9dBhjynK9xuk2PKDtgQItB1ehi
 RjDptVaV4kVF658ifFmj5kjm77LhA297mTHNy7MjOCsEGuFhp2
 TB8oBPW2KVARF2ZGX+veybsyToDE1Mj/HHu29nP+QcKidUoKjI
 +ZIwriJsKo+ffML2DNQg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 11:06:10 Catalin Marinas wrote:
> On Wed, Nov 19, 2014 at 03:56:42PM +0000, Arnd Bergmann wrote:
> > On Wednesday 19 November 2014 15:46:35 Catalin Marinas wrote:
> > > Going back to original topic, the dma_supported() function on arm64
> > > calls swiotlb_dma_supported() which actually checks whether the swiotlb
> > > bounce buffer is within the dma mask. This transparent bouncing (unlike
> > > arm32 where it needs to be explicit) is not always optimal, though
> > > required for 32-bit only devices on a 64-bit system. The problem is when
> > > the driver is 64-bit capable but forgets to call
> > > dma_set_mask_and_coherent() (that's not the only question I got about
> > > running out of swiotlb buffers).
> > 
> > I think it would be nice to warn once per device that starts using the
> > swiotlb. Really all 32-bit DMA masters should have a proper IOMMU
> > attached.
> 
> It would be nice to have a dev_warn_once().
> 
> I think it makes sense on arm64 to avoid swiotlb bounce buffers for
> coherent allocations altogether. The __dma_alloc_coherent() function
> already checks coherent_dma_mask and sets GFP_DMA accordingly. If we
> have a device that cannot even cope with a 32-bit ZONE_DMA, we should
> just not support DMA at all on it (without an IOMMU). The arm32
> __dma_supported() has a similar check.

If we ever encounter this case, we may have to add a smaller ZONE_DMA
and use ZONE_DMA32 for the normal dma allocations.

> Swiotlb is still required for the streaming DMA since we get bouncing
> for pages allocated outside the driver control (e.g. VFS layer which
> doesn't care about GFP_DMA), hoping a 16M bounce buffer would be enough.
> 
> Ding seems to imply that CMA fixes the problem, which means that the
> issue is indeed coherent allocations.

I wonder what's going on here, since swiotlb_alloc_coherent() actually
tries a regular __get_free_pages(flags, order) first, and when ZONE_DMA
is set here, it just work without using the pool.

	Arnd
