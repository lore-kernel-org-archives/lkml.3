Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3D0Ahn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 20:37:43 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:33984 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3D0Ahl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 20:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVBor6fKwxP=+0mtJ4SjKn2YrFczSdXhazw3m8E5Sxx6A@mail.gmail.com>
References: <CALCETrVBor6fKwxP=+0mtJ4SjKn2YrFczSdXhazw3m8E5Sxx6A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 26 Apr 2013 17:37:19 -0700
Message-ID: <CALCETrUsRDVUBs_O5VB7LxS-nRBqOv6YQcUFvP7e=8UVoHwzhA@mail.gmail.com>
Subject: Re: WT memory type on x86_64?
To: linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 12:33 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> For an upcoming (and, sadly, NDA'd [1]) project, I may need to use
> write-through memory.  I'd like to gauge how unpleasant this will be.
>
> AFAICT, modern CPUs allow the WT type to be set using MTRR or a PAT
> entry.  Sadly, MTRRs are in short supply, and the four fully-usable
> PAT slots are used for UC, UC-, WB, and WC.  I can keep my fingers
> crossed and hope that there are enough free MTRRs, or I could try to
> free up a PAT entry.
>
> How nasty will the latter be?  I just looked at two rather different
> modern Sandy Bridge machines, and BIOS doesn't appear to set up any
> MTRRs in the WC or WP states.  As long as those MTRR types aren't
> used, I think the UC- PAT entry is useless -- it behaves identically
> to UC.  Lots of DRM drivers, though, seen to add a WC MTRR to cover
> video memory.  Is there any need for this on modern machines?  That
> is, are there any drivers that actually need the mtrr_add call to
> succeed on a machine that has a working PAT?
>

FWIW, I've done a bit of a survey.  Things that use UC or UC- include:

 - ioremap_nocache: ISTM that any correct caller wants genuine UC memory.

 - plain ioremap: Are there architectures where it's not
ioremap_nocache?  (Tn any case, this is irrelevant.)

 - pci_iomap: This is used all over the framebuffer code.  It seems to
be equivalent to ioremap or ioremap_nocache, which are the same thing
on x86.

 - AGP: The AGP code seems inconsistent.  alloc_page gets a cacheable
page of RAM.  alloc_pages gets uncached pages of RAM.  In there's a WC
MTRR on RAM, then everything is screwed up anyway.

 - ttm: This code is newish.  I imagine that everything using ttm that
wants WC memory asks TTM for WC, which will work just fine.  In any
case, the allocations are AFAICS backed by RAM, so there should be no
conflicts.

 - radeon's gart: Ditto

 - efi: presumably !WB means UC is fine.  (Why would EFI need WC?)

 - uvesafb: The MTRR code is terrifying.  It looks nearly useless (it
has alignment issues) and it's unnecessary on a system with PAT.  In
any case, this code certainly isn't expecting a WC MTRR with any kind
of mapping other than ioremap_wc.


mtrr_add users include:

 - tdfxfb, vt8623fb, sgivwfb, s3fb, etc. should be converted to use ioremap_wc
 - myri10ge tries to use an MTRR.  This is, IMO, strange.
 - Infiniband.  I think it's okay if the MTRR doesn't work.


The only problematic (and not trivially fixable) thing I found is
pci_mmap_page_range, which uses UC- and is part of the ABI -- old X
drivers may care.

I wonder if X (using UMS) will slow down if WC MTRRs become illegal or
stop being added by old framebuffer drivers.  (If so, they can be
randomly slow anyway -- lots of machines have no free MTRRs).

--Andy
