Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbaJVJht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:37:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbaJVJhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:37:47 -0400
Date: Wed, 22 Oct 2014 11:37:35 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] s390 vs. kprobes on ftrace
Message-ID: <20141022093735.GA31440@suse.cz>
References: <1413880229-4796-1-git-send-email-heiko.carstens@de.ibm.com>
 <20141021195831.GA31587@suse.cz>
 <20141022082625.GB4090@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022082625.GB4090@osiris>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:26:25AM +0200, Heiko Carstens wrote:

> > I can confirm that kGraft works well on top of current mainline with
> > this patch added.
> > 
> > Another reason for a performance impact when kGraft is enabled is that
> > kGraft still adds two instructions to the syscall path on s390x, as
> > there is no space left for a kgraft TIF in the first eight bits of
> > thread info flags. Renumbering the thread info flags such that _TIF_WORK
> > occupies the first eight bits and TIF_TRACE the next eight would fix
> > that problem: Do you believe it is feasible?
> 
> Hi Vojtech,
> 
> I think you're talking about the SLES12 kernel? 

I'm working with upstream git right now, to make sure kGraft keeps up
with it.

> There you can simply move the TIF_SYSCALL bit to the same byte where
> your TIF_KGR bit resides.

On 3.12 (SLE12) this would allow me to clear the TIF_KGR in a single
instruction when exiting a syscall simply by extending the mask. 

I need to clear it before entering a syscall, too, and TIF_SYSCALL is
set there, not cleared.

What could work is moving TIF_SYSCALL and TIF_KGR to the same byte as
TIF_TRACE. Then I could use the TIF_TRACE check to also clear the
TIF_KGR bit in sysc_tracesys without adding an instruction to the hot
path.

> Upstream is a bit different since the TIF_SYSCALL bit is already gone (got
> replaced with an s390 specific "PIF" bit). However the free TIF bit got
> already eaten up by uprobes..

Yes, and all the 8 bits are eaten now in upstream. That's what got me
thinking about separating TIF_WORK and TIF_TRACE to separate bytes, with
no other flags in them. Then the syscall code would then just check the
whole byte for zero instead of doing test-under-mask.

> However we can think of a better solution for upstream if the combined
> solution of kGraft/kpatch is ready to be merged.

We may, indeed, end up doing things very differently there.

At least initially the plan is to go entirely without enforcing any kind
of consistency when patching, so TIF_KGR and the lazy migration will not
exist, and neither will we be stopping the kernel or checking stacks.

This will make applying patches bigger than a single functions tricky,
but it's a good initial goal.

-- 
Vojtech Pavlik
Director SUSE Labs
