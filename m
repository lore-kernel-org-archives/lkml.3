Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaFGMeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 08:34:11 -0400
Received: from mxout1.netvision.net.il ([194.90.9.20]:35372 "EHLO
	mxout1.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaFGMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 08:34:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <5392F63B.6050708@gmail.com>
Date: Sat, 07 Jun 2014 14:23:39 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: shuah.kh@samsung.com
Cc: Greg KH <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>,
        devel@driverdev.osuosl.org, discuss@x86-64.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
 <538E3D04.9060808@samsung.com> <20140603233907.GB23880@8bytes.org>
 <20140604140408.GC5004@htj.dyndns.org> <20140604141211.GC23880@8bytes.org>
 <20140604141416.GD5004@htj.dyndns.org> <538F3548.4050101@gmail.com>
 <20140604212525.GE23880@8bytes.org> <5391A9C2.3040602@gmail.com>
 <20140606160103.GG15110@kroah.com> <5391EA92.9050306@gmail.com>
 <5391F438.90703@samsung.com>
In-reply-to: <5391F438.90703@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shuah,


We agree that the streaming API was originally *intended* for short 
map-unmap DMA sessions, and that dma_alloc_noncoherent() was the 
*intended* API for those who want to hold the DMA during a device's 
lifetime.

We also agree that on some platforms, DMA mappings are precious, and 
therefore any driver should unmap a region as soon as it's not needed 
anymore.

But if we stick to the citation you gave, it says "...unmapped right 
after it (unless you use dma_sync_* below)". So even in the streaming 
API's definition, there's an understanding, that the "streaming" DMA 
buffer can be held for more than a single session. And a good sync tool 
for that is made available.

Using cross-reference on Linux' code, I get a strong impression, that 
dma_alloc_NONcoherent() is pretty much unused (I counted 8 drivers). The 
streaming API's sync functions are heavily used, on the other hand. So 
one gets a hunch, that there's a lot of use of the streaming API in the 
kernel tree for long-term DMA mappings.

This wasn't the original intention -- we agree on that. But why is it 
wrong? Assuming that a driver needs to hold a DMA mapping for a long 
while, why does it matter if it was done with dma_alloc_noncoherent() or 
with dma_map_*()? They are equally wasteful, aren't they?

Why maintaining two API sets doing the same thing? Or is there a subtle 
functional difference I'm not aware of?

Thanks,
   Eli



On 06/06/14 20:02, Shuah Khan wrote:
>
> dma_map_single() and dma_unmap_single() are streaming DMA APIs. These
> are intended for one DMA transfer and unmapped right after it is done.
>
> dma buffers are limited shared resources for streaming that are
> shared by several drivers. Hence the need for use and release
> model.
>
> Please refer to the Using Streaming DMA mappings in DMA-API-HOWTO.txt
>
> "- Streaming DMA mappings which are usually mapped for one DMA
>   transfer, unmapped right after it (unless you use dma_sync_* below)
>   and for which hardware can optimize for sequential accesses.
>
>   This of "streaming" as "asynchronous" or "outside the coherency
>   domain".
>
>   Good examples of what to use streaming mappings for are:
>
>         - Networking buffers transmitted/received by a device.
>         - Filesystem buffers written/read by a SCSI device."
>
>
> If I understand your intended usage correctly, you are looking to
> allocate and hold the buffers for the lifetime of the driver. For
> such cases, dma_alloc_*() interfaces are the ones to use.
>
> Please also refer to DMA-API.txt as well. Hope this helps.
>
> -- Shuah
>
>

