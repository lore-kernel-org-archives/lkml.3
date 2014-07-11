Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaGKSbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:31:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaGKSbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:31:14 -0400
Message-ID: <1405103466.2357.5.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32
 filter
From: Eric Paris <eparis@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <aviro@redhat.com>, Will Drewry <wad@chromium.org>
Date: Fri, 11 Jul 2014 14:31:06 -0400
In-Reply-To: <13645924.XpBzvDVILV@sifl>
References: <cover.1405023592.git.rgb@redhat.com> <14055169.hesOIjNJgN@sifl>
	 <1405095813.2357.3.camel@flatline.rdu.redhat.com>
	 <13645924.XpBzvDVILV@sifl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 12:32 -0400, Paul Moore wrote:
> On Friday, July 11, 2014 12:23:33 PM Eric Paris wrote:
> > On Fri, 2014-07-11 at 12:21 -0400, Paul Moore wrote:
> > > On Friday, July 11, 2014 12:16:47 PM Eric Paris wrote:
> > > > On Fri, 2014-07-11 at 12:11 -0400, Paul Moore wrote:
> > > > > On Thursday, July 10, 2014 09:06:02 PM H. Peter Anvin wrote:
> > > > > > Incidentally: do seccomp users know that on an x86-64 system you can
> > > > > > recevie system calls from any of the x86 architectures, regardless
> > > > > > of
> > > > > > how the program is invoked?  (This is unusual, so normally denying
> > > > > > those
> > > > > > "alien" calls is the right thing to do.)
> > > > > 
> > > > > I obviously can't speak for all seccomp users, but libseccomp handles
> > > > > this
> > > > > by checking the seccomp_data->arch value at the start of the filter
> > > > > and
> > > > > killing (by default) any non-native architectures.  If you want, you
> > > > > can
> > > > > change this default behavior or add support for other architectures
> > > > > (e.g.
> > > > > create a filter that allows both x86-64 and x32 but disallows x86, or
> > > > > any
> > > > > combination of the three for that matter).
> > > > 
> > > > Maybe libseccomp does some HORRIFIC contortions under the hood, but the
> > > > interface is crap...  Since seccomp_data->arch can't distinguish between
> > > > X32 and X86_64.  If I write a seccomp filter which says
> > > > 
> > > > KILL arch != x86_64
> > > > KILL init_module
> > > > ALLOW everything else
> > > > 
> > > > I can still call init_module, I just have to use the X32 variant.
> > > > 
> > > > If libseccomp is translating:
> > > > 
> > > > KILL arch != x86_64 into:
> > > > 
> > > > KILL arch != x86_64
> > > > KILL syscall_nr >= 2000
> > > > 
> > > > That's just showing how dumb the kernel interface is...   Good for you
> > > > guys, but the kernel is just being dumb   :)
> > > 
> > > You're not going to hear me ever say that I like how the x32 ABI was done,
> > > it is a real mess from a seccomp filter point of view and we have to do
> > > some nasty stuff in libseccomp to make it all work correctly (see my
> > > comments on the libseccomp-devel list regarding my severe displeasure
> > > over x32), but what's done is done.
> > > 
> > > I think it's too late to change the x32 seccomp filter ABI.
> > 
> > So we have a security interface that is damn near impossible to get
> > right.  Perfect.
> 
> What?  Having to do two comparisons instead of one is "damn near impossible"?  
> I think that might be a bit of an overreaction don't you think?

Actually no.  How can a normal userspace application coder POSSIBLY know
this?  Find this thread on an e-mail list, by accident?  
> 
> > I think this explains exactly why I support this idea.  Make X32 look
> > like everyone else ...
> 
> You do realize that this patch set makes x32 the odd man out by having 
> syscall_get_nr() return a different syscall number than what was used to make 
> the syscall?  I don't understand how that makes "x32 look like everyone else".

Ok, I buy the __X32_SYSCALL_BIT argument.  It can be dealt with in
audit.  No problem.  We don't need to strip it in syscall_get_nr().
I'll gladly concede that part of the patch series.

But given an x86_64 kernel a seccomp filter writer has to know about X32
and how to write rules to block the X32 ABI.  And I stick with my
assessment that x32 + seccomp is darn near impossible for a normal
developer to handle.  

Heck, even chromium took months to realize that x32 was a weird beast.
And they got it wrong on their first try.  Their original implementation
didn't handle __X32_SYSCALL_BIT quite right.  Looking at their code I'm
still not sure it does the right thing.  And they are the EXPERTS.  They
wrote seccomp!

> > Honestly, how many people are using seccomp on X32 and would be horribly
> > pissed if we just fixed it?
> 
> Okay, please stop suggesting we break the x32 kernel/user interface to 
> workaround a flaw in audit.  I get that it sucks for audit, I really do, but 
> this is audit's problem.

No one is asking to break X32 to fix audit.  Audit can handle itself.  I
don't want anything in the kernel to pretend that X32 is X86_64.  It
isn't.  It has its own syscall table.  Its own syscalls.  Its own ABI.
I'm suggesting to fix how seccomp exposes X32 information because it is
a HORRIBLE interface that even the experts have gotten wrong, over and
over and over.

I suggest we accept it as breakage and just return AUDIT_ARCH_X32.
(Leaving the _X32_SYSCALL_BIT exposed as it is today)

But I'd love to hear some thoughts on how that is a bad thing.  If no
one is using the x32 seccomp abi, lets fix it.  If someone is, lets see
what the fallout from fixing it will be.

-Eric

