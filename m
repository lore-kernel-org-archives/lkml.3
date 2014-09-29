Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaI2Tvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:51:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:53847 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbaI2Tva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:51:30 -0400
Date: Mon, 29 Sep 2014 21:51:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Lackner <sebastian@fds-team.de>
cc: Andy Lutomirski <luto@amacapital.net>, Anish Bhatt <anish@chelsio.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
In-Reply-To: <5429B5E4.6080302@fds-team.de>
Message-ID: <alpine.DEB.2.02.1409292144340.22082@ionos.tec.linutronix.de>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com> <54299979.6080705@amacapital.net> <5429A556.50507@fds-team.de> <alpine.DEB.2.02.1409292059530.22082@ionos.tec.linutronix.de> <5429B5E4.6080302@fds-team.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014, Sebastian Lackner wrote:
> I see several issues here:
> 
> * At first the behaviour is not consistent between several system
> call and return instructions. For example calling syscalls by using
> 'int' doesn't have this issue, as it clears the NT flag before
> entering kernel code. Return instructions also don't show this issue
> all the time, just when it hits one of the problematic pieces of
> code.

And why should we care? The use of NT is not supported. Period. So it
does not matter whether A explodes and B does not.

> * The kernel might execute all kind of other code (for example
> inside of drivers) and start additional threads. I didn't find any
> good example yet, but its not that unlikely, that the exception can
> also happen in a completely unrelated thread, where the kernel can
> not just kill the corresponding usermode app...

The thread can execute whatever it wants in kernel context. The
exception is going to hit on return to user space and not in some
random kernel context. The threads it creates are going to die as
well.

> I'm fine with all kind of solutions, either it should be allowed to
> set NT, or the kernel should at least throw a proper exception, so
> that usermode has a chance to catch and handle it. At the moment the
> segfault is deadly, as the segfault handler immediately segfaults
> again - no chance to recover from such an error.

# gdb ./crap core

(gdb) info registers

eflags         0x4296	[ PF AF SF IF NT ]

Tells you very much that there is state which is not supported.

Thanks,

	tglx
