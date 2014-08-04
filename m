Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaHDLJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:09:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39349 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaHDLJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:09:44 -0400
Date: Mon, 4 Aug 2014 13:09:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20140804110942.GC4808@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
 <20140728153157.GC5350@pd.tnic>
 <20140728193734.GC9752@khazad-dum.debian.net>
 <20140729104520.GF11179@pd.tnic>
 <20140729202543.GB15382@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140729202543.GB15382@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 05:25:43PM -0300, Henrique de Moraes Holschuh wrote:

> I've never seen such a tool. That said, the only reason iucode-tool
> doesn't know how to do this, is because I don't think we will ever see
> microcode with extended signature tables in the wild.

Never say never.

> However, Trying to make it possible for such a tool to work is the only
> possible explanation for what is written in the Intel SDM vol 3A page 9-30.
> It appears to be the whole point of that extra per-signature checksum inside
> the extended signature table.
> 
> The Intel SDM specifically mentions "creating a patched microcode update"
> from a microcode with extended signatures, and "removal of the extended
> signature table" on page 9-30 (last row of table 9-6).

Well, having an extended structure is for cases where you need to load
more patches, or additional patches or so. I think they're leaving this
option open for the future without having to change every microcode
loader out there.

> The only _documented_ reason why we might not want to check it is the
> split, yes.
>
> But we'd be the only ones doing that check, if we implement it.

Ok, so what do we end up doing in the end? do we split the blob we get
from Intel and if so, do we adjust total_size?

If we do split into smaller patches, then there's no need for total_size
checking, regardless of the extended signature stuff.

> > So why do we need that split again? Is Intel microcode so big so
> > that we can't keep it in a single blob, the exact same way it comes
> > from them?

You still didn't answer my question: does the iucode-tool do anything to
the microcode blob and if so, what?

Because I think it would be better if we simply load the microcode blob
we get from Intel unchanged. Like we do on AMD.

> Supposedly, we don't need to care about split microcode if we implemented
> extended signature tables correctly.  Only, there is no way at the moment
> for us to even really trust the Intel SDM to be correct, as Intel's own UEFI
> reference code (TianoCore UDK2014) does something entirely different from
> what is written in the Intel SDM...

Why do we care? The only thing we have to adhere is what we get from
Intel. I strongly assume that the blob adheres to the SDM and not to
Tiano.

> > I think you mean the microcode that's in the BIOS. There's no "hardwired"
> > microcode AFAIK.
> 
> Are you sure of that?  I've seen reports of a few older processors (some
> desktop and even some Xeons) running with revision 0 microcode (i.e. no
> updates installed) on BIOS mod sites, when the BIOS was missing a microcode
> update for that processor.  And it worked well enough for Win XP to run.
> 
> Maybe it is buggy-as-all-heck microcode, or missing half the features...

Most likely.

Regardless, your test "if (mc_header->rev == 0)" is pointless because
if the CPU loads the microcode fine, then it was meant to do so. (I'm
strongly assuming microcode release process has vetted this case). So
this test might hurt more than help.

> That one I know to be false, unfortunately. Although it usually
> happens when you add a processor model that is much newer than the
> motherboard :-)
>
> Still, while it is a non-issue in the sense that we most probably will
> never get an official microcode update from Intel with a revision of
> zero, it still exposes unconfortable boundary conditions in the driver
> code. And THAT is the reason I proposed to reject any such microcode
> updates.

See above.

> As far as I know, you're correct. We might even want to detect that
> and warn when it happens, as it is one easy to implement microcode
> downgrade attack that anyone could do.

Again, such tests are unreliable for us to deal with - in such cases
we'd leave it to the CPU itself to decide whether to allow microcode
downgrade or not.

Besides, you can remove the microcode loader and do the loading
yourself, bypassing all our checks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
