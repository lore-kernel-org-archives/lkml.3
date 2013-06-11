Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3FKLCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:02:53 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15296 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3FKLCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:02:51 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-0f-51b703d98374
Message-id: <51B703D7.8050804@samsung.com>
Date: Tue, 11 Jun 2013 13:02:47 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509
 Thunderbird/17.0.6
MIME-version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
References: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com>
 <CAErSpo6kss-v0w_1ker__vPqNCRNLx+z8nk+0r=D-40D3TuDCA@mail.gmail.com>
In-reply-to: <CAErSpo6kss-v0w_1ker__vPqNCRNLx+z8nk+0r=D-40D3TuDCA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xa7o3mbcHGqz8zWfxd9IxdoslTRkW
	Hbu+slhc3jWHzeLdywiLJx9Psziwefz+NYnRY8GmUo+/XVOYPT5vkvPY+/k3SwBrFJdNSmpO
	Zllqkb5dAlfGqaP/WAtW8lX0rr/F2MB4kruLkZNDQsBEYsu8OewQtpjEhXvr2UBsIYGljBIL
	V5hC2M1MEpenhoPYvAJaEgdnXWUEsVkEVCWeztkL1ssmYCjR9bYLqJeDQ1QgVOL3SnOIckGJ
	H5PvsYDYIgLqEguPvmfqYuTiYBa4wShx/MATsISwgJvE+X07mSB2LWOU2PXQG8TmFAiW2NvV
	BRZnFjCTeNSyjhnClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGCEh/WUH4+JjVocYBTgYlXh4DXdsCxRiTSwrrsw9xCjBwawkwivJuD1QiDclsbIq
	tSg/vqg0J7X4ECMTB6dUAyPb864nN+8VG987XPX/9gdtw9fHvmTtfrfO4edejhUbhb+6s2x+
	dn7WVKannybuM5g/+W68i9js1seTu/UfRhqq+Oo//LT1afETI90nsu8vTSmaUihgbrszzL3j
	udsih8LFz6peqUvwn/P+Fyx+5mnV328x8ZMT0+pktiV/LdfL2PUp6FKyXu9GJZbijERDLeai
	4kQAEWa2q0cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 6/11/2013 4:34 AM, Bjorn Helgaas wrote:
> [+cc Marek]
>
> On Mon, Jun 3, 2013 at 6:44 AM, Michal Simek <michal.simek@xilinx.com> wrote:
> > Check that dma_ops are initialized correctly.
> >
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > ---
> > Functions dma_mmap_attrs(), dma_get_sgtable_attrs()
> > already have this checking.
> >
> > ---
> >  include/asm-generic/dma-mapping-common.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
> > index de8bf89..d430cab 100644
> > --- a/include/asm-generic/dma-mapping-common.h
> > +++ b/include/asm-generic/dma-mapping-common.h
> > @@ -16,6 +16,7 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
> >         dma_addr_t addr;
> >
> >         kmemcheck_mark_initialized(ptr, size);
> > +       BUG_ON(!ops);
>
> Does this actually help anything?  I expected that if "ops" is NULL,
> we would just oops anyway when we attempted to call "ops->map_page()"
> because we already trap null pointer dereferences.  At least, when I
> tried leaving a pci_bus.ops pointer NULL, I got a nice panic and
> backtrace even without adding an explicit BUG_ON().
>
> I cc'd Marek, who added the similar BUG_ON()s in dma_mmap_attrs() and
> dma_get_sgtable_attrs() with d2b7428eb0 and 64ccc9c033.

I think that I've copied it from dma_alloc_coherent() in microblaze. You 
are right that lack
of this check will also trigger oops in ops==NULL case, but I think that 
adding explicit check
in all functions, which use it, is a good idea. It serves as a kind of 
documentation and
emphasizes that missing ops is really an issue.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


