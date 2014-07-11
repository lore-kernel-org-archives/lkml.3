Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbaGKTgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:36:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071AbaGKTgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:36:43 -0400
From: Paul Moore <pmoore@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <aviro@redhat.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32 filter
Date: Fri, 11 Jul 2014 15:36:40 -0400
Message-ID: <1433620.8yKm3TZIWM@sifl>
Organization: Red Hat
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1405103466.2357.5.camel@flatline.rdu.redhat.com>
References: <cover.1405023592.git.rgb@redhat.com> <13645924.XpBzvDVILV@sifl> <1405103466.2357.5.camel@flatline.rdu.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 11, 2014 02:31:06 PM Eric Paris wrote:
> On Fri, 2014-07-11 at 12:32 -0400, Paul Moore wrote:
> > On Friday, July 11, 2014 12:23:33 PM Eric Paris wrote:

...

> > > So we have a security interface that is damn near impossible to get
> > > right.  Perfect.
> > 
> > What?  Having to do two comparisons instead of one is "damn near
> > impossible"? I think that might be a bit of an overreaction don't you
> > think?
> 
> Actually no.  How can a normal userspace application coder POSSIBLY know
> this?  Find this thread on an e-mail list, by accident?

I suppose some clarification of perspective is in order.  Personally, I don't 
think a "normal" (which brings up the age old question: what is normal 
anyway?) userspace developer is going to write their own seccomp BPF filter, 
there is just too much of a barrier to entry and it is way too easy to get it 
wrong.  This is why I started the libseccomp project.

However, I think there *may* be a solution to satisfy us both, see below.

> > > I think this explains exactly why I support this idea.  Make X32 look
> > > like everyone else ...
> > 
> > You do realize that this patch set makes x32 the odd man out by having
> > syscall_get_nr() return a different syscall number than what was used to
> > make the syscall?  I don't understand how that makes "x32 look like
> > everyone else".
>
> Ok, I buy the __X32_SYSCALL_BIT argument.  It can be dealt with in
> audit.  No problem.  We don't need to strip it in syscall_get_nr().
> I'll gladly concede that part of the patch series.
> 
> But given an x86_64 kernel a seccomp filter writer has to know about X32
> and how to write rules to block the X32 ABI.  And I stick with my
> assessment that x32 + seccomp is darn near impossible for a normal
> developer to handle.

No argument here; like I said, I think seccomp BPF filters are too much for 
most folks regardless of the arch.
 
> Heck, even chromium took months to realize that x32 was a weird beast.
> And they got it wrong on their first try.  Their original implementation
> didn't handle __X32_SYSCALL_BIT quite right.  Looking at their code I'm
> still not sure it does the right thing.  And they are the EXPERTS.  They
> wrote seccomp!

I think you're helping prove my point.  Or I'm providing yours.  Or something.

However, my point about breaking userspace still stands.  Assuming the kernel 
interface is functional, regardless of warts, I stand fast in that anything 
that breaks the kernel/userspace interface is bad.  

> > > Honestly, how many people are using seccomp on X32 and would be horribly
> > > pissed if we just fixed it?
> > 
> > Okay, please stop suggesting we break the x32 kernel/user interface to
> > workaround a flaw in audit.  I get that it sucks for audit, I really do,
> > but this is audit's problem.
> 
> No one is asking to break X32 to fix audit.  Audit can handle itself.  I
> don't want anything in the kernel to pretend that X32 is X86_64.  It
> isn't.  It has its own syscall table.  Its own syscalls.  Its own ABI.
> I'm suggesting to fix how seccomp exposes X32 information because it is
> a HORRIBLE interface that even the experts have gotten wrong, over and
> over and over.

See my comments above.
 
> I suggest we accept it as breakage and just return AUDIT_ARCH_X32.
> (Leaving the _X32_SYSCALL_BIT exposed as it is today)
> 
> But I'd love to hear some thoughts on how that is a bad thing.  If no
> one is using the x32 seccomp abi, lets fix it.  If someone is, lets see
> what the fallout from fixing it will be.

This would break the seccomp filter API and any application that uses it 
properly.  I'm not excited about the idea of "let's just break the interface 
and see who notices philosophy"; that's a very bad practice IMHO.

Anyway, getting back to the idea I mentioned earlier ... as many of you may 
know, Kees (added to the CC line) is working on some seccomp filter 
improvements which will result in a new seccomp syscall.  Perhaps one way 
forward is to preserve everything as it is currently with the prctl() 
interface, but with the new seccomp() based interface we fixup x32 and use the 
new AUDIT_ARCH_X32 token?  It might result in a bit of ugliness in some of the 
kernel, but I don't think it would be too bad, and I think it would address 
both our concerns.

Thoughts?

-- 
paul moore
security and virtualization @ redhat

