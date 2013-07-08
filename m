Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3GHBpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 21:45:32 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:47989 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3GHBpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 21:45:05 -0400
MIME-Version: 1.0
Date: Mon, 8 Jul 2013 10:45:03 +0900
Message-ID: <CAOiN93mGTu9w9rVNCrbbH1sccXY9VJhaCmg+dS7Rk9mMgKHBaA@mail.gmail.com>
Subject: Seg fault occurs when running statically compiled binary from kernel
 using call_usermodehelper
From: Ashish Sangwan <ashishsangwan2@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-arm@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On kernel version 3.8.13, when we try to execute a statically compiled
binary from kernel, it is giving segfault:

insmod /mnt/module2.ko
[   35.560000] sample.static: unhandled page fault (11) at 0x00000000,
code 0x80000007
[   36.440000] Pid: 257, comm:        sample.static
[   36.444000] CPU: 3    Tainted: G        W  O  (3.8.13+ #35)
[   36.448000] PC is at 0x0
[   36.452000] LR is at 0xa420
[   36.456000] pc : [<00000000>]    lr : [<0000a420>]    psr: 60000030
[   36.456000] sp : beb30d70  ip : 00000004  fp : 00000000
[   36.464000] r10: 0000a004  r9 : 0000a0a4  r8 : 00000001
[   36.472000] r7 : 00000001  r6 : 0008be5c  r5 : 00000000  r4 : 0008ce80
[   36.476000] r3 : 00000001  r2 : 00000001  r1 : 00000000  r0 : 00000000
[   36.484000] Flags: nZCv  IRQs on  FIQs on  Mode USER_32  ISA Thumb
Segment user
[   36.492000] Control: 10c53c7d  Table: 7b1f806a  DAC: 00000015
[   36.496000] Backtrace:
[   36.500000] [<c00171f8>] (dump_backtrace+0x0/0x11c) from
[<c03e8a54>] (dump_stack+0x20/0x24)
[   36.508000]  r6:e514dd80 r5:00000000 r4:e5175fb0 r3:271ae511
[   36.516000] [<c03e8a34>] (dump_stack+0x0/0x24) from [<c0014174>]
(show_regs+0x58/0x5c)
[   36.524000] [<c001411c>] (show_regs+0x0/0x5c) from [<c001794c>]
(show_info+0xe0/0x14c)
[   36.532000]  r4:00000000 r3:00000000
[   36.532000] [<c001786c>] (show_info+0x0/0x14c) from [<c001dfb4>]
(__do_user_fault+0x78/0xc8)
[   36.540000]  r7:80000007 r6:0000000b r5:00000000 r4:e514dd80
[   36.548000] [<c001df3c>] (__do_user_fault+0x0/0xc8) from
[<c03f4574>] (do_page_fault+0x360/0x3d4)
[   36.556000] [<c03f4214>] (do_page_fault+0x0/0x3d4) from
[<c0008470>] (do_PrefetchAbort+0x44/0xa8)
[   36.564000] [<c000842c>] (do_PrefetchAbort+0x0/0xa8) from
[<c03f2bbc>] (ret_from_exception+0x0/0x10)
[   36.572000] Exception stack(0xe5175fb0 to 0xe5175ff8)
[   36.960000] do_init_module: 'module2'->init suspiciously returned
11, it should follow 0/-E convention
[   36.960000] do_init_module: loading module anyway...
[   36.964000] Backtrace:
[   36.968000] [<c00171f8>] (dump_backtrace+0x0/0x11c) from
[<c03e8a54>] (dump_stack+0x20/0x24)
[   36.972000]  r6:bf000090 r5:bf00009c r4:e51d7f48 r3:00000000
[   36.980000] [<c03e8a34>] (dump_stack+0x0/0x24) from [<c008ae88>]
(load_module+0x1a90/0x1eb4)
[   36.984000] [<c00893f8>] (load_module+0x0/0x1eb4) from [<c008b3b0>]
(sys_init_module+0xe8/0xf8)
[   36.988000] [<c008b2c8>] (sys_init_module+0x0/0xf8) from
[<c0012dc0>] (ret_fast_syscall+0x0/0x48)
[   36.992000]  r6:bea51a14 r5:bea51b7c r4:00006ee4
[   36.996000] module2 mod ld

module2.c =>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/kmod.h>
MODULE_LICENSE( "GPL" );
static int test( void )
{
  char *argv[] = { "/mnt/sample.static", NULL };
  static char *envp[] = {
        "HOME=/",
        "TERM=linux",
        "PATH=/sbin:/bin:/usr/sbin:/usr/bin", NULL };
  return call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC );
}
static int __init mod_entry_func( void )
{
  return test();
}

static void __exit mod_exit_func( void )
{
  return;
}
module_init( mod_entry_func );
module_exit( mod_exit_func );


sample.static is a simple "Hello_world" program.

However, there is no problem in executing dynamically compiled binaries.

When we revert commit 9fff2fa0db911b0b75ec1f9bec72460c0a676ef5 (arm:
switch to saner kernel_execve() semantics), there is no problem.

OR

for kernel 3.8.13 (which is just a plain revert when arch specific
kernel_execve was present), then also no problem =>

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 0023a87..9cf6e15 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -184,6 +184,10 @@ static int ____call_usermodehelper(void *data)
        struct subprocess_info *sub_info = data;
        struct cred *new;
        int retval;
+#ifdef ARM
+       struct pt_regs regs;
+       struct pt_regs *curr_ptr;
+#endif
        spin_lock_irq(&current->sighand->siglock);
        flush_signal_handlers(current, 1);
@@ -222,6 +226,36 @@ static int ____call_usermodehelper(void *data)
        retval = do_execve(sub_info->path,
                           (const char __user *const __user *)sub_info->argv,
                           (const char __user *const __user *)sub_info->envp);
+
+#ifdef ARM
+       if (retval)
+               goto fail;
+       curr_ptr = current_pt_regs();
+       memcpy(&regs, curr_ptr, sizeof(struct pt_regs));
+       /*
+        * Save argc to the register structure for userspace.
+        */
+       regs.ARM_r0 = retval;
+
+       /*
+        * We were successful.  We won't be returning to our caller, but
+        * instead to user space by manipulating the kernel stack.
+        */
+       asm(    "add    r0, %0, %1\n\t"
+               "mov    r1, %2\n\t"
+               "mov    r2, %3\n\t"
+               "bl     memmove\n\t"    /* copy regs to top of stack */
+               "mov    r8, #0\n\t"     /* not a syscall */
+               "mov    r9, %0\n\t"     /* thread structure */
+               "mov    sp, r0\n\t"     /* reposition stack pointer */
+               "b      ret_to_user"
+               :
+               : "r" (current_thread_info()),
+                 "Ir" (THREAD_START_SP - sizeof(regs)),
+                 "r" (&regs),
+                 "Ir" (sizeof(regs))
+               : "r0", "r1", "r2", "r3", "r8", "r9", "ip", "lr", "memory");
+#endif
        if (!retval)
                return 0;
--

Please suggest a proper solution.

Regards,
Ashish
