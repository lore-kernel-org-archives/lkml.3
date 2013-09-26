Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3IZDNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:13:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab3IZDNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:13:13 -0400
Date: Thu, 26 Sep 2013 11:12:42 +0800
From: Dave Young <dyoung@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130926031242.GA4487@dhcp-16-126.nay.redhat.com>
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

Hmm, since len is saved in efi_mapping so the previous 0 size range would
not a problem.

If we choose this approach, can we save not only the efi_mapping, but also
the fields which will be converted to virt addr, like fw_vendor, runtime,
tables? During my test on a HP workstation, the config table item (SMBIOS) also is 
converted to virt addr though spec only mention fw_vendor/runtime/tables.

--
Thanks
Dave
