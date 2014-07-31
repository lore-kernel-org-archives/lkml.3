Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaGaFd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:33:29 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39646 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaGaFd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:33:28 -0400
Date: Wed, 30 Jul 2014 22:33:23 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM/ARM64: don't enter kgdb when userspace executes a
 kgdb break instruction.
Message-ID: <20140731053323.GA15523@mew.web-pass.com>
References: <20140730071245.GA8954@mew.web-pass.com>
 <20140730112414.GJ12239@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730112414.GJ12239@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 30, 2014 at 12:24:14PM +0100, Will Deacon wrote:
> Whilst this sounds like a worrying problem, I've failed to reproduce it
> on arm64.  Executing a brk instruction with either KGDB_DYN_DGB_BRK_IMM or
> KDBG_COMPILED_DBG_BRK_IMM immediates from userspace results in a SIGTRAP being
> delivered, assumedly because kgdb_handle_exception simply returns when kgdb
> isn't active.

>From what I can tell, the break hooks are registered so long as kgdb is enabled
at all - i.e., the kernel was compiled with CONFIG_KGDB=y and, for example,
CONFIG_KGDB_SERIAL_CONSOLE=y and kgdboc was passed on the kernel command line.
kgdb_handle_exception doesn't seem to check whether the debugger is active.

> The following (totally untested) diff is simpler for arm64, but again, I'm
> not sure we even have a problem here.

This diff also fixes the problem. I don't have a strong preference for either
approach, so I can revise the patch with this approach instead if you'd prefer
that.

> On which systems have you managed to reproduce this and how?

I first reproduced this on a Raspberry Pi. The recommended distro, Raspbian,
distributes a kernel compiled with CONFIG_KGDB=y, CONFIG_KGDB_KDB=y, and
CONFIG_KDB_KEYBOARD=y, so it was sufficient to have a keyboard plugged in.
However, I also reproduced it by booting with kgdboc on the command line, as
CONFIG_KGDB_SERIAL_CONSOLE was also enabled. Additionally, I reproduced it and
then verified that my patch fixed it on self-compiled kernels.

I don't currenty have access to a physical ARM64 board, so I did all the
testing for this with QEMU (loosely following the instructions here:
http://www.bennee.com/~alex/blog/2014/05/09/running-linux-in-qemus-aarch64-system-emulation-mode/).
Again, it was sufficient to build with CONFIG_KGDB=y and
CONFIG_KGDB_SERIAL_CONSOLE=y and boot with kgdboc enabled, i.e., passing
--append "console=ttyAMA0 kgdboc=ttyAMA0,115200" to QEMU. Here's a snippet from
that session.

# ./brk

Entering kdb (current=0xffffffc07df60a80, pid 71) on processor 0 Oops: (null)
due to oops @ 0x4000d8

dCPU: 0 PID: 71 Comm: brk Not tainted 3.16.0-rc7ajb #2
dtask: ffffffc07df60a80 ti: ffffffc07d0c0000 task.ti: ffffffc07d0c0000
PC is at 0x4000d8
LR is at 0x0
pc : [<00000000004000d8>] lr : [<0000000000000000>] pstate: 00000000
sp : 0000007fceefcdd0
x29: 0000000000000000 x28: 0000000000000000 
x27: 0000000000000000 x26: 0000000000000000 
x25: 0000000000000000 x24: 0000000000000000 
x23: 0000000000000000 x22: 0000000000000000 
x21: 0000000000000000 x20: 0000000000000000 
x19: 0000000000000000 x18: 0000000000000000 
x17: 0000000000000000 x16: 0000000000000000 
x15: 0000000000000000 x14: 0000000000000000 
x13: 0000000000000000 x12: 0000000000000000 
x11: 0000000000000000 x10: 0000000000000000 
x9 : 0000000000000000 x8 : 0000000000000000 
x7 : 0000000000000000 x6 : 0000000000000000 
x5 : 0000000000000000 x4 : 0000000000000000 
x3 : 0000000000000000 x2 : 0000000000000000 
x1 : 0000000000000000 x0 : 0000000000000000 

Let me know if you still have trouble reproducing this.

Thanks again!

Omar
