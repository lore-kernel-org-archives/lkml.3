Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab3JKGZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:25:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab3JKGZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:25:03 -0400
Date: Fri, 11 Oct 2013 14:24:37 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131011062437.GA14115@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131010080635.GA3692@dhcp-16-126.nay.redhat.com>
 <20131010081434.GB3692@dhcp-16-126.nay.redhat.com>
 <20131010085827.GA9929@pd.tnic>
 <20131010123453.GA12321@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010123453.GA12321@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/13 at 01:34pm, Matt Fleming wrote:
> On Thu, 10 Oct, at 10:58:28AM, Borislav Petkov wrote:
> > On Thu, Oct 10, 2013 at 04:14:34PM +0800, Dave Young wrote:
> > > Even though I still have no idea why kernel text overlap with efi boot
> > > region, anyway map the un-overlapped part is necessary though.
> > >
> > > I can post the kexec related patches after your mapping patches settle
> > > down
> > 
> > Right, "settle down" being the key here.
> > 
> > Matt just mentioned on IRC that we might not need boot services mappings
> > by the time we have to start the kexec kernel, which would mean, you
> > don't have to do anything in efi_reserve_boot_services().
> 
> Dave, apologies for not discussing the whole Boot Services thing sooner.
> I missed your questions.

No problem, Thanks for clarifying the boot service issue.

> 
> We really should not be passing the EFI Boot Service regions via the
> memmap to kexec at all, because by the time the kexec'd kernel is
> running those pages that previously contained Boot Service code/data
> will have likely been reused for something else.
> 
> Which, to answer your question, is why the Boot Service regions overlap
> the kernel text in the kexec'd kernel - those regions have been
> reallocated by the first kernel and now happen to contain the kernel
> text of the kexec kernel.

Ok, then I understand passing boot service regions to 2nd kernel make no
sense.

But for current implementation from Boris, getting same mapping between
diffrent kernel depends on same md order (same start and size for each one)
How about using this mapping solution but at the same time for kexec kernel
we also pass the virtual mappings via setup_data, only thing diffrent
is we only need map the non boot region and just use the boot region size
to ensure the other regions are mapped with same virtual address. 

OTOH, if we only passing ioremapped data without Boris's current patch the
problem I worry about is how can we ensure the addresses are not used by
other code before we mapping the in 2nd kernel efi_init.

For the boot efi_reserve_boot_services code, it's mainly for the
SetVirtualAddressMap callback use, so boot regions should not be reused
before SetVirtualAddressMap, but the overlapping happens before the
efi_reserve_boot_services, isn't it a problem?

> 
> The reason that we don't keep the Boot Service regions around forever is
> because they can take up a considerable amount of memory, so the current
> situation of free'ing them after we're sure the firmware isn't going to
> reference them is still the right way to go, and simply not including
> any Boot Service entries in the memory map passed to kexec should make
> everything work OK.
> 
> > The question which needs answering first though is, how the whole efi
> > thing is going to handle any functionality like calling into efi boot
> > regions from runtime functions and such. Which hasn't really been tested
> > and fw vendors don't really want to support that. But this is all bits
> > and pieces I heard yesterday so it is all pretty wet and I'll let efi
> > guys, i.e. the Matts and a couple of others :-), figure out this whole
> > issue.
> 
> We currently treat the scenario where Runtime Services reference Boot
> Service regions as a bug and either work around it (where we do
> efi_reserve_boot_services() and efi_free_boot_services() around
> SetVirtualAddressMap()) or we avoid calling those services altogether.
> 
> The spec is pretty clear that runtime drivers shouldn't be doing this,
> and so far this approach has served us well.
> 
> There are only two reasons why we keep the Boot Services regions around
> (for a short period) at all,
> 
>   1) To work around the aforementioned runtime firmware bugs
>   2) To copy a ACPI BGRT image into kernel memory
> 
> I'm not sure whether the kexec kernel would care about the BGRT?

I have no idea about BGRT previously, it's  Boot Graphics Resource Table
so it's only for boot time use, I guess kexec can safely ignore it.

Thanks
Dave
