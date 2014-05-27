Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaE0NKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:10:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:9066 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751748AbaE0NK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:10:29 -0400
Date: Tue, 27 May 2014 09:10:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [for-next][PATCH] ftrace: Make CALLER_ADDRx macros more generic
Message-ID: <20140527091019.54a8d2d6@gandalf.local.home>
In-Reply-To: <535E3040.7090402@linaro.org>
References: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
	<1394862353-28963-7-git-send-email-takahiro.akashi@linaro.org>
	<20140416135217.GF1001@arm.com>
	<535E3040.7090402@linaro.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

I made a separate branch called ftrace/arm64 as shown below. You can
pull that branch to base the rest of Akashi-san's patches on top of it.
The branch is based on top of v3.15-rc5.

-- Steve


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
ftrace/arm64

Head SHA1: eed542d6962ba33a689b4007a389f466e407bd74


AKASHI Takahiro (1):
      ftrace: Make CALLER_ADDRx macros more generic

----
 arch/arm/include/asm/ftrace.h      | 10 +---------
 arch/blackfin/include/asm/ftrace.h | 11 +----------
 arch/parisc/include/asm/ftrace.h   | 10 +---------
 arch/sh/include/asm/ftrace.h       | 10 +---------
 arch/xtensa/include/asm/ftrace.h   | 14 ++++----------
 include/linux/ftrace.h             | 34 ++++++++++++++++++----------------
 6 files changed, 26 insertions(+), 63 deletions(-)
---------------------------
commit eed542d6962ba33a689b4007a389f466e407bd74
Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
Date:   Tue May 20 20:31:04 2014 +0900

    ftrace: Make CALLER_ADDRx macros more generic
    
    Most archs with HAVE_ARCH_CALLER_ADDR have pretty much the same
    definitions of CALLER_ADDRx(n). Instead of duplicating the code for all
    the archs, define a ftrace_return_address0() and
    ftrace_return_address(n) that can be overwritten by the archs if they
    need to do something different. Instead of 7 macros in every arch, we
    now only have at most 2 (and actually only 1 as
    ftrace_return_address0() should be the same for all archs).
    
    The CALLER_ADDRx(n) will now be defined in linux/ftrace.h and use the
    ftrace_return_address*(n?) macros. This removes a lot of the duplicate
    code.
    
    Link: http://lkml.kernel.org/p/1400585464-30333-1-git-send-email-takahiro.akashi@linaro.org
    
    Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index f89515adac60..eb577f4f5f70 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -52,15 +52,7 @@ extern inline void *return_address(unsigned int level)
 
 #endif
 
-#define HAVE_ARCH_CALLER_ADDR
-
-#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#define CALLER_ADDR1 ((unsigned long)return_address(1))
-#define CALLER_ADDR2 ((unsigned long)return_address(2))
-#define CALLER_ADDR3 ((unsigned long)return_address(3))
-#define CALLER_ADDR4 ((unsigned long)return_address(4))
-#define CALLER_ADDR5 ((unsigned long)return_address(5))
-#define CALLER_ADDR6 ((unsigned long)return_address(6))
+#define ftrace_return_addr(n) return_address(n)
 
 #endif /* ifndef __ASSEMBLY__ */
 
diff --git a/arch/blackfin/include/asm/ftrace.h b/arch/blackfin/include/asm/ftrace.h
index 8a029505d7b7..2f1c3c2657ad 100644
--- a/arch/blackfin/include/asm/ftrace.h
+++ b/arch/blackfin/include/asm/ftrace.h
@@ -66,16 +66,7 @@ extern inline void *return_address(unsigned int level)
 
 #endif /* CONFIG_FRAME_POINTER */
 
-#define HAVE_ARCH_CALLER_ADDR
-
-/* inline function or macro may lead to unexpected result */
-#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#define CALLER_ADDR1 ((unsigned long)return_address(1))
-#define CALLER_ADDR2 ((unsigned long)return_address(2))
-#define CALLER_ADDR3 ((unsigned long)return_address(3))
-#define CALLER_ADDR4 ((unsigned long)return_address(4))
-#define CALLER_ADDR5 ((unsigned long)return_address(5))
-#define CALLER_ADDR6 ((unsigned long)return_address(6))
+#define ftrace_return_address(n) return_address(n)
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/parisc/include/asm/ftrace.h b/arch/parisc/include/asm/ftrace.h
index 72c0fafaa039..544ed8ef87eb 100644
--- a/arch/parisc/include/asm/ftrace.h
+++ b/arch/parisc/include/asm/ftrace.h
@@ -24,15 +24,7 @@ extern void return_to_handler(void);
 
 extern unsigned long return_address(unsigned int);
 
-#define HAVE_ARCH_CALLER_ADDR
-
-#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#define CALLER_ADDR1 return_address(1)
-#define CALLER_ADDR2 return_address(2)
-#define CALLER_ADDR3 return_address(3)
-#define CALLER_ADDR4 return_address(4)
-#define CALLER_ADDR5 return_address(5)
-#define CALLER_ADDR6 return_address(6)
+#define ftrace_return_address(n) return_address(n)
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/sh/include/asm/ftrace.h b/arch/sh/include/asm/ftrace.h
index 13e9966464c2..e79fb6ebaa42 100644
--- a/arch/sh/include/asm/ftrace.h
+++ b/arch/sh/include/asm/ftrace.h
@@ -40,15 +40,7 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 /* arch/sh/kernel/return_address.c */
 extern void *return_address(unsigned int);
 
-#define HAVE_ARCH_CALLER_ADDR
-
-#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#define CALLER_ADDR1 ((unsigned long)return_address(1))
-#define CALLER_ADDR2 ((unsigned long)return_address(2))
-#define CALLER_ADDR3 ((unsigned long)return_address(3))
-#define CALLER_ADDR4 ((unsigned long)return_address(4))
-#define CALLER_ADDR5 ((unsigned long)return_address(5))
-#define CALLER_ADDR6 ((unsigned long)return_address(6))
+#define ftrace_return_address(n) return_address(n)
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/xtensa/include/asm/ftrace.h b/arch/xtensa/include/asm/ftrace.h
index 736b9d214d80..6c6d9a9f185f 100644
--- a/arch/xtensa/include/asm/ftrace.h
+++ b/arch/xtensa/include/asm/ftrace.h
@@ -12,24 +12,18 @@
 
 #include <asm/processor.h>
 
-#define HAVE_ARCH_CALLER_ADDR
 #ifndef __ASSEMBLY__
-#define CALLER_ADDR0 ({ unsigned long a0, a1; \
+#define ftrace_return_address0 ({ unsigned long a0, a1; \
 		__asm__ __volatile__ ( \
 			"mov %0, a0\n" \
 			"mov %1, a1\n" \
 			: "=r"(a0), "=r"(a1)); \
 		MAKE_PC_FROM_RA(a0, a1); })
+
 #ifdef CONFIG_FRAME_POINTER
 extern unsigned long return_address(unsigned level);
-#define CALLER_ADDR1 return_address(1)
-#define CALLER_ADDR2 return_address(2)
-#define CALLER_ADDR3 return_address(3)
-#else /* CONFIG_FRAME_POINTER */
-#define CALLER_ADDR1 (0)
-#define CALLER_ADDR2 (0)
-#define CALLER_ADDR3 (0)
-#endif /* CONFIG_FRAME_POINTER */
+#define ftrace_return_address(n) return_address(n)
+#endif
 #endif /* __ASSEMBLY__ */
 
 #ifdef CONFIG_FUNCTION_TRACER
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ae9504b4b67d..2018751cad9e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -616,25 +616,27 @@ static inline void __ftrace_enabled_restore(int enabled)
 #endif
 }
 
-#ifndef HAVE_ARCH_CALLER_ADDR
+/* All archs should have this, but we define it for consistency */
+#ifndef ftrace_return_address0
+# define ftrace_return_address0 __builtin_return_address(0)
+#endif
+
+/* Archs may use other ways for ADDR1 and beyond */
+#ifndef ftrace_return_address
 # ifdef CONFIG_FRAME_POINTER
-#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#  define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
-#  define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
-#  define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
-#  define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
-#  define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
-#  define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
+#  define ftrace_return_address(n) __builtin_return_address(n)
 # else
-#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#  define CALLER_ADDR1 0UL
-#  define CALLER_ADDR2 0UL
-#  define CALLER_ADDR3 0UL
-#  define CALLER_ADDR4 0UL
-#  define CALLER_ADDR5 0UL
-#  define CALLER_ADDR6 0UL
+#  define ftrace_return_address(n) 0UL
 # endif
-#endif /* ifndef HAVE_ARCH_CALLER_ADDR */
+#endif
+
+#define CALLER_ADDR0 ((unsigned long)ftrace_return_address0)
+#define CALLER_ADDR1 ((unsigned long)ftrace_return_address(1))
+#define CALLER_ADDR2 ((unsigned long)ftrace_return_address(2))
+#define CALLER_ADDR3 ((unsigned long)ftrace_return_address(3))
+#define CALLER_ADDR4 ((unsigned long)ftrace_return_address(4))
+#define CALLER_ADDR5 ((unsigned long)ftrace_return_address(5))
+#define CALLER_ADDR6 ((unsigned long)ftrace_return_address(6))
 
 #ifdef CONFIG_IRQSOFF_TRACER
   extern void time_hardirqs_on(unsigned long a0, unsigned long a1);

