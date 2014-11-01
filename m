Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbaKAMnj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 08:43:39 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38272 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbaKAMnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 08:43:37 -0400
Message-ID: <5454D6E9.1090900@gmail.com>
Date: Sat, 01 Nov 2014 20:49:45 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: cmetcalf@tilera.com, dwalter@google.com, richard@nod.at
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: tile: kernel: signal.c: Use explicitly type case "unsigned
 long *" for register copy
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_sigcontext() wants to copy all kernel related registers to user
space. So let it copy explicitly instead of copying by exceeding member
array border. So let code more clearer and avoid warning.

And for register, better use "unsigned long" instead of "long", too.

The related warning (with allmodconfig under tile):

    CC      arch/tile/kernel/signal.o
  In file included from include/linux/poll.h:11:0,
                   from include/linux/ring_buffer.h:7,
                   from include/linux/ftrace_event.h:5,
                   from include/trace/syscall.h:6,
                   from include/linux/syscalls.h:81,
                   from arch/tile/kernel/signal.c:30:
  arch/tile/kernel/signal.c: In function 'setup_sigcontext':
  arch/tile/kernel/signal.c:116:31: warning: iteration 53u invokes undefined behavior [-Waggressive-loop-optimizations]
     err |= __put_user(regs->regs[i], &sc->gregs[i]);
                                 ^
  ./arch/tile/include/asm/uaccess.h:236:26: note: in definition of macro '__put_user_asm'
          : "r" (ptr), "r" (x), "i" (-EFAULT))
                            ^
  ./arch/tile/include/asm/uaccess.h:297:10: note: in expansion of macro '__put_user_8'
    case 8: __put_user_8(x, ptr, __ret); break;   \
            ^
  arch/tile/kernel/signal.c:116:10: note: in expansion of macro '__put_user'
     err |= __put_user(regs->regs[i], &sc->gregs[i]);
            ^
  arch/tile/kernel/signal.c:115:2: note: containing loop
    for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
    ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/tile/kernel/signal.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 7c2fecc..a584ea1 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -112,8 +112,9 @@ int setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs)
 {
 	int i, err = 0;
 
-	for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
-		err |= __put_user(regs->regs[i], &sc->gregs[i]);
+	for (i = 0; i < sizeof(regs)/sizeof(unsigned long); ++i)
+		err |= __put_user(((unsigned long *)regs)[i],
+				&((unsigned long *)sc)[i]);
 
 	return err;
 }
-- 
1.9.3
