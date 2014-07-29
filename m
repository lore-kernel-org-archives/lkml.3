Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaG2UZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:25:57 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35461 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbaG2UZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:25:56 -0400
X-Sasl-enc: UOCSTP2fKJHq3uBp83CvcglRsXc2fANHX78EFsu5MV3g 1406665554
Date: Tue, 29 Jul 2014 17:25:43 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20140729202543.GB15382@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
 <20140728153157.GC5350@pd.tnic>
 <20140728193734.GC9752@khazad-dum.debian.net>
 <20140729104520.GF11179@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729104520.GF11179@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Borislav Petkov wrote:
> > Anyway, a "total_size % 1024" test makes it impossible for an userspace tool
> > to split a microcode data file with multiple signatures into several
> > microcodes with a single signature and no extended signature table.
> 
> So on Intel a userspace tool is splitting the blob into chunks and
> correcting total_size too?

I've never seen such a tool.  That said, the only reason iucode-tool doesn't
know how to do this, is because I don't think we will ever see microcode
with extended signature tables in the wild.

However, Trying to make it possible for such a tool to work is the only
possible explanation for what is written in the Intel SDM vol 3A page 9-30.
It appears to be the whole point of that extra per-signature checksum inside
the extended signature table.

The Intel SDM specifically mentions "creating a patched microcode update"
from a microcode with extended signatures, and "removal of the extended
signature table" on page 9-30 (last row of table 9-6).

> > That kind of split seems to be the whole point of adding per-entry checksums
> > to the extended signatures (hinted at by the Intel SDM, vol3A, page 9-30,
> > last row of table 9-6).
> > 
> > It seems safer to just not test for it:
> > 
> > * FreeBSD seems to just WRMSR directly to the processor whatever crap you
> >   feed it, no checks done whatsoever.  Userspace has to do everything.
> 
> CPU wouldn't load corrupted microcode anyway, you know that.

Yeah, I do.

> > * TianoCore UDK2014 doesn't test for total_size % 1024.
> > 
> > * OpenSolaris doesn't check for total_size % 1024 either.
> > 
> > Given that mess, I'd rather we don't be the only ones that will refuse a
> > microcode that is not a multiple of 1024 bytes in size.
> 
> So is the recommendation in the just for fun?

It probably made life easier for the bizantine tools used by either Intel
itself or their BIOS partners in 1990, or something of that sort.

> And AFAICT, the only reason why we don't check it is the split, correct?

The only _documented_ reason why we might not want to check it is the split,
yes.

But we'd be the only ones doing that check, if we implement it.

> So why do we need that split again? Is Intel microcode so big so that we
> can't keep it in a single blob, the exact same way it comes from them?

Those extended tables are only useful to pack microcode in FLASH, really.
It must have been a concern in the early 2000's.

The split would remove the extended signature table, so stuff that cannot
deal with it properly can be fed a more compatible version of the microcode
container...  As long as they don't care for the total_size % 1024, that is.

Supposedly, we don't need to care about split microcode if we implemented
extended signature tables correctly.  Only, there is no way at the moment
for us to even really trust the Intel SDM to be correct, as Intel's own UEFI
reference code (TianoCore UDK2014) does something entirely different from
what is written in the Intel SDM...

> > > > +	/* check some of the metadata */
> > > > +	if (mc_header->rev == 0) { /* reserved for silicon microcode */
> > > > +		if (print_err)
> > > > +			pr_err("error! Restricted revision 0 in microcode data file\n");
> > > > +		return -EINVAL;
> > > > +	}
> > > 
> > > What is "factory-provided" microcode? What is this check supposed to
> > > accomplish?
> > 
> > Factory-provided is whatever microcode is hardwired in silicon and active
> > after processor power up/hard reset.
> 
> I think you mean the microcode that's in the BIOS. There's no "hardwired"
> microcode AFAIK.

Are you sure of that?  I've seen reports of a few older processors (some
desktop and even some Xeons) running with revision 0 microcode (i.e. no
updates installed) on BIOS mod sites, when the BIOS was missing a microcode
update for that processor.  And it worked well enough for Win XP to run.

Maybe it is buggy-as-all-heck microcode, or missing half the features...

> > The procedure to check whether a microcode update was installed is this:
> > 
> > Load MSR 0x8B (IA32_BIOS_SIGN_ID) with a zero.
> > cpuid(1)
> > Check value in MSR 0x8B (IA32_BIOS_SIGN_ID).
> > 
> > The documentation says that the contents of the IA32_BIOS_SIGN_ID MSR will
> > be changed by the cpuid instruction when a microcode update is installed in
> > the processor, and left unchanged otherwise.  If it is changed, it will be
> > set to the revision of the microcode running in the processor.
> > 
> > Since we write a zero to the MSR before the cpuid(1), we use zero to detect
> > the lack of change on the MSR.  AFAIK, we *must* do it this way:  Intel SDM
> > vol 3A, section 9.11.7.
> > 
> > The result is that we cannot detect whether a microcode with a revision of
> > zero has been installed succesfully or not.  This alone is already grounds
> > for rejecting such a microcode update IMHO.
> 
> I don't think there will ever be a valid distributed microcode with a
> revision of 0. We probably should ask someone from Intel to confirm but

I agree with you that we will never get such a microcode update from Intel.

> I think this is a non-issue: you will have some microcode revision > 0
> always loaded from the BIOS.

That one I know to be false, unfortunately.  Although it usually happens
when you add a processor model that is much newer than the motherboard :-)

Still, while it is a non-issue in the sense that we most probably will never
get an official microcode update from Intel with a revision of zero, it
still exposes unconfortable boundary conditions in the driver code.  And
THAT is the reason I proposed to reject any such microcode updates.

> And even if you manipulated the headers, I think the correct revision is
> contained in the encrypted part too so it'll come out in MSR 0x8B after
> a successful update even with a corrupted header.

As far as I know, you're correct.  We might even want to detect that and
warn when it happens, as it is one easy to implement microcode downgrade
attack that anyone could do.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
