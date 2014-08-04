Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaHDUSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:18:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39378 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbaHDUSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:18:49 -0400
X-Sasl-enc: pN54ffg56KZk0mpW8gx2Fl2hp5b645m3dYiGQSKylM7n 1407183527
Date: Mon, 4 Aug 2014 17:18:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20140804201836.GA24823@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
 <20140728153157.GC5350@pd.tnic>
 <20140728193734.GC9752@khazad-dum.debian.net>
 <20140729104520.GF11179@pd.tnic>
 <20140729202543.GB15382@khazad-dum.debian.net>
 <20140804110942.GC4808@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804110942.GC4808@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Aug 2014, Borislav Petkov wrote:
> On Tue, Jul 29, 2014 at 05:25:43PM -0300, Henrique de Moraes Holschuh wrote:
> > I've never seen such a tool. That said, the only reason iucode-tool
> > doesn't know how to do this, is because I don't think we will ever see
> > microcode with extended signature tables in the wild.
> 
> Never say never.

Indeed.

Which is why I am actually bothered to fix iucode-tool to handle such
microcode without doing anything too idiotic.  Such changes will be included
in the next release (v1.1).

Still, this extended signature table is a >10-year-old design which has
never been used, and which has a number of sharp corners.  We already know
Intel won't be able to trust the implementations out there to deal with
extended signature tables correctly without a round of fixes anyway, so I
consider it just as likely that they will drop it, and maybe come up with
something better.

> > The only _documented_ reason why we might not want to check it is the
> > split, yes.
> >
> > But we'd be the only ones doing that check, if we implement it.
> 
> Ok, so what do we end up doing in the end? do we split the blob we get
> from Intel and if so, do we adjust total_size?

The kernel wouldn't need to split anything, but it could *conceivably* have
to deal with microcode that has been subject to such a process.

Which it currently would accept just fine.

I feel this is one point where we'll be more robust if we keep the current
code behavior, and ignore the total_size % 1024 restriction.

> > > So why do we need that split again? Is Intel microcode so big so
> > > that we can't keep it in a single blob, the exact same way it comes
> > > from them?
> 
> You still didn't answer my question: does the iucode-tool do anything to
> the microcode blob and if so, what?

iucode-tool will leave the microcode update as is.  It doesn't modify the
microcode header.  It doesn't modify the microcode opaque data.

And it doesn't split a microcode with extended signatures into several
microcodes with the extended signature table deleted, either.

> Because I think it would be better if we simply load the microcode blob
> we get from Intel unchanged. Like we do on AMD.

And like we currently do on Intel.  We agree on this, I don't want the
kernel microcode driver to split anything.

> > Supposedly, we don't need to care about split microcode if we implemented
> > extended signature tables correctly.  Only, there is no way at the moment
> > for us to even really trust the Intel SDM to be correct, as Intel's own UEFI
> > reference code (TianoCore UDK2014) does something entirely different from
> > what is written in the Intel SDM...
> 
> Why do we care? The only thing we have to adhere is what we get from
> Intel. I strongly assume that the blob adheres to the SDM and not to
> Tiano.

I would hope so as well, but I am a bit more sceptical than you on this.

> Regardless, your test "if (mc_header->rev == 0)" is pointless because
> if the CPU loads the microcode fine, then it was meant to do so. (I'm
> strongly assuming microcode release process has vetted this case). So
> this test might hurt more than help.

Note that we currently will never update to a revision of zero anyway: the
anti-downgrade logic and uc_header->rev being an unsigned type makes it
impossible.

This test doesn't change the current status quo much, we will just reject
the update and return an error instead skipping it silently and returning no
error.

Actually, the Intel SDM may help clear these waters a bit.  I've just read
it once more, and found this on the Intel SDM vol 3A, section 9.11.7, page
9-36:

"CPUID returns a value in a model specific register in addition to its usual
register return values. The semantics of CPUID cause it to deposit an update
ID value in the 64-bit model-specific register at address 08BH
(IA32_BIOS_SIGN_ID).  If no update is present in the processor, the value in
the MSR remains unmodified.  The BIOS must pre-load a zero into the MSR
before executing CPUID. If a read of the MSR at 8BH still returns zero after
executing CPUID, this indicates that no update is present."

Reading a revision of zero really is supposed to mean "no update is present
in the processor", and that's because it must be pre-loaded with a zero
before cpuid is called.

IMHO, this mean that one should be really paranoid over any Intel microcode
update that claims to have a revision of zero.  Intel wouldn't release such
a microcode update except in error, and we can safely assume we want nothing
to do with any such update attempts.

> > As far as I know, you're correct. We might even want to detect that
> > and warn when it happens, as it is one easy to implement microcode
> > downgrade attack that anyone could do.
> 
> Again, such tests are unreliable for us to deal with - in such cases
> we'd leave it to the CPU itself to decide whether to allow microcode
> downgrade or not.

I've implemented a rough version of it, and the "tampered revision in the
microcode header" test is actually reliable, except maybe when dealing with
an update to revision zero.  Meh.

Anyway, adding such a test to the early microcode driver requires enhancing
intel_early.c to be able to better report update errors on the BSP first
(which is useful by itself), and that part isn't done yet.

Once it is finished and tested, I will send it and we can discuss whether it
is worthwhile or not to apply it.

> Besides, you can remove the microcode loader and do the loading
> yourself, bypassing all our checks.

Yeah, well, if you have CONFIG_X86_MSR enabled, all bets are off.  Thanks
for reminding me about that one.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
