Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaKSMtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:49:16 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:63421 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaKSMtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:49:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: For the problem when using swiotlb
Date: Wed, 19 Nov 2014 13:48:58 +0100
Message-ID: <1497289.TPKf3qDiKk@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141119112910.GD7156@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com> <1535751.CcvIi3DN4F@wuerfel> <20141119112910.GD7156@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:I/ptBz8IY1PTelI/3CedNpeATcr7n1roYOoY2NSahs+
 hFpnKBTtKH6sExYGQNaPlU77nwL4gUn9SFADgLCS75ZotXeZlf
 iQTY+M6IpGN+bX8tXv1M8BAGxUyVstezWEPxm9lL+XdwYQNZFQ
 JuzMT+2X8wOSSClRsa1E2koJzCmADQC9oPzOtnpHi1+Qj1N4Tn
 SyWBfcJOccalAgYwxEtIhBolwzwDUp5tEZ5WVmn8Am4gnoqNAb
 k5Z6Zge5YLGGQra+zhJtDOBEKTkdhsTjEZTmgIvXrNTH7L5Giq
 6jSqUiLPJDbeU96wrZs+PAqFACJhstn9IRzqLuC28/oMwA8I0E
 H4g/yh5O6sh7GcYy+M+Y=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2014 11:29:10 Catalin Marinas wrote:
> > The driver should call 'dma_set_mask_and_coherent()' with the appropriate
> > dma mask, and check whether that succeeded. However, the code implementing
> > dma_set_mask_and_coherent on arm64 also needs to be changed to look up
> > the dma-ranges property (see of_dma_configure()), and check if the mask
> > is possible.
> 
> dma_set_mask_and_coherent() is a generic function. I think the
> of_dma_configure() should start with a coherent_dma_mask based on
> dma-ranges if given rather than defaulting to DMA_BIT_MASK(32). The
> comment in of_dma_configure() says that devices should set up the
> supported mask but it's not always up to them but the bus they are
> connected to.
> 
> Something like below, untested:
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 3b64d0bf5bba..dff34883db45 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -200,6 +200,10 @@ static void of_dma_configure(struct device *dev)
>         /* DMA ranges found. Calculate and set dma_pfn_offset */
>         dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
>         dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> +
> +       /* Set the coherent_dma_mask based on the dma-ranges property */
> +       if (size)
> +               dev->coherent_dma_mask = DMA_BIT_MASK(ilog2(size));
>  }
>  
> 

We have discussed this in the past, and the problem with this is
that the actual mask depends both on the capabilities of the
device and the bus. In particular, if the device can only do
32-bit DMA, we must not set the mask to something higher.

The normal rule here is that a driver that wants to do 64-bit
DMA must call dma_set_mask_and_coherent() with the higher mask,
while a device that can not access all of the 32-bit address space
must call dma_set_mask_and_coherent() with the smaller mask
before doing calling any of the other DMA interfaces.

However, if the bus is not capable of addressing the entire
32-bit range (as on some modern shmobile machines, or some of the
really old machines), we need to limit the mask here already.

	Arnd
