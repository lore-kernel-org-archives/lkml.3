Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaBUNUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:20:55 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45719 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756023AbaBUNUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:20:51 -0500
Date: Fri, 21 Feb 2014 13:20:24 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Kees Cook <keescook@chromium.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Larry Bassel <lbassel@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nicolas Pitre <nico@linaro.org>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Jiang Liu <liuj97@gmail.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Laura Abbott <lauraa@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Simon Baatz <gmbnomis@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ARM: mm: keep rodata non-executable
Message-ID: <20140221132024.GD21483@n2100.arm.linux.org.uk>
References: <1392339850-18686-1-git-send-email-keescook@chromium.org> <1392339850-18686-3-git-send-email-keescook@chromium.org> <20140214162257.GB2331@e103592.cambridge.arm.com> <CAGXu5jLmYLQpu9CDhoL-2OTdwxqrfVCFbojmpjpcpLqmA=wWYA@mail.gmail.com> <20140217123415.GA2182@e103592.cambridge.arm.com> <CAGXu5j+s70cNVVGf_T4=MqJ0TeYOFAyfWNUozWvHJ4-BvX-yKg@mail.gmail.com> <20140221123645.GA2578@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221123645.GA2578@e103592.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:37:04PM +0000, Dave Martin wrote:
> It would be good if someone who's more familiar with the parms and
> vmlinux.lds stuff could take a look at it, though I don't see any
> obvious problem yet.

The biggest issue with it is that we end up with:

- the .text section rounded up to 1MB
- the .rodata section rounded up to 1MB

That means we can end up wasting up to 1MB of memory for each (in the
worst case where we encroach into the next 1MB aligned region by a few
bytes) and this memory can't be re-used.

The alternative is to adjust the maps such that we end up mapping the
.text / .rodata overlap 1MB using 4K pages, taking the additional TLB
hit by doing so.

The .text is aligned to 1MB, so the majority of the first 0x8000 to
0x100000 is unused.  The end of the .text section is aligned to 1MB,
and the start of the .data section is also aligned to 1MB.

So, the minimum kernel size is: 0x100000 + MB_ALIGN(sizeof(.text)) +
MB_ALIGN(sizeof(.rodata)) + MB_ALIGN(sizeof(init sections)) + sizeof(.data)
- 0x8000

So, looking at this kernel I've recently built:

Idx Name          Size      VMA       LMA       File off  Algn
  0 .head.text    00000204  c0008000  c0008000  00008000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE

--- .text this gets set to 0xc0100000, we lose 0xc0008240 to 0xc0100000

  1 .text         006c4530  c0008240  c0008240  00008240  2**6
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .text.head    0000004c  c06cc770  c06cc770  006cc770  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE

--- sizeof(.text) + sizeof(.text.head) becomes 0x700000
--- .rodata starts at 0xc0800000 instead of 0xc06cd000

  3 .rodata       0022f568  c06cd000  c06cd000  006cd000  2**6
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 __bug_table   0000873c  c08fc568  c08fc568  008fc568  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  5 .pci_fixup    00000030  c0904ca4  c0904ca4  00904ca4  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  6 __ksymtab     00008158  c0904cd4  c0904cd4  00904cd4  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  7 __ksymtab_gpl 00006858  c090ce2c  c090ce2c  0090ce2c  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  8 __kcrctab     000040ac  c0913684  c0913684  00913684  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  9 __kcrctab_gpl 0000342c  c0917730  c0917730  00917730  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 10 __ksymtab_strings 00022a08  c091ab5c  c091ab5c  0091ab5c  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 11 __param       00000c70  c093d564  c093d564  0093d564  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 12 __modver      00000e2c  c093e1d4  c093e1d4  0093e1d4  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 13 __ex_table    00000f18  c093f000  c093f000  0093f000  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 14 .notes        00000024  c093ff18  c093ff18  0093ff18  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 15 .vectors      00000020  00000000  c0940000  00940000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 16 .stubs        00000240  00001000  c0940020  00941000  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 17 .init.text    00051760  c0940260  c0940260  00948260  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 18 .exit.text    00002130  c09919c0  c09919c0  009999c0  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 19 .init.arch.info 00000108  c0993af0  c0993af0  0099baf0  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 20 .init.tagtable 00000048  c0993bf8  c0993bf8  0099bbf8  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 21 .init.smpalt  000032f8  c0993c40  c0993c40  0099bc40  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 22 .init.pv_table 00000314  c0996f38  c0996f38  0099ef38  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 23 .init.data    0000c19c  c0997250  c0997250  0099f250  2**3
                  CONTENTS, ALLOC, LOAD, DATA
 24 .data..percpu 000035c0  c09a4000  c09a4000  009ac000  2**6
                  CONTENTS, ALLOC, LOAD, DATA

--- sizeof previous sections is 0x2db000, which becomes 0x300000
--- start of .data becomes 0xc0b00000 instead of 0xc09a8000

 25 .data         00062728  c09a8000  c09a8000  009b0000  2**6
                  CONTENTS, ALLOC, LOAD, DATA
 26 .bss          00754870  c0a0a740  c0a0a740  00a12728  2**6
                  ALLOC

--- which means the kernel image finishes at 0xC12B6FB0 whereas it used
    to finish at 0xC115EFB0.

 27 .comment      00000011  00000000  00000000  00a12728  2**0
                  CONTENTS, READONLY
 28 .ARM.attributes 00000010  00000000  00000000  00a12739  2**0
                  CONTENTS, READONLY

That's almost 1.5MB larger on an image size of 18MB.  Percentage wise,
that sounds small, but the thing to realise is that growth is independent
of the image size, so a smaller image sees a larger %age wise growth in
its size.

People have already complained bitterly when I've said that stealing
memory and taking out out of memblock should always be 1MB aligned, so
/no one/ has the right to say "it's only 1.5MB, it doesn't matter"
because quite frankly they should've been saying that and supporting me
with the memblock issue.  So, I really don't want to hear that argument!

However, if you look at where these boundaries are placed, they're not
quite in the right place.  For example, the .init.data section is writable,
and so should be grouped with the .data section.  So should .data..percpu.

Now, a few other things stand out from the above:

(a) .text.head - imx, sunxi and tegra need to fix that.  There is no
    specific meaning to it.

(b) .init.text is executable, and can't be in a NX region when it's
    set as non-executable.

(c) we can't free the .init sections (sections 15 through up to and
    including 23) anymore with this feature enabled because it's setup
    as read-only memory.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
