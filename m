Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbbAFQyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:54:22 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbbAFQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:54:20 -0500
Date: Tue, 6 Jan 2015 08:54:17 -0800
From: Darren Hart <dvhart@infradead.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Message-ID: <20150106165417.GB27956@vmdeb7>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
 <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie>
 <20150106073634.GB59754@vmdeb7>
 <54ABE67B.1070706@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ABE67B.1070706@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 01:43:23PM +0000, Bryan O'Donoghue wrote:
> On 06/01/15 07:36, Darren Hart wrote:
> 
> >>Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
> >
> >Since you have Intel (C) below and then your own, are you the sole author?
> 
> Yes, for the platform code.
> 
> Platform code tears-down IMRs and sets-up up a new one around the kernel.
> Quark BSP does a similar thing in a different place.
> 
> To be safe I'm happy to add a Intel (C) to this file anyway.

I was just checking if we needed to credit another individual with code
authorship.

...

> >>+#define IMR_SHIFT	8
> >>+#define imr_to_phys(x)	(x << IMR_SHIFT)
> >>+#define phys_to_imr(x)	(x >> IMR_SHIFT)
> >>+
> >>+/**
> >>+ * imr_enabled
> >>+ * Determines if an IMR is enabled based on address range
> >>+ *
> >>+ * @imr:	Pointer to IMR descriptor
> >>+ * @return	true if IMR enabled false if disabled
> >>+ */
> >>+static int imr_enabled(struct imr *imr)
> >>+{
> >>+	return (imr_to_phys(imr->addr_lo) && imr_to_phys(imr->addr_hi));
> >
> >What are testing here? You have bit 30 marked as "Enabled" above (but it isn't
> >in the datasheet). With Reserved bits in each register, this test for non-zero
> >doesn't seem robust.
> 
> Good question.
> 
> Bit 30 is not present in X1000 silicon, though is present in the BSP code.
> Lets forget about all non-X1000 cases for now since X1000 is the only
> processor currently available.
> 
> On X1000 the only means of determining if an IMR is enabled is if it's
> address bits are set to some address everybody agrees means 'off', since the
> enable bit doesn't exist. Everybody in this case is ROM, BIOS, 2nd stage
> bootloader and kernel.
> 

OK, that's non-obvious, so let's add a comment.

> In the BSP code, that address is zero. So in lieu of bit 30 'enable' we have
> address 0x00000000.
> 
> The kernel could define an alternative address to 0x00000000 but, then this
> would break with the convention in BIOS etc.
> 
> Since BIOS and grub code both use 0x00000000 as the 'off' address I think it
> makes sense for the kernel to continue to use that address.

So, both lo and hi don't need to be non-zero then, either one being non-zero
would constitute "enabled"? Should the above test be an || then?

> 
> >>+	/* Error out if we have an overlap or no free IMR entries */
> >
> >According to the datasheet, overlapping ranges are valid, and access must be
> >granted by all IMRs associated with a given address. Why declare an overlap as
> >invalid here?
> 
> Simplicity.
> 
> It's more straight forward to define your IMR memory map if you don't allow
> the address ranges to stomp all over each other.
> 
> None of the BSP reference code does overlap.
> 
> If there's an argument for an overlap use-case it can be supported pretty
> simply by simply removing the overlap checks.
> 
> My own view is that it's not really desirable and easier to debug IMRs
> generally on a platform if overlaps aren't allowed.
> 

OK, let's add a comment to that effect.

-- 
Darren Hart
Intel Open Source Technology Center
