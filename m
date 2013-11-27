Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab3K0WDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:03:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53031 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299Ab3K0WDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:03:31 -0500
Message-ID: <52966C0A.7070201@zytor.com>
Date: Wed, 27 Nov 2013 14:02:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>	<5294F10C.8060901@amacapital.net> <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com> <52964EC7.9000504@zytor.com>
In-Reply-To: <52964EC7.9000504@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------060806090303080802050708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060806090303080802050708
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For the record, this is the entire patch necessary to do the
sync_cores() system call -- and no potential interactions with security
frameworks or whatnot, simply because no security-sensitive operations
are performed of any kind.

Comments/opinions appreciated.

	-hpa


--------------060806090303080802050708
Content-Type: text/x-patch;
 name="0001-x86-Add-a-sync_cores-system-call-for-user-space-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-Add-a-sync_cores-system-call-for-user-space-code.pa";
 filename*1="tch"

>From c0246c43c30453e4f88a314e437d4504e6a36c08 Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 27 Nov 2013 13:57:29 -0800
Subject: [PATCH] x86: Add a sync_cores() system call for user space code
 patching

Add a system call to synchronize all processors (guarantee execution
of a serializing instruction on all processors before execution
resumes) so that user space can do INT3-style patching, or any other
kind of patching that it wants to do.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/alternative.c    | 15 +++++++++++++++
 arch/x86/syscalls/syscall_32.tbl |  1 +
 arch/x86/syscalls/syscall_64.tbl |  1 +
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df94598ad05a..8227eee42114 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -12,6 +12,7 @@
 #include <linux/stop_machine.h>
 #include <linux/slab.h>
 #include <linux/kdebug.h>
+#include <linux/syscalls.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
@@ -676,3 +677,17 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	return addr;
 }
 
+/**
+ * sys_sync_cores() -- synchronize cores for userspace patching
+ *
+ * This function provides the core synchronization operation
+ * so that userspace can do int3 breakpoint patching.
+ *
+ * Everything else can be handled in userspace.
+ */
+SYSCALL_DEFINE0(sync_cores)
+{
+	on_each_cpu(do_sync_core, NULL, 1);
+
+	return 0;
+}
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index aabfb8380a1c..acfdfe2b95e7 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -357,3 +357,4 @@
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
 350	i386	finit_module		sys_finit_module
+351	i386	sync_cores		sys_sync_cores
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 38ae65dfd14f..6556f1e6e920 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -320,6 +320,7 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
+314	common	sync_cores		sys_sync_cores
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
1.8.3.1


--------------060806090303080802050708--
