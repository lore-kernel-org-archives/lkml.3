Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3EHQiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:38:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57513 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3EHQiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:38:06 -0400
MIME-Version: 1.0
In-Reply-To: <518A6BF0.2060705@canonical.com>
References: <CALCETrVBor6fKwxP=+0mtJ4SjKn2YrFczSdXhazw3m8E5Sxx6A@mail.gmail.com>
 <20130508143505.GA8599@phenom.dumpdata.com> <518A6BF0.2060705@canonical.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 8 May 2013 09:37:44 -0700
Message-ID: <CALCETrXr0mGPk0XeH-pEzTEEmFm9YbGYP=BTCBLpd1zh_GQtdQ@mail.gmail.com>
Subject: Re: WT memory type on x86_64?
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 8:14 AM, Stefan Bader <stefan.bader@canonical.com> wrote:
> On 08.05.2013 16:35, Konrad Rzeszutek Wilk wrote:
>> On Wed, Apr 24, 2013 at 12:33:33PM -0700, Andy Lutomirski wrote:
>>> For an upcoming (and, sadly, NDA'd [1]) project, I may need to use
>>> write-through memory.  I'd like to gauge how unpleasant this will be.
>>>
>>> AFAICT, modern CPUs allow the WT type to be set using MTRR or a PAT
>>> entry.  Sadly, MTRRs are in short supply, and the four fully-usable
>>> PAT slots are used for UC, UC-, WB, and WC.  I can keep my fingers
>>> crossed and hope that there are enough free MTRRs, or I could try to
>>> free up a PAT entry.
>>>
>>> How nasty will the latter be?  I just looked at two rather different
>>> modern Sandy Bridge machines, and BIOS doesn't appear to set up any
>>> MTRRs in the WC or WP states.  As long as those MTRR types aren't
>>> used, I think the UC- PAT entry is useless -- it behaves identically
>>> to UC.  Lots of DRM drivers, though, seen to add a WC MTRR to cover
>>> video memory.  Is there any need for this on modern machines?  That
>>> is, are there any drivers that actually need the mtrr_add call to
>>> succeed on a machine that has a working PAT?
>>>
>>> If not, then here's a proposal:  At startup, if there are no WC or WP
>>> MTRRs and the CPU is new enough, then set a flag for an alternative
>>> PAT.  In alternative PAT mode, UC- is replaced with WT in the PAT and
>>> mtrr_add fails when attempting to add a WC or WP entry.  Add
>>> set_memory_wt, etc.  They fail in non-alternative-PAT mode.  This gets
>>> a bit unpleasant, since _PAGE_CACHE_UC_MINUS will have a different
>>> meaning depending on the mode.
>>>
>>> A less conservative proposal would be to stop using UC- in the PAT
>>> entirely.  The memtype code could learn to emulate UC- when there's an
>>> overlapping WC or WP MTRR.
>>>
>>> Any thoughts?  Are there known errata here?  Is there a good reason
>>> why the kernel needs UC-?  Will this be such a big can of worms that I
>>> should just hope there's an available MTRR?
>>
>> Stefan Bader (CC-ed here) was looking in making a "black-box" type
>> code wherein for any types but WC it would lookup in the PAT index
>> the right bit and provide that for the page_attr_set functions.
>>
>> If I recall he had run in a bit of issue with of the hard-coded values
>> set by the macros.
>
> It could be opening a can of worms. Right now there are many places / defines
> that are based on the assumption that a certain combination of PCD and PWT in
> pgprot maps to a certain cache type. PAT is deliberately left out because its
> location changes for large pages (PAT and PSE share the same bit). That is the
> reason for the PAT MSR is set in a way that results in the same cache type
> regardless of the PAT bit being 0 or 1.

Fortunately, these appear to all be either in arch/x86 or in graphics
drivers, and the latter are easy to fix.

>
> Not sure whether this is the reason but UC and UC- (as well as WB) are kept like
> the backward compatible setup. So for systems with and without PAT cache types
> map to the same. Only WT gets replaced by WC. For that whenever PCD is set it
> means some uncached type.

This also makes the pgprot_xyz macros faster -- they can do the same
thing regardless of PAT settings.

--Andy
