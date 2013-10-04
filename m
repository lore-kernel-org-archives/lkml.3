Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3JDJmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:42:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44436 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3JDJmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:42:50 -0400
Date: Fri, 4 Oct 2013 11:42:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20131004094247.GA6796@nazgul.tnic>
References: <20130922133722.GC28718@pd.tnic>
 <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com>
 <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
 <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
 <20131002100426.GB20568@pd.tnic>
 <524C3F38.6050507@zytor.com>
 <20131002170522.GA20647@pd.tnic>
 <524C58A3.4090704@zytor.com>
 <20131002184229.GE20568@pd.tnic>
 <524C6A14.40905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <524C6A14.40905@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 11:46:44AM -0700, H. Peter Anvin wrote:
> It's pretty straightforward - just drop the starting address to proper
> alignment after you subtract the size.

Ok, just an observation - it is not necessarily a bad thing but I
thought we should talk about it:

So, when we do the VA space saving mapping, we're basically mapping huge
physical ranges onto a much smaller VA range and adding other mappings
in there pots-factum could turn out to be not straight-forward and
problematic.

To illustrate what I'm trying to say, here's an example from two regions
in OVMF:

[    0.011005] __map_region: VA: 0xfffffffeff800000..0xffffffff00000000 -> PA: 0x800000.. 0x1000000
[    0.017005] __map_region: VA: 0xfffffffeff600000..0xfffffffeff620000 -> PA: 0x7c000000.. 0x7c020000

Now, the physical address range spanned by those regions is:

0x7c020000 - 0x800000 = 0x7b820000 =~ 2G

while the virtual is

0xffffffff00000000 - 0xfffffffeff600000 = 0xa00000 =~ 10M

Now, we obviously cannot map the whole PA space in there, the question
is: do we care?

I mean, we can map it to other VA range but this will totally destroy
the simple math of computing EFI VA addresses with an offset, similar to
PAGE_OFFSET.

OTOH, if we keep Matt's suggestion of mapping the whole EFI address
space window, we don't have that issue. And we've reserved 64G for
EFI and if it needs more, we probably can give it since we're using a
different pagetable anyway.

Opinions?

Thanks.
