Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbaLCEBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 23:01:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaLCEBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 23:01:47 -0500
Date: Wed, 3 Dec 2014 12:01:23 +0800
From: WANG Chao <chaowang@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Joerg Roedel <joro@8bytes.org>, WANG Chao <chaowang@redhat.com>
Subject: Re: [PATCH 0/3] Fix kdump failures with crashkernel=high
Message-ID: <20141203040123.GB23163@dhcp-17-37.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417174149-31210-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> here is a patch-set to fix failed kdump kernel boots when
> the systems was booted with crashkernel=X,high. On those
> systems the kernel allocates only 72MiB of low-memory for
> DMA buffers, which showed to be too low on some systems.

>From your experience It seems like swiotlb isn't working well with
crashkernel=X,high alone. What about using crashkernel=X,low with
crashkernel=X,high? Is there any reason you have to use
crashkernel=X,high alone?

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

crashkernel=X,high shouldn't automatically reserve 72M low at the first
place. Now it's going insane if you increase it to 256M by default.

Thanks
WANG Chao

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
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
