Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3EHOfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:35:16 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:53003 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3EHOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:35:12 -0400
Date: Wed, 8 May 2013 10:35:08 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>, stefan.bader@canonical.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: WT memory type on x86_64?
Message-ID: <20130508143505.GA8599@phenom.dumpdata.com>
References: <CALCETrVBor6fKwxP=+0mtJ4SjKn2YrFczSdXhazw3m8E5Sxx6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVBor6fKwxP=+0mtJ4SjKn2YrFczSdXhazw3m8E5Sxx6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 12:33:33PM -0700, Andy Lutomirski wrote:
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
> If not, then here's a proposal:  At startup, if there are no WC or WP
> MTRRs and the CPU is new enough, then set a flag for an alternative
> PAT.  In alternative PAT mode, UC- is replaced with WT in the PAT and
> mtrr_add fails when attempting to add a WC or WP entry.  Add
> set_memory_wt, etc.  They fail in non-alternative-PAT mode.  This gets
> a bit unpleasant, since _PAGE_CACHE_UC_MINUS will have a different
> meaning depending on the mode.
> 
> A less conservative proposal would be to stop using UC- in the PAT
> entirely.  The memtype code could learn to emulate UC- when there's an
> overlapping WC or WP MTRR.
> 
> Any thoughts?  Are there known errata here?  Is there a good reason
> why the kernel needs UC-?  Will this be such a big can of worms that I
> should just hope there's an available MTRR?

Stefan Bader (CC-ed here) was looking in making a "black-box" type
code wherein for any types but WC it would lookup in the PAT index
the right bit and provide that for the page_attr_set functions.

If I recall he had run in a bit of issue with of the hard-coded values
set by the macros.

> 
> --Andy
> 
> [1]  I hope to be able to upstream all kernel code related to this
> project.  It will be neat -- I promise.  It will depend on convincing
> the people on the other end of the NDA that they should let me.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
