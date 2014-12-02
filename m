Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaLBLcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:32:18 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34813 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaLBLcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:32:17 -0500
Message-ID: <547DA2C1.30902@gmail.com>
Date: Tue, 02 Dec 2014 19:30:09 +0800
From: Baoquan He <baoquan.he@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 0/3] Fix kdump failures with crashkernel=high
References: <1417174149-31210-1-git-send-email-joro@8bytes.org>
In-Reply-To: <1417174149-31210-1-git-send-email-joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2014 07:29 PM, Joerg Roedel wrote:
> Hi,
> 
> here is a patch-set to fix failed kdump kernel boots when
> the systems was booted with crashkernel=X,high. On those
> systems the kernel allocates only 72MiB of low-memory for
> DMA buffers, which showed to be too low on some systems.
> 
> The problem is that 64MiB of the low-memory is allocated by
> swiotlb, leaving 8MB for the page-allocator. But swiotlb
> tries to allocate DMA memory from the page-allocator first,
> which fails pretty fast in the boot sequence, causing
> warnings. This patch-set removes these warnings.
> 
> But even the 64MiB for swiotlb are eaten up on some systems,
> so that the default of low-memory allocated for the
> crash-kernel is increase from 72MB to 256MB (only changing
> the defaults, can still be overwritten by crashkernel=X,low).

Hi Joerg,

The default low memory is calculated in swiotlb_size_or_default(), and
this relies on IO_TLB_DEFAULT_SIZE which is default value for swiotlb.
If this doesn't work for your case in kdump kernel, does the default
value IO_TLB_DEFAULT_SIZE work for swiotlb in 1st kenrel? If not, user
knows it and should know it will fail for kdump kernel either with
default vaule, user can specify that by crashkernel=x,low which is why
it's introduced.

It may not be a good idea to increase the default low value from 72M to
256M. After all the case you are encountering is a special case, special
case need be treated specially, namely specify it in crashkernel=x,low
clearly.


Thanks
Baoquan


> 
> This number comes from experiments on the affected systems,
> 128MiB low-memory was still not enough there, thus I set the
> value to 256MiB to fix the issues.
> 
> Any feedback appreciated.
> 
> Thanks,
> 
> 	Joerg
> 
> Joerg Roedel (3):
>   swiotlb: Warn on allocation failure in swiotlb_alloc_coherent
>   x86, swiotlb: Try coherent allocations with __GFP_NOWARN
>   x86, crash: Allocate enough low-mem when crashkernel=high
> 
>  arch/x86/kernel/pci-swiotlb.c |  8 ++++++++
>  arch/x86/kernel/setup.c       |  5 ++++-
>  lib/swiotlb.c                 | 11 +++++++++--
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 

