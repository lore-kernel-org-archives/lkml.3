Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab3D3S4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:56:09 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:53529 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab3D3S4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9twFx2ourMTF3wD=dph1evGjr6Zs2-1HUyhin2mCMhrO8g@mail.gmail.com>
References: <CALCETrVBor6fKwxP=+0mtJ4SjKn2YrFczSdXhazw3m8E5Sxx6A@mail.gmail.com>
 <CALCETrUsRDVUBs_O5VB7LxS-nRBqOv6YQcUFvP7e=8UVoHwzhA@mail.gmail.com>
 <CAPM=9tw7YOeUZo8-2Y4SKqgBjUYdBn_Ugic+Eo2CYEri45JCmw@mail.gmail.com> <CAPM=9twFx2ourMTF3wD=dph1evGjr6Zs2-1HUyhin2mCMhrO8g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 30 Apr 2013 11:55:41 -0700
Message-ID: <CALCETrXWgF2BAnnincf9zX-XEZdJRannyyafGYcPXa5xt9jGoQ@mail.gmail.com>
Subject: Re: WT memory type on x86_64?
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 6:01 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Sat, Apr 27, 2013 at 11:00 AM, Dave Airlie <airlied@gmail.com> wrote:
>> On Sat, Apr 27, 2013 at 10:37 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Wed, Apr 24, 2013 at 12:33 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> For an upcoming (and, sadly, NDA'd [1]) project, I may need to use
>>>> write-through memory.  I'd like to gauge how unpleasant this will be.
>>>>
>>>> AFAICT, modern CPUs allow the WT type to be set using MTRR or a PAT
>>>> entry.  Sadly, MTRRs are in short supply, and the four fully-usable
>>>> PAT slots are used for UC, UC-, WB, and WC.  I can keep my fingers
>>>> crossed and hope that there are enough free MTRRs, or I could try to
>>>> free up a PAT entry.
>>>>
>>>> How nasty will the latter be?  I just looked at two rather different
>>>> modern Sandy Bridge machines, and BIOS doesn't appear to set up any
>>>> MTRRs in the WC or WP states.  As long as those MTRR types aren't
>>>> used, I think the UC- PAT entry is useless -- it behaves identically
>>>> to UC.  Lots of DRM drivers, though, seen to add a WC MTRR to cover
>>>> video memory.  Is there any need for this on modern machines?  That
>>>> is, are there any drivers that actually need the mtrr_add call to
>>>> succeed on a machine that has a working PAT?
>>>>
>>>
>>> FWIW, I've done a bit of a survey.  Things that use UC or UC- include:
>>>
>>>  - ioremap_nocache: ISTM that any correct caller wants genuine UC memory.
>>>
>>>  - plain ioremap: Are there architectures where it's not
>>> ioremap_nocache?  (Tn any case, this is irrelevant.)
>>>
>>>  - pci_iomap: This is used all over the framebuffer code.  It seems to
>>> be equivalent to ioremap or ioremap_nocache, which are the same thing
>>> on x86.
>>>
>>>  - AGP: The AGP code seems inconsistent.  alloc_page gets a cacheable
>>> page of RAM.  alloc_pages gets uncached pages of RAM.  In there's a WC
>>> MTRR on RAM, then everything is screwed up anyway.
>>>
>>>  - ttm: This code is newish.  I imagine that everything using ttm that
>>> wants WC memory asks TTM for WC, which will work just fine.  In any
>>> case, the allocations are AFAICS backed by RAM, so there should be no
>>> conflicts.
>>>
>>>  - radeon's gart: Ditto
>>>
>>>  - efi: presumably !WB means UC is fine.  (Why would EFI need WC?)
>>>
>>>  - uvesafb: The MTRR code is terrifying.  It looks nearly useless (it
>>> has alignment issues) and it's unnecessary on a system with PAT.  In
>>> any case, this code certainly isn't expecting a WC MTRR with any kind
>>> of mapping other than ioremap_wc.
>>>
>>>
>>> mtrr_add users include:
>>>
>>>  - tdfxfb, vt8623fb, sgivwfb, s3fb, etc. should be converted to use ioremap_wc
>>>  - myri10ge tries to use an MTRR.  This is, IMO, strange.
>>>  - Infiniband.  I think it's okay if the MTRR doesn't work.
>>>
>>>
>>> The only problematic (and not trivially fixable) thing I found is
>>> pci_mmap_page_range, which uses UC- and is part of the ABI -- old X
>>> drivers may care.
>>>
>>> I wonder if X (using UMS) will slow down if WC MTRRs become illegal or
>>> stop being added by old framebuffer drivers.  (If so, they can be
>>> randomly slow anyway -- lots of machines have no free MTRRs).
>>
>> Don't forget you can add mtrrs from userspace via /proc/mtrr. I'm not sure
>> what sort ABI guarantees are on this.
>>
>> TTM allocations are not necessarily backed by RAM, they can also from
>> device memory.
>>
>> Also i915 has mtrr code, but we avoid touching mtrrs if we are on a PAT cpu.
>
> i915 also has this comment:
>         /* Set up a WC MTRR for non-PAT systems.  This is more common than
>          * one would think, because the kernel disables PAT on first
>          * generation Core chips because WC PAT gets overridden by a UC
>          * MTRR if present.  Even if a UC MTRR isn't present.
>          */

I'm playing with cleaning this stuff up, and I found a possible bug.
drm_io_prot in drm_vm.c seems to hardcode the non-PAT incantation for
UC- (if I'm remembering my flags right), which is (fortunately)
equivalent to pgprot_noncached.  Shouldn't it be checking the
_DRM_WRITE_COMBINING and using pgprot_writecombine if the driver
requested write combining?

Given this, I'm not entirely clear on how non-GEM, non-TTM drivers
(i.e. drivers that use drm_addmap) end up with the correct memtypes
set.

Am I missing some reason why this code is correct?  Unfortunately, I
don't think I have any of the right hardware to test on.

--Andy
