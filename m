Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaJGPBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:01:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37201 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbaJGPBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:01:44 -0400
Date: Tue, 7 Oct 2014 17:01:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Mathias Krause <minipli@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141007150132.GA7307@nazgul.tnic>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
 <1411313216-2641-2-git-send-email-minipli@googlemail.com>
 <20141003134707.GJ14343@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141003134707.GJ14343@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 02:47:07PM +0100, Matt Fleming wrote:
> Looks OK to me. Borislav?

It needs more work AFAICT because with it, espfix area gets cut off
prematurely:

...
[    0.134611] ---[ Vmemmap ]---
[    0.135003] 0xffffea0000000000-0xffffea0002000000          32M     RW         PSE GLB NX pmd
[    0.136743] 0xffffea0002000000-0xffffea0040000000         992M                           pmd
[    0.138091] 0xffffea0040000000-0xffffea8000000000         511G                           pud
[    0.139611] 0xffffea8000000000-0xffffff0000000000       20992G                           pgd
[    0.140610] ---[ ESPfix Area ]---
[    0.141003] 0xffffff0000000000-0xffffff8000000000         512G                           pgd
[    0.142614] 0xffffff8000000000-0xffffffef00000000         444G                           pud
[    0.144088] ---[ EFI Runtime Services ]---
[    0.144722] 0xffffffef00000000-0xfffffffec0000000          63G                           pud
[    0.146090] 0xfffffffec0000000-0xfffffffefbe00000         958M                           pmd
[    0.147613] 0xfffffffefbe00000-0xfffffffefbfe0000        1920K                           pte
[    0.149003] 0xfffffffefbfe0000-0xfffffffefc000000         128K     RW                 x  pte
[    0.150484] 0xfffffffefc000000-0xfffffffefc065000         404K                           pte
[    0.151612] 0xfffffffefc065000-0xfffffffefc200000        1644K     RW                 x  pte
[    0.153285] 0xfffffffefc200000-0xfffffffefc400000           2M     RW         PSE     x  pmd
[    0.154721] 0xfffffffefc400000-0xfffffffefc5e0000        1920K     RW                 x  pte
...

and I think we want to see something more from the espfix area (this is
what we have now):

[    0.138086] ---[ ESPfix Area ]---
[    0.138590] 0xffffff0000000000-0xffffff8000000000         512G                           pgd
[    0.140099] 0xffffff8000000000-0xfffffffec0000000         507G                           pud
[    0.141444] 0xfffffffec0000000-0xfffffffefbe00000         958M                           pmd
[    0.142597] 0xfffffffefbe00000-0xfffffffefbfe0000        1920K                           pte
[    0.144086] 0xfffffffefbfe0000-0xfffffffefc000000         128K     RW                 x  pte
[    0.145545] 0xfffffffefc000000-0xfffffffefc065000         404K                           pte
[    0.146597] 0xfffffffefc065000-0xfffffffefc200000        1644K     RW                 x  pte
[    0.148346] 0xfffffffefc200000-0xfffffffefc400000           2M     RW         PSE     x  pmd
[    0.149776] 0xfffffffefc400000-0xfffffffefc5e0000        1920K     RW                 x  pte
[    0.151347] 0xfffffffefc5e0000-0xfffffffefc631000         324K                           pte
[    0.152593] 0xfffffffefc631000-0xfffffffefc655000         144K     RW                 x  pte
[    0.154143] 0xfffffffefc655000-0xfffffffefc801000        1712K                           pte
[    0.155437] 0xfffffffefc801000-0xfffffffefc831000         192K     RW                 x  pte
[    0.157004] 0xfffffffefc831000-0xfffffffefc881000         320K                           pte
[    0.158088] 0xfffffffefc881000-0xfffffffefca01000        1536K     RW                 x  pte
[    0.159712] 0xfffffffefca01000-0xfffffffefcb34000        1228K                           pte
[    0.161117] ... 36 entries skipped ...

But yeah, this issue needs to be addressed one way or the other as the
espfix dump skips the runtime services.

And frankly, I don't see where we're setting that ->max_lines thing but
it sounds like a promising thing to use. :)

Thanks.

-- 
Regards/Gruss,
    Boris.
--
