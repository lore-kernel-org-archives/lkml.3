Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255AbaFCVY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:24:27 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:50205 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907AbaFCVY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:24:26 -0400
X-AuditID: cbfec37c-b7fd06d000004f49-5e-538e3d079525
Message-id: <538E3D04.9060808@samsung.com>
Date: Tue, 03 Jun 2014 15:24:20 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Eli Billauer <eli.billauer@gmail.com>, tj@kernel.org,
        Joerg Roedel <joro@8bytes.org>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        discuss@x86-64.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
In-reply-to: <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.213]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+wny67bV+wwdsr5hZLmjIs9pz5xW7x
	7+0bZov+vkWMFs2L17NZLNhvbdE5ewO7xeVdc9gszs47zmbxa/lRRgcujycH5zF53Nt3mMVj
	56y77B4LNpV6bFrVyeaxf+4ado/JN5YzenzeJOexdF0XcwBnFJdNSmpOZllqkb5dAldG9999
	rAWfxCqmLKlrYJwh1MXIySEhYCJx9MVEFghbTOLCvfVsXYxcHEICyxglnk3bwwTh9DJJvN99
	mhHC2cYoMXFHB3sXIwcHr4CWxKJ/+SDdLAKqEh0v7zKC2GwC6hKfX+9gB7GFBOQkmpasZgYp
	FxWIkHh8AWwxr4CgxI/J98AWiwhESRyb+hFsPLPAc0aJ7q0rwHqFBYIltt9ZCnVEI6PE31t7
	wTo4Bdwk5q77wgRiMwtYS6yctI0RwpaX2LzmLTPEYmWJP5dPMUG8piwx6eok1gmMIrOQLJ+F
	pH0WkvYFjMyrGMVKi5MLipPSUyuM9YoTc4tL89L1kvNzNzFCIrFmB+O9rzaHGAU4GJV4eCfc
	7A0WYk0sK67MPcQowcGsJML7WbUvWIg3JbGyKrUoP76oNCe1+BAjEwenVAOjsnv04RiOGZn/
	ki98YU8NOfSln0tHRVN9vtdh7QXLWzl/i3CJ3Th3XG2rvPbHnfcWRS04+eCKvon+Qvufmx3a
	t/1e/Vnr2dE4leOReYl330299ag+xPnXnv8bjq8/fFPo5T1BRfUf05/daD87RfVf7qPir8X9
	n9c82RV0aumyzulny3g55gt4timxFGckGmoxFxUnAgD5XXi6ogIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2014 01:01 AM, Eli Billauer wrote:
> dmam_map_single() and dmam_unmap_single() are the managed counterparts
> for the respective dma_* functions.
>
> Note that dmam_map_single() returns a status value rather than the DMA handle.
> The DMA handle is passed to the caller through a pointer in the arguments.
>
> The reason for this API change is that dmam_map_single() allocates memory,
> which may fail even if the DMA mapping is successful. On the other hand,
> it seems like there's no platform-independent value for dma_handle that can
> be used to indicate an error.
>
> This leaves dmam_map_single() with no safe way to tell its caller that the
> memory allocation has failed, except for returning a status as an int. Trying
> to keep close to the non-devres API could also tempt programmers into using
> dma_mapping_error() on the dmam_* functions. This would work incorrectly on
> platforms, for which dma_mapping_error() ignores its argument, and always
> returns success.
>

I see the value of this interface in unmap case, this type of wrapper
can release dma buffers, drivers neglected to release leaving dangling
buffers.

However, driver writers should give it some thought before switching
from conventional dma_map_*() interfaces to these proposed managed
dma mapping interfaces. These new interfaces shouldn't be treated as
drop in replacements to dma_map_*() interfaces.

The reasons are:

1. This interface adds an overhead in allocation memory for devres to
    compared to other dma_map_* wrappers. Users need to be aware of that.
    This would be okay in the cases where a driver allocates several
    buffers at init time and uses them. However, several drivers allocate
    during run-time and release as soon as it is no longer needed. This
    overhead is going to be in the performance path.

2. It adds a failure case even when dma buffers are available. i.e if
    if devres alloc fails, it will return failure even if dma map could
    have succeeded. This is a new failure case for DMA-API.

    The reason dma_map_*() routines fail now is because there are no
    buffers available. Drivers handle this error as a retry case.

    Drivers using dmam_map_single() will have to handle the failure
    cases differently.

    Since the return values are different for dmam_map_*(), that is
    plus that these interfaces can't be drop in replacements to the
    dma_map_*() interfaces.

3. Similarly, it adds an overhead in releasing memory for devres to
    compared to other dma_unmap_* wrappers. Users need to be aware of
    that. This overhead is going to be in the performance path when
    drivers unmap buffers during run-time.

Adding Joerg Roedel to the thread.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
