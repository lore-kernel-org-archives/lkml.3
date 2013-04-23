Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3DWPiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:38:23 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:59076 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3DWPiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:38:22 -0400
Date: Tue, 23 Apr 2013 17:38:15 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Lange <thomas@corelatus.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MIPS: c17a6554 broke 64BIT_PHYS_ADDR for 32 bit systems
Message-ID: <20130423153815.GB30148@linux-mips.org>
References: <5172631E.6050305@corelatus.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5172631E.6050305@corelatus.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 11:42:54AM +0200, Thomas Lange wrote:

> commit c17a6554 unintentionally(?) modified the PAGE_MASK type
> from (int) to (long unsigned int).
> 
> This breaks ioremap (and possibly more) when using 64BIT_PHYS_ADDR on
> 32 bit systems.
> Example of failing code from ioremap.c:
> 
> 	phys_addr &= PAGE_MASK;
> 
> Since phys_addr is 64 bit (unsigned long long) when 64BIT_PHYS_ADDR and
> PAGE_MASK is 32bit (long unsigned int), the upper 32 bits will always
> be zeroed which is not what we want/expect.
> 
> The code above works if PAGE_MASK is a _signed_ 32bit int though.
> 
> Some possible fixes:
> 
> A) Simply revert the commit. Makes ioremap work again, but then PAGE_MASK
>    is a signed int. Do we really want a mask that is 'signed'?
> 
> B) Don't use PAGE_MASK for physical addresses. x86 defines this:
> 
>   /* Cast PAGE_MASK to a signed type so that it is sign-extended if
>      virtual addresses are 32-bits but physical addresses are larger
>      (ie, 32-bit PAE). */
>   #define PHYSICAL_PAGE_MASK	(((signed long)PAGE_MASK) & __PHYSICAL_MASK)
> 
>   Perhaps mips need something similar?
> 
> 
> This is an issue with 3.8 and doesn't seem to be solved in master either.

Thanks for noting this issue.  Manuel Lauss reported the same issue and
I already fixed it yesterday by reverting the offending patch.  Post rc7
reverting was the right things to do - and now that it's reverted I don't
really see the need for another patch?

Linus noticed that the revert is for an issue of which more instances might
exist and so hacked sparse to look for it, see message id

  CA+55aFy0jPr5udwJx8cZ-QFs-OgZzQ_NJm_VSj_cS7tsKUn3Kw@mail.gmail.com

on the linux-kernel mailing list or simply https://lkml.org/lkml/2013/4/22/518.

  Ralf
