Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355AbaFCXjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:39:15 -0400
Received: from 8bytes.org ([85.214.48.195]:49100 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932907AbaFCXjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:39:12 -0400
Date: Wed, 4 Jun 2014 01:39:07 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Eli Billauer <eli.billauer@gmail.com>, tj@kernel.org,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        discuss@x86-64.org
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
Message-ID: <20140603233907.GB23880@8bytes.org>
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
 <538E3D04.9060808@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538E3D04.9060808@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jun  4 01:39:09 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 538e5c9d20861477113474
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:24:20PM -0600, Shuah Khan wrote:
> On 06/01/2014 01:01 AM, Eli Billauer wrote:
> I see the value of this interface in unmap case, this type of wrapper
> can release dma buffers, drivers neglected to release leaving dangling
> buffers.
> 
> However, driver writers should give it some thought before switching
> from conventional dma_map_*() interfaces to these proposed managed
> dma mapping interfaces. These new interfaces shouldn't be treated as
> drop in replacements to dma_map_*() interfaces.
> 
> The reasons are:
> 
> 1. This interface adds an overhead in allocation memory for devres to
>    compared to other dma_map_* wrappers. Users need to be aware of that.
>    This would be okay in the cases where a driver allocates several
>    buffers at init time and uses them. However, several drivers allocate
>    during run-time and release as soon as it is no longer needed. This
>    overhead is going to be in the performance path.
> 
> 2. It adds a failure case even when dma buffers are available. i.e if
>    if devres alloc fails, it will return failure even if dma map could
>    have succeeded. This is a new failure case for DMA-API.
> 
>    The reason dma_map_*() routines fail now is because there are no
>    buffers available. Drivers handle this error as a retry case.
> 
>    Drivers using dmam_map_single() will have to handle the failure
>    cases differently.
> 
>    Since the return values are different for dmam_map_*(), that is
>    plus that these interfaces can't be drop in replacements to the
>    dma_map_*() interfaces.
> 
> 3. Similarly, it adds an overhead in releasing memory for devres to
>    compared to other dma_unmap_* wrappers. Users need to be aware of
>    that. This overhead is going to be in the performance path when
>    drivers unmap buffers during run-time.

I fully agree with the points Shuah brought up here. I don't think it is
a good idea to add this kind of resource management to runtime-allocated
(and de-allocated) resources of device drivers.

Also DMA handles are not something that could be garbage collected at
driver unload time. They are a limited resource that may be used up at
some point. And the whole point of a devm-API is that code can be
simpler because we don't need to de-allocate everything on the
error-path or at unload time, no?

Besides that, we already have DMA-API debug to find drivers that do not
release all their DMA buffers.


	Joerg


