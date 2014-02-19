Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaBSGWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:22:38 -0500
Received: from koorogi.info ([198.74.62.75]:34673 "EHLO mail.koorogi.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaBSGWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:22:37 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 01:22:37 EST
From: Bobby Bingham <koorogi@koorogi.info>
To: akpm@linux-foundation.org, linux-sh@vger.kernel.org
Cc: Bobby Bingham <koorogi@koorogi.info>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Don't let system calls clobber userspace registers
Date: Wed, 19 Feb 2014 00:03:13 -0600
Message-Id: <cover.1392789383.git.koorogi@koorogi.info>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When invoking syscall handlers on sh32, the saved userspace registers
are at the top of the stack. This seems to have been intentional, as it
is an easy way to pass r0, r1, ... to the handler as parameters 5, 6,
...

It causes problems, however, because the compiler is allowed to generate
code for a function which clobbers that function's own parameters. For
example, gcc generates the following code for clone:

    <SyS_clone>:
        mov.l   8c020714 <SyS_clone+0xc>,r1  ! 8c020540 <do_fork>
        mov.l   r7,@r15
        mov     r6,r7
        jmp     @r1
        mov     #0,r6
        nop
        .word 0x0540
        .word 0x8c02

The `mov.l r7,@r15` clobbers the saved value of r0 passed from
userspace. For most system calls, this might not be a problem, because
we'll be overwriting r0 with the return value anyway. But in the case
of clone, copy_thread will need the original value of r0 if the
CLONE_SETTLS flag was specified.

The first patch in this series fixes this issue for system calls by
pushing to the stack and extra copy of r0-r2 before invoking the
handler. We discard this copy before restoring the userspace registers,
so it is not a problem if they are clobbered.

Exception handlers also receive the userspace register values in a
similar manner, and may hit the same problem. The second patch removes
the do_fpu_error handler, which looks susceptible to this problem and
which, as far as I can tell, has not been used in some time. The third
patch addresses other exception handlers.

Changes since V1:
- Update messages for [2/3] to quote the short log of the  previous
  commit that left do_fpu_error unused.

Bobby Bingham (3):
  sh: push extra copy of r0-r2 for syscall parameters
  sh: remove unused do_fpu_error
  sh: don't pass saved userspace state to exception handlers

 arch/sh/include/asm/syscalls_32.h | 12 +++---------
 arch/sh/include/asm/traps_32.h    | 16 ++++------------
 arch/sh/kernel/entry-common.S     | 15 +++++++++++----
 arch/sh/kernel/signal_32.c        | 12 ++++--------
 arch/sh/kernel/sys_sh32.c         |  7 ++-----
 arch/sh/kernel/traps_32.c         | 23 +++++++----------------
 arch/sh/math-emu/math.c           | 18 ------------------
 7 files changed, 31 insertions(+), 72 deletions(-)

-- 
1.8.5.5

