Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3IRJum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:50:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59153 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab3IRJuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:50:40 -0400
Date: Wed, 18 Sep 2013 10:50:03 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: Commit breaks strace: ARM: entry: allow ARM-private syscalls to
 be restarted
Message-ID: <20130918095003.GB1783@mudshark.cambridge.arm.com>
References: <20130917215749.GA11109@obsidianresearch.com>
 <20130918091748.GA1783@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918091748.GA1783@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 10:17:48AM +0100, Will Deacon wrote:
> On Tue, Sep 17, 2013 at 10:57:49PM +0100, Jason Gunthorpe wrote:
> > This happens with the latest git head for strace, as well as the 4.7
> > release.
> > 
> > Hopefully you can cook up a fix :)
> 
> I'll take a look today, thanks.

Ok, looks like the backwards branch to the syscall dispatching logic from
the trace entry is busted. Can you try the patch below please?

I might also take a look at unifying the function prototypes for arm_syscall
and syscall_trace_enter, since it should help us remove some of the argument
shuffling in the trace path.

Will

--->8

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 74ad15d1..bc6bd96 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -442,10 +442,10 @@ local_restart:
        ldrcc   pc, [tbl, scno, lsl #2]         @ call sys_* routine
 
        add     r1, sp, #S_OFF
-       cmp     scno, #(__ARM_NR_BASE - __NR_SYSCALL_BASE)
+2:     cmp     scno, #(__ARM_NR_BASE - __NR_SYSCALL_BASE)
        eor     r0, scno, #__NR_SYSCALL_BASE    @ put OS number back
        bcs     arm_syscall
-2:     mov     why, #0                         @ no longer a real syscall
+       mov     why, #0                         @ no longer a real syscall
        b       sys_ni_syscall                  @ not private func
 
 #if defined(CONFIG_OABI_COMPAT) || !defined(CONFIG_AEABI)

