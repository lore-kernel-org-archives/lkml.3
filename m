Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab3FMRxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:53:39 -0400
Received: from 1wt.eu ([62.212.114.60]:36299 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab3FMRxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:53:38 -0400
Date: Thu, 13 Jun 2013 19:53:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sven-Haegar Koch <haegar@sdinet.de>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Linux 2.6.32.61 - x86/ptrace/gcc 4.7 build error
Message-ID: <20130613175330.GC27760@1wt.eu>
References: <20130610101557.GA3235@1wt.eu> <alpine.DEB.2.10.1306101708360.1713@aurora64.sdinet.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306101708360.1713@aurora64.sdinet.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sven-Haegar, Christoph,

concerning the issue below, I could reproduce both Sven-Haegar's error (running
make headers_check with the patch applied) and Christoph's build error with gcc
4.7 on i686 without the patch.

I noticed that neither syscall_trace_enter() nor syscall_trace_leave() were
called from C code, all were from pure asm. So I simply reverted the first
patch then removed the two function prototypes and everything is OK for me
now using gcc 4.7, i686 and x86_64.

I'm attaching the two patches here to be appled on top of 2.6.32.61, I would
like it if you could try in your environment to confirm that they correctly
fix the issue.

Thanks,
Willy

--
On Mon, Jun 10, 2013 at 05:11:49PM +0200, Sven-Haegar Koch wrote:
> On Mon, 10 Jun 2013, Willy Tarreau wrote:
> 
> > Willy Tarreau (2):
> >       x86, ptrace: fix build breakage with gcc 4.7
> 
> This change breaks "make headers_install":
> 
>   CHECK   include (0 files)
>   CHECK   include/asm (54 files)
> /home/haegar/src/2.6.32/linux/usr/include/asm/ptrace.h:5: included file 'linux/linkage.h' is not exported
> make[3]: *** [/home/haegar/src/2.6.32/linux/usr/include/asm/.check] Error 123
> make[2]: *** [headers_check] Error 2
> make[1]: *** [deb-pkg] Error 2
> make: *** [deb-pkg] Error 2
> 
> c'ya
> sven-haegar
> 
> -- 
> Three may keep a secret, if two of them are dead.
> - Ben F.
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Revert-x86-ptrace-fix-build-breakage-with-gcc-4.7.patch"

>From 3ad35bf84f747cafa2766c56cb21a0229b4def5e Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Thu, 13 Jun 2013 16:40:05 +0200
Subject: [PATCH 1/2] Revert "x86, ptrace: fix build breakage with gcc 4.7"

This reverts commit 4ed3bb08f1698c62685278051c19f474fbf961d2.

As reported by Sven-Haegar Koch, this patch breaks make headers_check :

   CHECK   include (0 files)
   CHECK   include/asm (54 files)
   /home/haegar/src/2.6.32/linux/usr/include/asm/ptrace.h:5: included file 'linux/linkage.h' is not exported

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/ptrace.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index e668d72..0f0d908 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_PTRACE_H
 
 #include <linux/compiler.h>	/* For __user */
-#include <linux/linkage.h>	/* For asmregparm */
 #include <asm/ptrace-abi.h>
 #include <asm/processor-flags.h>
 
@@ -143,8 +142,8 @@ extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code, int si_code);
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
-extern asmregparm long syscall_trace_enter(struct pt_regs *);
-extern asmregparm void syscall_trace_leave(struct pt_regs *);
+extern long syscall_trace_enter(struct pt_regs *);
+extern void syscall_trace_leave(struct pt_regs *);
 
 static inline unsigned long regs_return_value(struct pt_regs *regs)
 {
-- 
1.7.12.2.21.g234cd45.dirty


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-x86-ptrace-fix-build-breakage-with-gcc-4.7-second-tr.patch"

>From ef4e1b7c6e2b3ec58ed5650d95a2f71929386316 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Thu, 13 Jun 2013 19:36:35 +0200
Subject: [PATCH 2/2] x86, ptrace: fix build breakage with gcc 4.7 (second
 try)

syscall_trace_enter() and syscall_trace_leave() are only called from
within asm code and do not need to be declared in the .c at all.
Removing their reference fixes the build issue that was happening
with gcc 4.7.

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/ptrace.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 0f0d908..1ec926d 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -142,9 +142,6 @@ extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code, int si_code);
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
-extern long syscall_trace_enter(struct pt_regs *);
-extern void syscall_trace_leave(struct pt_regs *);
-
 static inline unsigned long regs_return_value(struct pt_regs *regs)
 {
 	return regs->ax;
-- 
1.7.12.2.21.g234cd45.dirty


--opJtzjQTFsWo+cga--
