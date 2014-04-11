Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaDKCbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 22:31:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbaDKCbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 22:31:17 -0400
Message-ID: <1397183422.29990.34.camel@localhost>
Subject: Re: [GIT PULL] Audit subsystem for v3.15
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 10 Apr 2014 22:30:22 -0400
In-Reply-To: <1397174015.29990.30.camel@localhost>
References: <1397174015.29990.30.camel@localhost>
Content-Type: multipart/mixed; boundary="=-/N+L8e4rKw7tYPuRaWCV"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/N+L8e4rKw7tYPuRaWCV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

My tree is fine, your tree is fine, but the merge (even if you solve the
conflicts) has a build failure on MIPS just discovered when I published
by 'merge-test' branch because of the syscall_get_arch(void) changes.
(thanks to the kbuild test robot)

attached is my solution which I just sent to the MIPS people.  I hope
that you can apply it as part of the merge itself...

On Thu, 2014-04-10 at 19:53 -0400, Eric Paris wrote:
> Linus,
> 
> Please pull the audit tree for v3.15.  You will have merge conflicts.
> I'll publish my branch "merge-test" where I attempted to resolve them
> the way you will.
> 
> The main issue is an across tree change to syscall_get_arch().  I change
> it from taking a task_struct and pt_regs to take a void.  Not a single
> arch used or needed either of these arguments.  (For 3.16 we plan to
> implement the function on more arches)
> 
> There are a couple of conflicts where I made changes to #includes and
> your tree also has some additions.  Should be obvious.
> 
> Two conflict issues with Kconfig changes.  The first is just that your
> tree has some additional 'select' lines mine didn't.  Obvious to
> resolve.
> 
> The second is a conflict in init/Kconfig.  I don't completely understand
> it.  I believe it was the addition of ALPHA to the gigantic depends
> line.  I cherry-picked the patch from your tree that introduced ALPHA
> before I made the switch to HAVE_ARCH_AUDITSYSCALL.  I believed that
> would avoid the conflict, but I guess I was wrong.  In any case, I have
> the 'select HAVE_ARCH_AUDITSYSCALL' in alpha.
> 
> There is also a conflict given the last second EPERM->ECONNREFUSED
> switcheroo.  My 3.15 is less restrictive.  We return ECONNREFUSED only
> for non-init username.  Should be another easy one...
> 
> Please let me know if anything isn't easy/obvious for you!
> 
> Thank you!
> 
> -Eric
> 
> The following changes since commit b7d3622a39fde7658170b7f3cf6c6889bb8db30d:
> 
>   Merge tag 'v3.13' into for-3.15 (2014-03-07 11:41:32 -0500)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/eparis/audit.git master
> 
> for you to fetch changes up to 312103d64d0fcadb332899a2c84b357ddb18f4e3:
> 
>   AUDIT: make audit_is_compat depend on CONFIG_AUDIT_COMPAT_GENERIC (2014-04-10 17:51:29 -0400)
> 
> ----------------------------------------------------------------
> AKASHI Takahiro (2):
>       audit: Add CONFIG_HAVE_ARCH_AUDITSYSCALL
>       audit: Add generic compat syscall support
> 
> Chris Metcalf (1):
>       AUDIT: make audit_is_compat depend on CONFIG_AUDIT_COMPAT_GENERIC
> 
> Eric Paris (7):
>       audit: include subject in login records
>       syscall_get_arch: remove useless function arguments
>       audit: use uapi/linux/audit.h for AUDIT_ARCH declarations
>       audit: define audit_is_compat in kernel internal header
>       AUDIT: Allow login in non-init namespaces
>       audit: do not cast audit_rule_data pointers pointlesly
>       audit: renumber AUDIT_FEATURE_CHANGE into the 1300 range
> 
> Eric W. Biederman (2):
>       audit: Use struct net not pid_t to remember the network namespce to reply in
>       audit: Send replies in the proper network namespace.
> 
> Joe Perches (1):
>       audit: remove stray newline from audit_log_execve_info() audit_panic() call
> 
> Josh Boyer (1):
>       audit: remove stray newlines from audit_log_lost messages
> 
> Monam Agarwal (1):
>       kernel: Use RCU_INIT_POINTER(x, NULL) in audit.c
> 
> Richard Guy Briggs (9):
>       audit: Use more current logging style again
>       capabilities: add descriptions for AUDIT_CONTROL and AUDIT_WRITE
>       audit: rename the misleading audit_get_context() to audit_take_context()
>       pid: get pid_t ppid of task in init_pid_ns
>       audit: convert PPIDs to the inital PID namespace.
>       audit: anchor all pid references in the initial pid namespace
>       audit: allow user processes to log from another PID namespace
>       audit: remove superfluous new- prefix in AUDIT_LOGIN messages
>       sched: declare pid_alive as inline
> 
> William Roberts (3):
>       mm: Create utility function for accessing a tasks commandline value
>       proc: Update get proc_pid_cmdline() to use mm.h helpers
>       audit: Audit proc/<pid>/cmdline aka proctitle
> 
> 蔡正龙 (1):
>       alpha: Enable system-call auditing support.
> 
>  arch/alpha/Kconfig                   |   4 ++++
>  arch/alpha/include/asm/ptrace.h      |   5 +++++
>  arch/alpha/include/asm/thread_info.h |   2 ++
>  arch/alpha/kernel/Makefile           |   1 +
>  arch/alpha/kernel/audit.c            |  60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arch/alpha/kernel/entry.S            |   6 +++++-
>  arch/alpha/kernel/ptrace.c           |   4 ++++
>  arch/arm/Kconfig                     |   1 +
>  arch/arm/include/asm/syscall.h       |   5 ++---
>  arch/ia64/Kconfig                    |   1 +
>  arch/mips/include/asm/syscall.h      |   4 ++--
>  arch/mips/kernel/ptrace.c            |   2 +-
>  arch/parisc/Kconfig                  |   1 +
>  arch/powerpc/Kconfig                 |   1 +
>  arch/s390/Kconfig                    |   1 +
>  arch/s390/include/asm/syscall.h      |   7 +++----
>  arch/sh/Kconfig                      |   1 +
>  arch/sparc/Kconfig                   |   1 +
>  arch/um/Kconfig.common               |   1 +
>  arch/x86/Kconfig                     |   1 +
>  arch/x86/include/asm/syscall.h       |  10 ++++------
>  drivers/tty/tty_audit.c              |   3 ++-
>  fs/proc/base.c                       |  36 ++----------------------------------
>  include/asm-generic/syscall.h        |   4 +---
>  include/linux/audit.h                |  17 ++++++++++++++++-
>  include/linux/mm.h                   |   1 +
>  include/linux/sched.h                |  20 +++++++++++++++++++-
>  include/uapi/linux/audit.h           |   3 ++-
>  include/uapi/linux/capability.h      |   4 ++++
>  init/Kconfig                         |   5 ++++-
>  kernel/audit.c                       |  66 ++++++++++++++++++++++++++++++++++++++++-------------------------
>  kernel/audit.h                       |   8 +++++++-
>  kernel/auditfilter.c                 |  41 +++++++++++++++++++++++++++++++----------
>  kernel/auditsc.c                     | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------
>  kernel/seccomp.c                     |   4 ++--
>  lib/Kconfig                          |   9 +++++++++
>  lib/Makefile                         |   1 +
>  lib/audit.c                          |  15 ++++++++++++++-
>  lib/compat_audit.c                   |  50 +++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/util.c                            |  48 +++++++++++++++++++++++++++++++++++++++++++++++
>  security/integrity/integrity_audit.c |   2 +-
>  security/lsm_audit.c                 |  11 +++++++----
>  42 files changed, 464 insertions(+), 136 deletions(-)
>  create mode 100644 arch/alpha/kernel/audit.c
>  create mode 100644 lib/compat_audit.c
> 


--=-/N+L8e4rKw7tYPuRaWCV
Content-Disposition: attachment;
	filename*0=0001-MIPS-use-current-instead-of-task-in-syscall_get_arch.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-MIPS-use-current-instead-of-task-in-syscall_get_arch.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 129947be924678e041ab0f7c7bcf0a436d4116a7 Mon Sep 17 00:00:00 2001
From: Eric Paris <eparis@redhat.com>
Date: Thu, 10 Apr 2014 22:19:26 -0400
Subject: [PATCH] MIPS: use current instead of task in syscall_get_arch

In commit 6e345746 Markos started using task to determine 64bit vs
32bit instead of it being completely CONFIG based.

In commit 5e937a9a we dropped the 'task' argument to syscall_get_arch()
across the entire system.

This obviously results in a build failure when Linus's and the audit
tree were merged.  This patch should be applied as part of the merge
conflict, as both sides of the merge are correct and the failure happens
AT the merge.

The fix is simple.  The task is always current.  Use current.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: markos.chandras@imgtec.com
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: linux-mips@linux-mips.org
---
 arch/mips/include/asm/syscall.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/syscall.h b/arch/mips/include/asm/syscall.h
index d79cded..1258884 100644
--- a/arch/mips/include/asm/syscall.h
+++ b/arch/mips/include/asm/syscall.h
@@ -131,7 +131,7 @@ static inline int syscall_get_arch(void)
 {
 	int arch = EM_MIPS;
 #ifdef CONFIG_64BIT
-	if (!test_tsk_thread_flag(task, TIF_32BIT_REGS))
+	if (!test_tsk_thread_flag(current, TIF_32BIT_REGS))
 		arch |= __AUDIT_ARCH_64BIT;
 #endif
 #if defined(__LITTLE_ENDIAN)
-- 
1.9.0


--=-/N+L8e4rKw7tYPuRaWCV--

