Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422990Ab3FUHYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:24:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56433 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422821Ab3FUHYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:24:08 -0400
Date: Fri, 21 Jun 2013 09:23:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130621072356.GA22006@pd.tnic>
References: <1371746775.2372.11.camel@dabdike>
 <20130620165426.GB26214@srcf.ucam.org>
 <20130620170124.GA19877@pd.tnic>
 <20130620171210.GA26593@srcf.ucam.org>
 <20130620180808.GB19877@pd.tnic>
 <20130620181015.GA27833@srcf.ucam.org>
 <20130620181445.GA791@pd.tnic>
 <20130620181731.GA27960@srcf.ucam.org>
 <20130620184736.GC19877@pd.tnic>
 <51C383AC.4060706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51C383AC.4060706@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 03:35:24PM -0700, H. Peter Anvin wrote:
> On 06/20/2013 11:47 AM, Borislav Petkov wrote:
> > 
> > I guess we can do a top-down allocation, starting from the highest
> > virtual addresses:
> > 
> > EFI_HIGHEST_ADDRESS
> > |
> > | size1
> > |
> > --> region1
> > |
> > | size2
> > |
> > --> region2
> > 
> > ...
> > 
> > and we make EFI_HIGHEST_ADDRESS be the same absolute number on every
> > system.
> > 
> > hpa, is this close to what you had in mind? It would be prudent to
> > verify whether this will suit well with the kexec virtual space layout
> > though...
> > 
> 
> This would work really well, I think.  The tricky part here is to pick a
> safe EFI_HIGHEST_ADDRESS as it is an ABI.
> 
> My preference would be to make EFI_HIGHEST_ADDRESS = -4 GB, which is
> *not* what Windows uses, but will leave the high negative range clear,
> and allows a range where we can grow down without much risk of
> interfering with anything else.

Hmm, cool. Let me see whether my primitive math still has it:

-(4 << 30) = 0xffffffff00000000.

Staring at Documentation/x86/x86_64/mm.txt, that's right in the unused
hole, sandwiched between:

ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)

xxxxxxxxxxxxxxxx - ffffffff00000000 (=XX bits, not a lot :-), maybe 4, i.e. 64G) EFI

ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0

Now, if we go and do that, what are we going to say for the lower bound,
in case later someone wants to use some more of the rest of the unused
hole? Should we limit it to say

0xffffffff00000000 -
0xfffffff000000000 = 64G max EFI mappable region.

Or am I too generous? The remaining hole is around

(0xfffffff000000000 - 0xffffeaffffffffff) >> 40 = 20TB.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
