Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaHAJT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:19:57 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38458 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbaHAJTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:19:54 -0400
Date: Fri, 1 Aug 2014 10:19:49 +0100
From: Matt Fleming <matt@console-pimps.org>
To: josh@joshtriplett.org
Cc: Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] efi-bgrt: Add error handling; inform the user when
 ignoring the BGRT
Message-ID: <20140801091949.GD15082@console-pimps.org>
References: <20140730192331.GA23730@jtriplet-mobl1>
 <20140731103110.GC15082@console-pimps.org>
 <20140731161133.GA12663@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731161133.GA12663@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Including akpm, the __GFP_NOWARN police)

On Thu, 31 Jul, at 09:11:33AM, Josh Triplett wrote:
> 
> I started to add an explicit limit, but any reasonable limit (large
> enough for modern screens) would be large enough that there's still a
> non-trivial possibility of allocation failure.  And I think it makes
> sense for BGRT image allocation to be non-fatal and minimally noisy
> (just a single-line error, not a scary-looking allocation warning),
> considering the highly optional and cosmetic nature of BGRT.  So, I
> believe __GFP_NOWARN makes sense.

Yes, I agree that we don't want to trigger the page allocator warning,
but I don't agree that passing __GFP_NOWARN is OK, which is why I'm
advocating some size limit checks.

We need to distinguish between "Your BGRT image size is huge, and
assumed buggy" and "Your BGRT looks valid, but we ran out of memory".

We've already got enough problems with the EFI code because we silently
paper over bugs, and using the page allocator's failure path as a way to
check for buggy BGRT images just doesn't make any sense to me at all.

If we get the limit wrong, it's not the end of the world, we can change
it later, but it's a safe bet that if the firmware engineers start
seeing "BGRT is buggy" in the kernel log they're going to start a
dialogue with us.

Original patch,

  https://lkml.org/lkml/2014/7/30/543

-- 
Matt Fleming, Intel Open Source Technology Center
