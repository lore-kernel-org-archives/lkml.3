Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaIICCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:02:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45257 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaIICCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:02:30 -0400
Date: Tue, 9 Sep 2014 03:02:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v3 00/29] nios2 Linux kernel port
Message-ID: <20140909020225.GW7996@ZenIV.linux.org.uk>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410168160-3624-1-git-send-email-lftan@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 05:22:11PM +0800, Ley Foon Tan wrote:
> This is the 3rd version of patchset adds the Linux kernel port for Nios II processor from
> Altera. All of the feedback from v2 patchseries has been addressed. Thanks to all who
> provided feedback on the previous version.

a) signal caught in rt_sigreturn() (e.g. from change of the set of blocked
signals) should *NOT* trigger syscall restart.  IOW, wrt syscall restart
logics, rt_sigreturn() acts as exception, not as a syscall.  You are
setting ->orig_r2 to -1, but that doesn't affect your syscall restart
logics.

As the matter of fact, your 'in_syscall' argument is bogus - it's always
1.  For return from interrupt as well as that from syscall.  And syscall
restart logics _really_ shouldn't apply to return from interrupts - it's
not only wrong, but very hard to debug.

b) multiple pending signals should be all handled before return to
userland.  Only the first one might have syscall restart logics triggered.
The effect should be identical to what you'd get if e.g. a timer interrupt
had hit just as you were returning to userland (possibly into handler)
after handling the first one, etc.  At the absolute least, SIGSEGV from
failing attempt to build a sigframe should be handled before returning
to userland.

c) rt_sigreturn() should reset ->restart_block.fn to do_no_restart_syscall

d) what's
+       regs->estatus = (regs->estatus & 0xffffffff);
in rt_restore_ucontext() about?

e) restart in handlerless case is better off without leaving the kernel
mode.  See what e.g. arm and s390 are doing.
