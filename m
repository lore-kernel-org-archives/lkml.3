Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaA3NL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:11:56 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:35932 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaA3NLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:11:54 -0500
Date: Thu, 30 Jan 2014 13:12:47 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Message-ID: <20140130131247.GG11329@bivouac.eciton.net>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
 <20140122112055.GF1621@mudshark.cambridge.arm.com>
 <20140129182805.GF11329@bivouac.eciton.net>
 <1391029124.2488.50.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391029124.2488.50.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 03:58:44PM -0500, Mark Salter wrote:
> > (i.e. conditionalise on whether an optional parameter was provided),
> > so my attempt of refactoring actually ends up using an additional
> > register:
> > 
> 
> Register parameters are just strings, so how about this:
> 
> 	.macro foo bar=, baz=
> 	.ifnc \bar,
> 	mov \bar,#0
> 	.endif
> 	.ifnc \baz,
> 	mov \baz,#1
> 	.endif
> 	.endm
> 
> 	foo x0
> 	foo
> 	foo x1, x2
> 	foo ,x3
> 
> Results in:
> 
> 0000000000000000 <.text>:
>    0:	d2800000 	mov	x0, #0x0                   	// #0
>    4:	d2800001 	mov	x1, #0x0                   	// #0
>    8:	d2800022 	mov	x2, #0x1                   	// #1
>    c:	d2800023 	mov	x3, #0x1                   	// #1

Oh, that's neat - thanks!

Well, given that, I can think of two less horrible options:
1)
	.macro  update_sctlr, tmp:req, set=, clear=
        mrc	p15, 0, \tmp, c1, c0, 0
	.ifnc	\set,
        orr	\tmp, \set
	.endif
	.ifnc	\clear,
	mvn	\clear, \clear
	and	\tmp, \tmp, \clear
	.endif
        mcr	p15, 0, \tmp, c1, c0, 0
	.endm

With the two call sites in uefi_phys.S as:

	ldr	r5, =(CR_M)
	update_sctlr	r12, , r5
and
	ldr	r4, =(CR_I | CR_C | CR_M)
	update_sctlr	r12, r4

Which disassembles as:

  2c:   e3a05001        mov     r5, #1
  30:   ee11cf10        mrc     15, 0, ip, cr1, cr0, {0}
  34:   e1e05005        mvn     r5, r5
  38:   e00cc005        and     ip, ip, r5
  3c:   ee01cf10        mcr     15, 0, ip, cr1, cr0, {0}
and
  48:   e59f4034        ldr     r4, [pc, #52]   ; 84 <tmpstack+0x4>
  4c:   ee11cf10        mrc     15, 0, ip, cr1, cr0, {0}
  50:   e18cc004        orr     ip, ip, r4
  54:   ee01cf10        mcr     15, 0, ip, cr1, cr0, {0}


2)
	.macro update_sctlr, tmp:req, tmp2:req, set=, clear=
	mrc	p15, 0, \tmp, c1, c0, 0
	.ifnc	\set,
	ldr	\tmp2, =\set
	orr	\tmp, \tmp, \tmp2
	.endif
	.ifnc	\clear,
	ldr	\tmp2, =\clear
	mvn	\tmp2, \tmp2
	and	\tmp, \tmp, \tmp2
	.endif
	mcr	p15, 0, \tmp, c1, c0, 0
	.endm

With the two call sites in uefi_phys.S as: 

	update_sctlr	r4, r5, , (CR_M)
and
	update_sctlr	r4, r5, (CR_I | CR_C | CR_M)

Which disassembles as:

  2c:   ee114f10        mrc     15, 0, r4, cr1, cr0, {0}
  30:   e3a05001        mov     r5, #1
  34:   e1e05005        mvn     r5, r5
  38:   e0044005        and     r4, r4, r5
  3c:   ee014f10        mcr     15, 0, r4, cr1, cr0, {0}
and
  48:   ee114f10        mrc     15, 0, r4, cr1, cr0, {0}
  4c:   e59f5030        ldr     r5, [pc, #48]   ; 84 <tmpstack+0x4>
  50:   e1844005        orr     r4, r4, r5
  54:   ee014f10        mcr     15, 0, r4, cr1, cr0, {0}


The benefit of 2) is a cleaner call site, and one fewer register
used if setting and clearing simultaneously.

The benefit of 1) is that the macro could then easily be used with
the crval mask in mm/proc*.S

So, Will, which one do you want?

/
    Leif
