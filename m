Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095Ab3JPSnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:43:16 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:46034 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761366Ab3JPSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:43:14 -0400
MIME-Version: 1.0
In-Reply-To: <525ED75402000078000FB95B@nat28.tlf.novell.com>
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
	<CA+55aFwCe=t4dDbDhHTWhzA3zMEyyS2WSYBP2Sfe0eogGEBS1w@mail.gmail.com>
	<525ECEA102000078000FB906@nat28.tlf.novell.com>
	<CA+55aFybvU39HVUF4sON=Euieqy+Kqsby-DUU=8Gnpggm2fzjw@mail.gmail.com>
	<525ED75402000078000FB95B@nat28.tlf.novell.com>
Date: Wed, 16 Oct 2013 11:43:13 -0700
X-Google-Sender-Auth: SrXyZ8751sYj9fpbxle9qPHB0lQ
Message-ID: <CA+55aFxxOXp6Aabpvd-6PzJCH4LnE-SobOxd3TZvNVxopKDnMw@mail.gmail.com>
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data selectors
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 9:13 AM, Jan Beulich <JBeulich@suse.com> wrote:
>
> But again - this isn't being done for ordinary 64-bit applications,
> this is only happening for KVM guests. And there not being a
> protocol for telling the caller whether a certain context hold
> 64-bit offsets or selector/offset pairs shouldn't be a reason to
> think of a solution to the problem.

So having looked at this some more, I would *really* prefer a
different solution. The overwriting of the rip/rdp data just really
annoys me.

Is there any reason to not just do it like the following instead:

 - get rid of the "word_size" thing, instead just add separate
"fcs/fos" fields (that do *not* alias with rip/rdp).

 - on 64-bit, always use 64-bit ops, exactly the way we do now

 - if the resulting rip/rpd is zero in the high bits (and we have
reason to believe the values exist at all, so X86_FEATURE_NO_FPU_SEL
and the AMD test and/or checking that they aren't zero in the low bits
too), do an *additional* fnstenv to the sstack, and then just save the
resulting fcs/fos in the non-overlapping things. Use a simple helper
function for this (that just gets called after the xsave/fxsave logic)

 - same on restore.

No games. No "this is the word-size of the thing we've saved in
memory". No overlapping "this field means one thing or another".

For signal handling, save/restore the new fop/fos thing, so that
nobody ever sees the changed format, but FP state gets correctly and
fully restored over signals too, not just kernel FP stuff.

Hmm? That would make me *much* happier, I suspect.

           Linus
