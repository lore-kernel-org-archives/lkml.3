Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaBRXtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:49:06 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:61670 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaBRXtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:49:04 -0500
MIME-Version: 1.0
In-Reply-To: <20140217234644.GA5171@rmk-PC.arm.linux.org.uk>
References: <20140217234644.GA5171@rmk-PC.arm.linux.org.uk>
Date: Tue, 18 Feb 2014 15:49:03 -0800
X-Google-Sender-Auth: T4RcDrrCJy4X9sguXHbSi7s1VZM
Message-ID: <CA+55aFy7ApiQRudxPAd3v5k_apppxRnePHb1HZPH13erqhmX=g@mail.gmail.com>
Subject: Re: [GIT PULL] ARM fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, ARM SoC <arm@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 3:46 PM, Russell King <rmk@arm.linux.org.uk> wrote:
>
> One fix touches code outside of arch/arm, which is related to sorting
> out the DMA masks correctly.  There is a long standing issue with the
> conversion from PFNs to addresses where people assume that shifting an
> unsigned long left by PAGE_SHIFT results in a correct address.

You should probably have used PFN_PHYS(), which does this correctly.
Your explicit u64 isn't exactly wrong, but phys_addr_t is really the
right type for the result.

That said, it's admittedly a disgusting name, and I wonder if we
should introduce a nicer-named "pfn_to_phys()" that matches the other
"xyz_to_abc()" functions we have (including "pfn_to_virt()")

Looking at it, the Xen people then do this disgusting thing:
"__va(PFN_PHYS(pfn))" which is both ugly and pointless (__va() isn't
going to work for a phys_addr_t anyway). And <linux/mm.h> has this
gem:

  __va(PFN_PHYS(page_to_pfn(page)));

Ugh. The ugly - it burns. that really should be
"pfn_to_virt(page_to_pfn())", I think.  Adding a few mailing lists in
the hope that some sucker^Whumanitarian person would want to take a
look.

Anyway, I pulled your change to scsi_lib.c, since it's certainly no
worse than what we used to have, but James and company cc'd too.

          Linus
