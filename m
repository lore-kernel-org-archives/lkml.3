Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaKBCHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 22:07:07 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50443 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaKBCHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 22:07:02 -0400
Message-ID: <54559337.7050506@gmail.com>
Date: Sun, 02 Nov 2014 10:13:11 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: cmetcalf@tilera.com, dwalter@google.com, richard@nod.at,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] arch: tile: kernel: signal.c: Use __copy_from/to_user()
 instead of __get/put_user()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup/restore_sigcontext() want to copy all related registers between
user and kernel. So use block copy instead of each registers copy. Then
can let code simple and clearer (which can avoid compiler's warning):

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
 arch/tile/kernel/signal.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 7c2fecc..f867783 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -46,7 +46,6 @@ int restore_sigcontext(struct pt_regs *regs,
 		       struct sigcontext __user *sc)
 {
 	int err = 0;
-	int i;
 
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
@@ -57,9 +56,7 @@ int restore_sigcontext(struct pt_regs *regs,
 	 */
 	BUILD_BUG_ON(sizeof(struct sigcontext) != sizeof(struct pt_regs));
 	BUILD_BUG_ON(sizeof(struct sigcontext) % 8 != 0);
-
-	for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
-		err |= __get_user(regs->regs[i], &sc->gregs[i]);
+	err = __copy_from_user(regs, sc, sizeof(*regs));
 
 	/* Ensure that the PL is always set to USER_PL. */
 	regs->ex1 = PL_ICS_EX1(USER_PL, EX1_ICS(regs->ex1));
@@ -110,12 +107,7 @@ badframe:
 
 int setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs)
 {
-	int i, err = 0;
-
-	for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
-		err |= __put_user(regs->regs[i], &sc->gregs[i]);
-
-	return err;
+	return  __copy_to_user(sc, regs, sizeof(*regs));
 }
 
 /*
-- 
1.9.3
