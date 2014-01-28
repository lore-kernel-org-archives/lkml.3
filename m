Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaA1SxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:53:18 -0500
Received: from science.horizon.com ([71.41.210.146]:53009 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753894AbaA1SxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:53:17 -0500
Date: 28 Jan 2014 13:53:15 -0500
Message-ID: <20140128185315.9014.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, nate@thatsmathematics.com
Subject: Re: math_state_restore and kernel_fpu_end disable interrupts?
Cc: adilger@dilger.ca, arjan@linux.intel.com, jack@suse.cz,
        linux-kernel@vger.kernel.org, maarten-baert@hotmail.com, mingo@elte.hu,
        suresh.b.siddha@intel.com, tglx@linutronix.de, viro@zeniv.linux.org.uk
In-Reply-To: <20140119210228.9598.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm trying it now.  But it takes a while for me to reproduce, and even
> longer to be sure the problem has gone away.  So anything you hear from
> me within a week will be bad news.

Well, it's been a week, and: good news!

I'd still wish for some review by someone who really understands this
code; in particular it seems dangerous to just enable interrupts for
a window without re-checking the condition afterward.

What if an interrupt hander wants to use the FPU and triggers the
allocate itself?  Shouldn't it be:
* Enable interrupts
* Allocate
* Disable interrupts
* Check that tsk->thread.xstate is still NULL
* (If it has been filled in, free and return.)
* Fill in tsk->thread.xstate

I don't feel I really understand the irq_fpu_usable() logic in
arch/x86/i387.c.

But this patch clearly doesn't make these issues any *worse*, so
these concerns are no reason to block it.


Would you like add an appropriate commit message and send in the patch?

Something like:

Subject: arch/x86/kernel/traps.c: make math_state_restore preserve IRQ status.

Commit aa283f4927 (in 2.6.26!) to add lazy FPU save are allocation did
an local_irq_enable()/local_irq_disable() around the allocate.  However,
that assumes that it is only called with interrupts disabled.

math_state_restore() can also be called from kernel_fpu_end() with
interrupts enabled.  Very occasionally, this triggers an FPU state
allocation.  Disabling interrupts unconditionally is Bad.

Not-yet-Signed-off-by: Nate Eldredge <nate@thatsmathematics.com>
Tested-by: George Spelvin <linux@horizon.com>
Cc: <stable@vger.kernel.org>
Fixes: aa283f4927
