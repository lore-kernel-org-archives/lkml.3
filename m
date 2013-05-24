Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3EXWFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 18:05:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41952 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3EXWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 18:05:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,737,1363158000"; 
   d="scan'208";a="50632576"
Date: Fri, 24 May 2013 15:05:39 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the
 decompressor
Message-ID: <20130524220539.GB599@codeaurora.org>
References: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org>
 <5193E424.9090605@codeaurora.org>
 <519E57D2.3050000@codeaurora.org>
 <20130523231531.GT18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523231531.GT18614@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24, Russell King - ARM Linux wrote:
> On Thu, May 23, 2013 at 10:54:26AM -0700, Stephen Boyd wrote:
> > On 05/15/13 12:38, Stephen Boyd wrote:
> > > On 05/08/13 14:47, Stephen Boyd wrote:
> > >> From: Brian Swetland <swetland@google.com>
> > >>
> > >> Currently v7 CPUs with an MIDR that has no bits set in the range
> > >> [16:12] will be detected as old ARM CPUs with no caches and so
> > >> the cache will never be turned on during decompression. ARM's
> > >> Cortex chips have an 0xC in the range [16:12] so they never match
> > >> this entry, but Qualcomm's Scorpion and Krait processors never
> > >> set these bits to anything besides 0 so they always match.
> > >>
> > >> Skip this entry if we've compiled in support for v7 CPUs. This
> > >> allows kernel decompression to happen nearly instantly instead of
> > >> taking over 20 seconds.
> > >>
> > >> Signed-off-by: Brian Swetland <swetland@google.com>
> > >> [sboyd: Clarified and extended commit text]
> > >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > >> ---
> > > Ping?
> > 
> > Russell, shall I add this to the patch tracker?
> 
> Yes please.
> 

Ok, thanks.

I've noticed another problem now that our caches are used. On MSM
we have TEXT_OFFSET set to at least 0x208000 if we've built-in
support for MSM8x60/8960. If I boot a kernel with the MSM code
built-in that requires the higher text offset, but I load my
compressed kernel below that address (such as 0x0) the
decompression fails.

This happens because the page tables are written into the
compressed data region before we relocate ourself to a higher
location.

Here's some ascii art to show the problem

We start off at 0x0

 0x000000 +---------+
          |         |
          | zImage  |
 0x208000 |---------| <- r4 (zreladdr)
          | zImage  |
 0x300000 +---------+ <- _edata

Then we run far enough to call cache_on which goes ahead and
calls __setup_mmu and sets up our page tables.

 0x008000 +---------+
          |         |
          | zImage  |
          |         |
 0x204000 |---------|
          |  pgdir  |
 0x208000 |---------| <- r4 (zreladdr)
          |         |
          | zImage  |
          |         |
 0x300000 +---------+ <- _edata

This is bad because we just wrote our page tables into the
compressed data. Nobody notices though and we finish relocating
ourselves and then we call decompress_kernel() which fails
randomly. (BTW, why does error() sit in a while loop forever? We
can't get any information about why the decompression failed if
we have debug_ll enabled. I had to patch the error() routine to
not while loop forever to get that print after do_decompress to
be useful.)

I see a few solutions.

 1) Relocate with caches off and then turn on caches after we're
    running in a location where we won't overwrite ourselves.

 2) Have temporary page tables for the relocation phase that live
    just below the location we're going to relocate to.

 3) Force bootloaders loading these types of images to load the
    zImage at least as high as the TEXT_OFFSET is compiled to.

I don't think we can convince everyone that #3 is ok to do. I'm
leaning towards #2 since we get all the benefits of the cache
during the relocation phase but #1 is the obviously simple fix.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
