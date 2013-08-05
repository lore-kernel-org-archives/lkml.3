Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3HEWJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:09:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:60909 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab3HEWJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:09:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="342113666"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Use gcc alias instead of assembler aliases for syscalls
Date: Mon,  5 Aug 2013 15:09:35 -0700
Message-Id: <1375740575-7640-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use standard gcc __attribute__((alias(foo))) to define
the syscall aliases instead of custom assembler macros.

This is far cleaner, and also fixes my LTO kernel build.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/compat.h   | 4 ++--
 include/linux/syscalls.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 7f0c1dd..18e4b75 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -41,13 +41,13 @@
 	COMPAT_SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
 
 #define COMPAT_SYSCALL_DEFINEx(x, name, ...)				\
-	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
+	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))\
+		__attribute__((alias(__stringify(compat_SyS##name))));  \
 	static inline long C_SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
 	asmlinkage long compat_SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))\
 	{								\
 		return C_SYSC##name(__MAP(x,__SC_DELOUSE,__VA_ARGS__));	\
 	}								\
-	SYSCALL_ALIAS(compat_sys##name, compat_SyS##name);		\
 	static inline long C_SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
 #ifndef compat_user_stack_pointer
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4147d70..87039ad 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -184,7 +184,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
 #define __SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));	\
+	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
+		__attribute__((alias(__stringify(SyS##name))));		\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));	\
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
 	{								\
@@ -193,7 +194,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
 		return ret;						\
 	}								\
-	SYSCALL_ALIAS(sys##name, SyS##name);				\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
 asmlinkage long sys_time(time_t __user *tloc);
-- 
1.8.3.1

