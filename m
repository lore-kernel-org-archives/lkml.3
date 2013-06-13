Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab3FMSa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:30:27 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:39976 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759106Ab3FMSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130613173723.GK18614@n2100.arm.linux.org.uk>
References: <1371089603-22601-1-git-send-email-ccross@android.com>
	<20130613173723.GK18614@n2100.arm.linux.org.uk>
Date: Thu, 13 Jun 2013 11:30:20 -0700
X-Google-Sender-Auth: NFbI010ej72yUPf73uS3oCdLREo
Message-ID: <CAMbhsRSmsq9-KC1i4yYO3FXoHQAcM8rVi-c5n8+Sz+FPFSL72w@mail.gmail.com>
Subject: Re: [PATCH] ARM: convert max_pfn and max_low_pfn to be relative to PFN0
From: Colin Cross <ccross@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 7:37 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jun 12, 2013 at 07:13:23PM -0700, Colin Cross wrote:
>> >From code inspection, I believe this will also improve block device
>> performance where the bounce limit was set to BLK_BOUNCE_HIGH, which
>> was bouncing unnecessarily for the top PHYS_PFN_OFFSET pages of low
>> memory.
>
> This has the potential to break platforms.  The problem is the duality
> of the dma_mask - is it a mask of the bits which the device can drive,
> or a PFN limit.  The block layer interprets it as a PFN limit, because
> of course everywhere starts their memory at physical address zero.

I've never come across a device with dma_mask set to anything but
0xFFFFFFFF, and a quick search didn't find me any good examples.
dma_mask set to the mask of bits the device can drive seems logical,
and it doesn't seem hard to fix the block layer (and the few other
users of max_pfn) to use min_low_pfn << PAGE_SHIFT + dma_mask.

> This gets into a world of pain if you have any of these conditions:
> (a) RAM not starting at physical address zero
The device I tested on has RAM at 0x40000000, which is what caused my problem.

> (b) Any translation between physical addresses and bus addresses
Is that just footbridge, integrator, and ks8695?  Those are the only
machines that define __virt_to_bus

> What we know is that the existing stuff works.  What we don't know is
> whether changing it will break anything which falls into the above
> two categories.

The existing stuff breaks a userspace API, /proc/kpagecount and
/proc/kpageflags.  It is currently impossible to read the page at
max_pfn on ARM.  It is possible to read the pages after max_pfn
because of an underflow in the kpagecount bounds check, which doesn't
cause problems because it checks pfn_valid on every pfn.  Just taking
out the bounds check against max_pfn in kpagecount and kpageflags
would also fix my problem, but it seems correct on everything but ARM.
