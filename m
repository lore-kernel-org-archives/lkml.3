Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbbARRWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 12:22:25 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42077 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbbARRWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 12:22:23 -0500
Message-Id: <1421601742.2738022.215400221.24202740@webmail.messagingengine.com>
X-Sasl-Enc: JVKK/l0Sh4Lbsa8lmMRqTbshAuKNiWQRk2Hr7frzmfyZ 1421601742
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@suse.de>,
        Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-46f3f2c7
Subject: Re: [PATCHv2 4/4] x86_64,
 entry: Create IRET-compatible stack frame at syscall entry
Date: Sun, 18 Jan 2015 18:22:22 +0100
In-Reply-To: <CALCETrU84yDv+k=KojhODKfaJ-HHCWMuJteH98FR6md-JbmiQQ@mail.gmail.com>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
 <1421581520-2816-5-git-send-email-heukelum@fastmail.fm>
 <CALCETrU84yDv+k=KojhODKfaJ-HHCWMuJteH98FR6md-JbmiQQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015, at 17:38, Andy Lutomirski wrote:
> On Sun, Jan 18, 2015 at 3:45 AM, Alexander van Heukelum
> <heukelum@fastmail.fm> wrote:
> > Create an IRET-compatible top of stack at syscall entry and use this
> > information to return to user mode in the sysret path. This removes
> > the need for the FIXUP_TOP_OF_STACK and RESTORE_TOP_OF_STACK macros.
> 
> Since I have limited bandwidth, I'd like to tackle these one at a time.
> 
> I like the idea of this patch, but it has some issues.
> 
> First, it needs to be benchmarked.  The syscall fast path entry code
> is *very* hot in some workloads, and it needs to be fast.

Yeah. I didn't even try to benchmark it. What do you propose to use in this case?

> Second, I think you're really making three changes here.
> 
> a) You're putting rsp where it belongs -- it's in pt_regs instead of
> being magically shoved into a combination of per-cpu variables and
> extra arch state (thread->usersp).  This ideally consists of (AFAICS)
> two tiny asm changes: one extra mov (most likely cache-hot) on entry
> and a change of where you're reading from when you reload rsp on exit.
> The former change could easily add a cycle (or zero cycles, or lots of
> cycles -- hardware can be complicated, and I have no idea how well
> store forwarding works on gs-relative accesses).  The latter change is
> probably a speedup -- we'd be reading from pt_regs (almost certainly
> hot or at least easily detected by the hardware prefetcher) instead of
> a random percpu variable on exit.
> 
> *However*, this change enables the removal of all the usersp crap when
> context switching, and all of the old_rsp references need to be
> audited, and (having added yet another of them a week or two ago) I
> know that you missed at least one and probably three or four :)  Also,
> removing the usersp crap could easily speed up context switches by a
> cache line or so.

Yes. I missed that part. I'll  look into it. But nothing seems to blow up :)

> Can you do that and split out just the old_rsp, usersp, and rsp part
> as its own patch?
> 
> b) You're putting the saved flags into the EFLAGS pt_regs slot, which
> seems to me to be an unambiguous win -- it removes two instructions
> from RESTORE_TOP_OF_STACK, and it adds nothing whatsoever (except to
> the extent that you continue to initialize R11 on entry instead of in
> FIXUP_TOP_OF_STACK).
> 
> (a) and (b) alone should be enough to eliminate RESTORE_TOP_OF_STACK.
> 
> c) You're initializing the rest of the "top of stack" (cs, ss, and
> rcx) unconditionally.  This is simpler, but I'm not sure it's
> worthwhile -- we still lazily save the caller-saved regs, and
> FIXUP_TOP_OF_STACK fits right in.  It also may have a performance
> impact.
> 
> I think that (a) and (b) are clear wins (a is a really nice cleanup
> and I bet it's a speedup, too, and b seems to be better in all
> respects).  (c) is much less clearly a win to me.
> 
> Would you be willing to send split-out patches along with benchmarks?

Timing will depend highly on amounts of spare time, but I will give it
a shot.

Thanks for your valuable input!

Greetings,
    Alexander 

> --Andy
