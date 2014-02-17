Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaBQSQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:16:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbaBQSQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:16:29 -0500
Date: Mon, 17 Feb 2014 10:18:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stanislav Meduna <stano@meduna.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        hjk@hansjkoch.de
Subject: Re: UIO and memory from dma_alloc_coherent - UIO_MEM_PHYS?
Message-ID: <20140217181854.GA7119@kroah.com>
References: <53024FAD.2000709@meduna.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53024FAD.2000709@meduna.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 07:06:37PM +0100, Stanislav Meduna wrote:
> Hi,
> 
> what is the correct way for a UIO driver to pass a memory allocated
> using dma_alloc_coherent to userspace? I have googled for examples
> but I was not able to find a definitive answer.
> 
> My device needs two 128 kB chunks of DMA-able memory. First I tried
> 
>   pdev->tx_vaddr = dma_zalloc_coherent(&dev->dev, pdev->dma_len,
>                      &pdev->tx_paddr, GFP_KERNEL | GFP_DMA);
> 
>   info->mem[2].name = "txdma";
>   info->mem[2].addr = (phys_addr_t) pdev->tx_vaddr;
>   info->mem[2].size = pdev->dma_len;
>   info->mem[2].memtype = UIO_MEM_LOGICAL;
> 
> This seemed to work at the first try, but tends to panic in various
> ways when unmapping. It probably only maps the first page or something
> like that and accessing past some limit overwrites something.

Have you tried the uio_dmem_genirq.c driver?  Or are you writing a new
one?

> If I change this to
> 
>   info->mem[2].addr = (phys_addr_t) pdev->tx_paddr;
>   info->mem[2].memtype = UIO_MEM_PHYS;
> 
> it seems to work at least on x86 with < 4GB memory. The uio_pruss.c
> (or uio_dmem_genirq.c in newer kernels) do this as well.
> 
> I have a bad feeling here - if I am allocating something that
> is a virtual memory in the kernel, I don't expect to pretend I am
> accessing something else. The UIO howto explicitely states
> that UIO_MEM_PHYS is meant for a "physical memory on your card".
> 
> Is this really a recommended way of doing this and is it portable
> to other architectures?
> 
> I am using 3.4 kernel with realtime patches.

The uio_dmem_genirq.c driver showed up in 3.8, so it might be good for
you to update your kernel if you want to do DMA memory with a UIO
driver, as lots of other things in this area was fixed to accomplish
this.

Hope this helps,

greg k-h
