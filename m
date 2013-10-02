Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3JBRdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:33:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36164 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab3JBRdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:33:05 -0400
Message-ID: <524C58A3.4090704@zytor.com>
Date: Wed, 02 Oct 2013 10:32:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
References: <1379602494-26684-1-git-send-email-bp@alien8.de> <1379602494-26684-12-git-send-email-bp@alien8.de> <20130921113929.GB1587@pd.tnic> <20130922123515.GA7476@dhcp-16-126.nay.redhat.com> <20130922133722.GC28718@pd.tnic> <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com> <20130924025209.GA5561@dhcp-16-126.nay.redhat.com> <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com> <20131002100426.GB20568@pd.tnic> <524C3F38.6050507@zytor.com> <20131002170522.GA20647@pd.tnic>
In-Reply-To: <20131002170522.GA20647@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 10:05 AM, Borislav Petkov wrote:
> 
> Btw, Matt just found another issue with the bottom-up approach - due to
> different alignment of VA and PA addresses, this messes up the pagetable
> in terms of the order in which we're using 4K, 2M, etc pages.
> 
> What can happen is that, you can get a non-2M aligned PA mapped with
> 2M-aligned VA which results in a #PF with PF_RSVD set, which most likely
> happens because one or more of the bits in the [12:20] slice of the PMD
> are reserved but they get set due to the PA having address bits set in
> the aforementioned slice and thus a #PF is raised.
> 

So this is a bug in the sense that 2M pages were used when they were not
safe to use (matching alignment is part of the requirement for 2M pages
being allowable.)  However, we of course want to use 2M pages, so see below.

> So we changed the mapping method to a more straight-forward one: we map
> all EFI regions in the following range:
> 
> [ efi_va - -4G ]
> 
> and we compute efi_va by subtracting the highest EFI region address from
> -4G, i.e. 0xffff_ffff_0000_0000.
> 
> Then, each VA is computed by doing efi_va + PA.
> 
> Oh, and the alignment remains compatible this way.
> 
> So this mapping scheme - courtesy of Matt - is very straight-forward
> and simple and I like simple. This way we won't need the setup_data
> games with kexec tools as we'll be simply doing the same mappings in the
> kexec'ed kernel.
> 
> Anyway, I'll clean up the patch and send it out later.
> 

We could achieve the same thing by doing alignment after subtracting the
pointer.  HOWEVER, it also goes to show that any mapping scheme is
inherently fragile (consider if the mapping scheme above ends up
consuming too much virtual space in the future), and as a result I
really think that explicitly passing the map to the kexec kernel really
is the only sane thing to do, as otherwise we have to maintain the same
algorithm forever.

	-hpa

