Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaAGPsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:48:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56273 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaAGPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:48:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, sahara <keun-o.park@windriver.com>,
        Keun-O Park <kpark3469@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available for ARM_UNWIND
Date: Tue, 07 Jan 2014 16:48:25 +0100
Message-ID: <4325142.7drL5ndxN9@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140107144130.GJ27432@n2100.arm.linux.org.uk>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <201401071533.35309.arnd@arndb.de> <20140107144130.GJ27432@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VYU18J/I6ugaZq2c4v1LkQ214cZ6e/PJc0HFluDO4Ii
 cegSu0yyy+eIkmgMWxuQJRHwQCgDHk+LRQ13k/3oix9UppvSWO
 jyLzuXZTc9vDLZbP5F6H7T5RdlxH9anDvYxXqZwbAwTCAGKW4A
 VsbeSfEPREkv7sEdmAe0XpkqYOBoKh66mdf4W+GJcFXiE1nWQM
 4frSYLVe6PuMOQhhtdA8eUMQpZRZUmNmP1BoMxRJ25HPiCN81q
 AiGoTHEZB2Q/cKay7JJePN/mw9SNSnJxeCpIgtuom3z0c5f5p+
 0UzgLhF+x/3p5OB8NgQ4FwwMbBkCttzypWOVJB+8d3JnPKZ54Z
 Oge8VCIUzeKWgSYeeZnA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 January 2014 14:41:30 Russell King - ARM Linux wrote:
> On Tue, Jan 07, 2014 at 03:33:34PM +0100, Arnd Bergmann wrote:
> > 
> > 
> > It's been almost a year since we last discussed the patches that were
> > posted by Dave and sahara, but nothing has changed in the mainline kernel.
> > 
> > Any chance that someone could be motivated to pick this work up again
> > and finally fix return_address().
> 
> I thought that we had _actively_ decided that we would not use the
> unwinder for these paths - that it was too expensive for these paths,
> and you had to use frame pointers instead.

I don't remember that discussion, but it may well be. What does
that mean for the #warning in return_address.c then? Can we
just use the frame pointer version based on CONFIG_FRAME_POINTER
and ignore whether CONFIG_ARM_UNWIND is set as the patch below,
or did I misunderstand?

	Arnd

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index f89515a..3247370 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -32,7 +32,7 @@ extern void ftrace_call_old(void);
 
 #ifndef __ASSEMBLY__
 
-#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
+#if defined(CONFIG_FRAME_POINTER)
 /*
  * return_address uses walk_stackframe to do it's work.  If both
  * CONFIG_FRAME_POINTER=y and CONFIG_ARM_UNWIND=y walk_stackframe uses unwind
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index a30fc9b..c713f46 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -16,13 +16,14 @@ CFLAGS_REMOVE_return_address.o = -pg
 # Object file lists.
 
 obj-y		:= elf.o entry-common.o irq.o opcodes.o \
-		   process.o ptrace.o return_address.o \
+		   process.o ptrace.o \
 		   setup.o signal.o sigreturn_codes.o \
 		   stacktrace.o sys_arm.o time.o traps.o
 
 obj-$(CONFIG_ATAGS)		+= atags_parse.o
 obj-$(CONFIG_ATAGS_PROC)	+= atags_proc.o
 obj-$(CONFIG_DEPRECATED_PARAM_STRUCT) += atags_compat.o
+obj-$(CONFIG_FRAME_POINTER)	+= return_address.o
 
 ifeq ($(CONFIG_CPU_V7M),y)
 obj-y		+= entry-v7m.o v7m.o
diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
index fafedd8..d9f2c15 100644
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -10,8 +10,6 @@
  */
 #include <linux/export.h>
 #include <linux/ftrace.h>
-
-#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
 #include <linux/sched.h>
 
 #include <asm/stacktrace.h>
@@ -56,18 +54,4 @@ void *return_address(unsigned int level)
 	else
 		return NULL;
 }
-
-#else /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) */
-
-#if defined(CONFIG_ARM_UNWIND)
-#warning "TODO: return_address should use unwind tables"
-#endif
-
-void *return_address(unsigned int level)
-{
-	return NULL;
-}
-
-#endif /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) / else */
-
 EXPORT_SYMBOL_GPL(return_address);

