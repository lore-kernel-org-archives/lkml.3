Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3JQHJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 03:09:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45432 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3JQHJK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Thu, 17 Oct 2013 03:09:10 -0400
Message-Id: <525FA93302000078000FBADD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 17 Oct 2013 08:09:07 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "KVM list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data
 selectors
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
 <CA+55aFwCe=t4dDbDhHTWhzA3zMEyyS2WSYBP2Sfe0eogGEBS1w@mail.gmail.com>
 <525ECEA102000078000FB906@nat28.tlf.novell.com>
 <CA+55aFybvU39HVUF4sON=Euieqy+Kqsby-DUU=8Gnpggm2fzjw@mail.gmail.com>
 <525ED75402000078000FB95B@nat28.tlf.novell.com>
 <CA+55aFxxOXp6Aabpvd-6PzJCH4LnE-SobOxd3TZvNVxopKDnMw@mail.gmail.com>
In-Reply-To: <CA+55aFxxOXp6Aabpvd-6PzJCH4LnE-SobOxd3TZvNVxopKDnMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.10.13 at 20:43, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> So having looked at this some more, I would *really* prefer a
> different solution. The overwriting of the rip/rdp data just really
> annoys me.
> 
> Is there any reason to not just do it like the following instead:
> 
>  - get rid of the "word_size" thing, instead just add separate
> "fcs/fos" fields (that do *not* alias with rip/rdp).
> 
>  - on 64-bit, always use 64-bit ops, exactly the way we do now
> 
>  - if the resulting rip/rpd is zero in the high bits (and we have
> reason to believe the values exist at all, so X86_FEATURE_NO_FPU_SEL
> and the AMD test and/or checking that they aren't zero in the low bits
> too), do an *additional* fnstenv to the sstack, and then just save the
> resulting fcs/fos in the non-overlapping things. Use a simple helper
> function for this (that just gets called after the xsave/fxsave logic)

Up to here all is doable.

>  - same on restore.

But here things break: We can't do two successive restores, as
the second one would corrupt part of what the first one did. And
you surely don't suggest to copy the whole state into another
memory block first (in order to be able to alter the overlapping
fields)?

> No games. No "this is the word-size of the thing we've saved in
> memory". No overlapping "this field means one thing or another".
> 
> For signal handling, save/restore the new fop/fos thing, so that
> nobody ever sees the changed format, but FP state gets correctly and
> fully restored over signals too, not just kernel FP stuff.
> 
> Hmm? That would make me *much* happier, I suspect.

I realize that. But please don't forget that the problem by itself
is a result of no-one having cared about the selector portions
when having designed (a) the 64-bit architecture extension and
(b) the 64-bit Linux implementation, and I am only offering the
port of a solution taken from elsewhere. And I had suggested a
first, much different solution back in 2005/2006 (when there
was no sign of KVM yet, and hence just 32-bit processes
mattered) -
http://www.x86-64.org/pipermail/discuss/2005-December/007297.html
and
http://www.x86-64.org/pipermail/discuss/2006-April/008349.html.
To me it seemed always clear that it would be only a matter of
time until this issue transitions from theoretical to real.

(And for the record I also see it as problematic that 64-bit
[F]XSAVE store offsets instead of linear addresses, which
makes these fields close to useless when using operands
through fs:/gs: overrides; that's nothing the kernel can do
anything about though. It merely stretches that the 64-bit
extensions here weren't designed well in the first place, and
software now needs to play games to cover for that.)

Jan

