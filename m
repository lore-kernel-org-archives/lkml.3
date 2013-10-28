Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3J1WCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:02:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab3J1WCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:02:32 -0400
From: Paul Moore <pmoore@redhat.com>
To: libseccomp-discuss@lists.sourceforge.net
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [libseccomp-discuss] ARM seccomp filters and EABI/OABI
Date: Mon, 28 Oct 2013 18:02:20 -0400
Message-ID: <1994117.6hW3PylSoC@sifl>
Organization: Red Hat
User-Agent: KMail/4.11.2 (Linux/3.10.13-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CALCETrWnP7DSAjqT9HMuwtUS0tumffudJTxTsU_LV_zB37f=qA@mail.gmail.com>
References: <CALCETrXyLBXmimjLepU=y1igmWpwcdWUNCqNjMHi_jyLw0pHMA@mail.gmail.com> <1393414.jBrsFW4xK5@sifl> <CALCETrWnP7DSAjqT9HMuwtUS0tumffudJTxTsU_LV_zB37f=qA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 24, 2013 02:14:15 PM Andy Lutomirski wrote:
> On Thu, Oct 24, 2013 at 12:11 PM, Paul Moore <pmoore@redhat.com> wrote:
> > On Wednesday, October 23, 2013 02:02:00 PM Andy Lutomirski wrote:
> >> I'm looking at the seccomp code, the ARM entry code, and the
> >> syscall(2) manpage, and I'm a bit lost.  (The fact that I don't really
> >> speak ARM assembly doesn't help.)
> > 
> > I suspect Kees, and perhaps Will, will be able to provide the best
> > answers, but my thoughts are below.
> > 
> >> My basic question is: what happens if an OABI syscall happens?
> > 
> > Well, libseccomp doesn't support ARM OABI and since all the new ARM stuff
> > is EABI I don't think there is much reason to worry about OABI.  I know
> > this doesn't answer your question, but perhaps this provides some
> > context.
>
> Are you sure you don't support it?

Yep, I said libseccomp doesn't support it so we don't ;)

It may build and function to some extent, but I'm making no claims for OABI 
support; if someone tries it on a OABI system they do so as their own risk.

> What actually happens if someone writes an EABI program that issues an OABI
> syscall?  (I'm hoping that the syscall nr ends up offset by 0x900000, but
> I'm not sure.)

Like you, I expect there would be a syscall mismatch but I can't say for 
certain.

> >> AFAICS, the syscall arguments for EABI are r0..r5, although their
> >> ordering is a bit odd*.
> > 
> > Hmmm, that could complicate things a bit - do you know if they are put in
> > a more "standard" order by the time they are accessed in
> > seccomp_bpf_load() via task_pt_regs()?  If not, we likely need to come up
> > with some special handling in libseccomp to account for this.
> 
> I don't think that such a think is possible.  It depends on the
> signature of the particular syscall, and I don't know if there's any
> table of these things.

Oh, that's all sorts of awesome.

Well, at least in libseccomp we do have a syscall table for each arch so it 
should be possible to track what per-syscall fixups are needed (assuming some 
augmentation of our syscall table structures) and apply them at runtime.  The 
hard part is going to be determining what fixups are needed and recording them 
in the table.

Grrrrr.

> >> I'm a bit surprised to see that both the EABI and OABI ABIs show up as
> >> AUDIT_ARCH_ARM.
> > 
> > Yeah, the usage of AUDIT_ARCH_* is not really ideal for seccomp.  There
> > are similar issues with x32; not quite as bad as with ARM, but still ...
> 
> As long as the combination of AUDIT_ARCH and nr uniquely identifies a
> syscall and its ABI, life should be good.

Ha!  Life may be good, but the code to handle it was annoying* ;)

Largely because I made the assumption (which turned out to be a bad) that an 
AUDIT_ARCH_* value uniquely identified a single ABI.  Removing that assumption 
was both annoying and painful; the code still isn't very good in dealing with 
multiple ABIs sharing a single AUDIT_ARCH_* token but it works.

-- 
paul moore
security and virtualization @ redhat

