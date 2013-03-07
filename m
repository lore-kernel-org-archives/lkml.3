Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964Ab3CGXDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:03:38 -0500
Received: from ozlabs.org ([203.10.76.45]:40200 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759939Ab3CGXDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:03:37 -0500
From: Michael Neuling <mikey@neuling.org>
To: Philippe De Muyter <phdm@macqel.be>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: 3.9-rc1 powerpc ptrace.c: 'brk.len' is used uninitialized
In-reply-to: <22285.1362695571@ale.ozlabs.ibm.com>
References: <20130306060058.GA3106@frolo.macqel> <21084.1362607788@ale.ozlabs.ibm.com> <20130306223645.GA15484@frolo.macqel> <31862.1362611670@ale.ozlabs.ibm.com> <20130307095907.GA16489@frolo.macqel> <22285.1362695571@ale.ozlabs.ibm.com>
Comments: In-reply-to Michael Neuling <mikey@neuling.org>
   message dated "Fri, 08 Mar 2013 09:32:51 +1100."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Fri, 08 Mar 2013 10:03:34 +1100
Message-ID: <11606.1362697414@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling <mikey@neuling.org> wrote:

> Philippe De Muyter <phdm@macqel.be> wrote:
> 
> > Hello Mikey,
> > 
> > On Thu, Mar 07, 2013 at 10:14:30AM +1100, Michael Neuling wrote:
> > > Philippe De Muyter <phdm@macqel.be> wrote:
> > > 
> > > > On Thu, Mar 07, 2013 at 09:09:48AM +1100, Michael Neuling wrote:
> > > > > > bisect tells me that since your commit 9422de3e953d0e60eb95f5430a9dd803eec1c6d7 
> > > > > > "powerpc: Hardware breakpoints rewrite to handle non DABR breakpoint registers",
> > > > > > compiling linux fails with :
> > > > > > 
> > > > > >   cc1: warnings being treated as errors
> > > > > >   arch/powerpc/kernel/ptrace.c: In function 'arch_ptrace':
> > > > > >   arch/powerpc/kernel/ptrace.c:1450: warning: 'brk.len' is used uninitialized in this function
> > > > > >   arch/powerpc/kernel/ptrace.c:1352: note: 'brk.len' was declared here
> > > > > > 
> > > > > > could you look at that ?
> > > > > 
> > > > > Sure. 
> > > > 
> > > > I use gcc-4.2.2, and my .config follows.
> > > 
> > > I'm a bit lost.  
> > > 
> > > I don't have 4.2.2 (which is ancient BTW) and I can't hit this on
> > > 4.3,4.5 or 4.6 with your config.  It compiles fine.
> > > 
> > > Also:
> > > 
> > > >   arch/powerpc/kernel/ptrace.c:1450: warning: 'brk.len' is used uninitialized in this function
> > > >   arch/powerpc/kernel/ptrace.c:1352: note: 'brk.len' was declared here
> > > 
> > > These line numbers make no sense at all WRT v3.9-rc1.  brk.len is neither
> > > declared or used in those lines:
> > 
> > those were the line numbers just after your commit
> > 
> > In 3.9-rc1 they are :
> > 
> > cc1: warnings being treated as errors
> > arch/powerpc/kernel/ptrace.c: In function 'arch_ptrace':
> > arch/powerpc/kernel/ptrace.c:1479: warning: 'brk.len' is used uninitialized in this function
> > arch/powerpc/kernel/ptrace.c:1381: note: 'brk.len' was declared here
> > 
> > 		if (child->thread.hw_brk.address)
> > 			return -ENOSPC;
> > 
> > 1479:		child->thread.hw_brk = brk;
> > 
> > 		return 1;
> > 	#endif /* !CONFIG_PPC_ADV_DEBUG_DVCS */
> 
> Got it.  I still can't replicate the issue here, so can you check if the
> below works for you?

Argh, scrap that..... try this.

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 245c1b6..8564515 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1428,6 +1428,7 @@ static long ppc_set_hwdebug(struct task_struct *child,
 
 	brk.address = bp_info->addr & ~7UL;
 	brk.type = HW_BRK_TYPE_TRANSLATE;
+	brk.len = 0;
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_READ)
 		brk.type |= HW_BRK_TYPE_READ;
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_WRITE)
