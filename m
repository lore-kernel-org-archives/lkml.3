Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaBQSYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:24:36 -0500
Received: from www.meduna.org ([92.240.244.38]:60863 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbaBQSYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:24:35 -0500
X-Greylist: delayed 1068 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 13:24:35 EST
Message-ID: <53024FAD.2000709@meduna.org>
Date: Mon, 17 Feb 2014 19:06:37 +0100
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: hjk@hansjkoch.de, gregkh@linuxfoundation.org
Subject: UIO and memory from dma_alloc_coherent - UIO_MEM_PHYS?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-02-17 19:06:42
X-Connected-IP: 95.105.163.217:27906
X-Message-Linecount: 55
X-Body-Linecount: 43
X-Message-Size: 1979
X-Body-Size: 1467
X-Received-Count: 1
X-Recipient-Count: 3
X-Local-Recipient-Count: 3
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

what is the correct way for a UIO driver to pass a memory allocated
using dma_alloc_coherent to userspace? I have googled for examples
but I was not able to find a definitive answer.

My device needs two 128 kB chunks of DMA-able memory. First I tried

  pdev->tx_vaddr = dma_zalloc_coherent(&dev->dev, pdev->dma_len,
                     &pdev->tx_paddr, GFP_KERNEL | GFP_DMA);

  info->mem[2].name = "txdma";
  info->mem[2].addr = (phys_addr_t) pdev->tx_vaddr;
  info->mem[2].size = pdev->dma_len;
  info->mem[2].memtype = UIO_MEM_LOGICAL;

This seemed to work at the first try, but tends to panic in various
ways when unmapping. It probably only maps the first page or something
like that and accessing past some limit overwrites something.

If I change this to

  info->mem[2].addr = (phys_addr_t) pdev->tx_paddr;
  info->mem[2].memtype = UIO_MEM_PHYS;

it seems to work at least on x86 with < 4GB memory. The uio_pruss.c
(or uio_dmem_genirq.c in newer kernels) do this as well.

I have a bad feeling here - if I am allocating something that
is a virtual memory in the kernel, I don't expect to pretend I am
accessing something else. The UIO howto explicitely states
that UIO_MEM_PHYS is meant for a "physical memory on your card".

Is this really a recommended way of doing this and is it portable
to other architectures?

I am using 3.4 kernel with realtime patches.

Please Cc: me when replying.

Thanks
-- 
                                         Stano
