Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3IYCgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 22:36:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab3IYCgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 22:36:36 -0400
Date: Wed, 25 Sep 2013 10:36:15 +0800
From: Dave Young <dyoung@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130925023615.GB7434@dhcp-16-126.nay.redhat.com>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
 <52422A6A.8080305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52422A6A.8080305@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/13 at 05:12pm, H. Peter Anvin wrote:
> On 09/24/2013 07:56 AM, Borislav Petkov wrote:
> > On Tue, September 24, 2013 2:45 pm, Dave Young wrote:
> >> Think again about this, how about 1:1 map them from a base address
> >> like -64G phy_addr -> (-64G + phy_addr), in this way we can avoid
> >> depending on the previous region size.
> > 
> > Right, how we layout the regions is arbitrary as long as we start at
> > the same VA and use the same regions, in the same order and of the same
> > size...
> > 
> >> For the zero region problem, we can resolve it as a standalone
> >> problem.
> > 
> > ... however, we still need to understand why it fails mapping the boot
> > services region as some implementations apparently do call boot services
> > even after ExitBootServices(). IOW, we need that region mapped in the
> > kexec'ed kernel too.
> > 
> 
> I am starting to think that we really should explicitly pass along the
> EFI mappings to the secondary kernel.  This will also help if we have to
> change the algorithm in a future kernel.

The 0 size mem region is still a problem even we pass the previous mapping
to 2nd kernel. So will be be enough to 1:1 map on high address and leave the
firmware provided memmap not touched, use a copy of memmap in kernel?

> 
> The most logical way to do this is to define a new setup_data type and
> pass the entire set of physical-to-virtual mappings that way.
> 
> For example:
> 
> struct efi_mapping {
> 	u64 va;			/* Virtual start address */
> 	u64 pa;			/* Physical start address */
> 	u64 len;		/* Length in bytes */
> 	u64 type;		/* Mapping type */
> 	u64 reserved[3];	/* Reserved, must be zero */
> };
> 
> Adding some reserved fields seems like a prudent precaution; the map
> shouldn't be all that large anyway.
> 
> 	-hpa
> 
