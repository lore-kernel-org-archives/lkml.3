Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbaDBJlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:41:16 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47733 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758042AbaDBJlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:41:12 -0400
Date: Wed, 2 Apr 2014 10:40:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Bug(?) in patch "arm64: Implement coherent DMA API based on
	swiotlb" (was Re: [GIT PULL] arm64 patches for 3.15)
Message-ID: <20140402094045.GH7528@n2100.arm.linux.org.uk>
References: <20140331175230.GA7480@arm.com> <1396368657.3681.17.camel@linaro1.home> <20140401172939.GG20061@arm.com> <1396428722.3554.20.camel@linaro1.home> <20140402092032.GB31892@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402092032.GB31892@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 10:20:32AM +0100, Catalin Marinas wrote:
> You are right. I think having unaligned DMA buffers for inbound
> transfers is pointless. We can avoid losing data written by another CPU
> in the same cache line but, depending on the stage of the DMA transfer,
> it can corrupt the DMA data.
> 
> I wonder whether it's easier to define the cache_line_size() macro to
> read CWG and assume that the DMA buffers are always aligned, ignoring
> the invalidation of the unaligned boundaries. This wouldn't be much
> different from your scenario where the shared cache line is written
> (just less likely to trigger but still a bug, so I would rather notice
> this early).
> 
> The ARMv7 code has a similar issue, it performs clean&invalidate on the
> unaligned start but it doesn't move r0, so it goes into the main loop
> invalidating the same cache line again. If it was written by something
> else, the information would be lost.

You can't make that a requirement.  People have shared stuff across a
cache line for years in Linux, and people have brought it up and tried
to fix it, but there's much resistance against it.  In particular is
SCSI, which submits the sense buffer as part of a larger structure (the
host.)  SCSI sort-of guarantees that the surrounding struct members
won't be touched, but their data has to be preserved.

In any case, remember that there are strict rules about ownership of the
DMA memory vs calls to the DMA API.  It is invalid to call the DMA
streaming API functions while a DMA transfer is active.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
