Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3DFFSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:18:13 -0400
Received: from ozlabs.org ([203.10.76.45]:50775 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3DFFSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:18:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>, linux-kernel@vger.kernel.org,
        Philip Kranz <philip.kranz@googlemail.com>,
        i4passt@lists.informatik.uni-erlangen.de, linux-parisc@vger.kernel.org,
        <corbet@lwn.net> (Jonathan Corbet)
Subject: Re: [PATCH] Add non-zero module sections to sysfs
In-Reply-To: <1365156435.1970.31.camel@dabdike>
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de> <87vc81lj7x.fsf@rustcorp.com.au> <1365156435.1970.31.camel@dabdike>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sat, 06 Apr 2013 15:22:05 +1030
Message-ID: <87wqsgjm6i.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> On Fri, 2013-04-05 at 14:30 +1030, Rusty Russell wrote:
>> Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
>> > On 04/04/13 03:00, Rusty Russell wrote:
>> >> Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
>> >>> Add non-zero module sections to sysfs on architectures unequal to PARISC.
>> >>> KGDB needs all module sections for proper module debugging. Therefore, commit 
>> >>> 35dead4235e2b67da7275b4122fed37099c2f462 is revoked except for PARISC
>> >>> architecture.
>
> Thanks for actually cc'ing us.
>
>> >> #ifdef CONFIG_PARISC in the middle of kernel/module.c is super-ugly, and
>> >> wrong.
>> >
>> > I don't see why this is wrong. It used to load all sections to sysfs
>> > until the patch mentioned. Actually, it is the PARISC build chain which
>> > is broken.
>> 
>> Exactly.  Don't workaround it here, revert it and put the
>> duplicate-section-name fixup in parisc where it belongs.
>> 
>> Assuming parisc still produces these dup sections: that patch is 4 years
>> old now.
>
> Just so you know: this isn't a parisc specific problem.  Gcc produces
> duplicate section names under various circumstances, but the one that
> bites us is -ffunction-sections.

*This* is a PA-RISC specific issue.  -ffunction-sections is a different
problem, which this hack wouldn't help.

> Note that there are proposals to use
> -ffunction-sections on all architectures (so we can garbage collect
> unused functions) in which case you'll induce the bug identified in
> 35dead4235e2b67da7275b4122fed37099c2f462 on every architecture

Good point, though I note that we seem to have stalled on
-ffunction-sections.  (And I vaguely recall an issue with
-ffunction-sections and using ld -o which would fold duplicate named
sections back together reducing elimination opportunities).

> The problem is our assumption that section names be unique.  This
> assumption is wrong.  The ELF spec says (version 1.1 page 1-15): "An
> object file may have more than one section with the same name."  We need
> to fix the kernel not to rely on a bogus assumption ... but we had no
> idea how to do that in a way that preserved the backwards compatibility
> of sections subdirectory.
>
> I admit that 35dead4235e2b67da7275b4122fed37099c2f462 is a hack, but now
> the problem has got attention, can we fix it properly?

Yep.  The original patch didn't go through me, or we would have had this
discussion back then...

The use of section names in sysfs goes back to one Mr. Corbet.  Why did
he do it that way?  Because gdb's add-symbol-file makes the same
assumption.  So if we fixed the sysfs somehow, it still wouldn't be
useful, since there's no way to tell gdb :(

The real answer don't use -ffunction-sections on modules: probably not
as important as the rest of the kernel.  And the new shiny is
-flto anyway.

And that leaves us with a PA-RISC specific issue, for which we should
move the fix to PA-RISC.

Thoughts?
Rusty.
