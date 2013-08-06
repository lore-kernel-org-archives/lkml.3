Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3HFS4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:56:51 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:60396 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755765Ab3HFS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:56:50 -0400
Date: Tue, 6 Aug 2013 18:56:49 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: x86: use this_cpu for debug_stack_usage
In-Reply-To: <1375811455.25420.39.camel@gandalf.local.home>
Message-ID: <0000014054fd1db5-e6fbcc32-2e6c-49b1-83d4-399791ee6829-000000@email.amazonses.com>
References: <000001405493dacb-4d662921-2531-400a-a426-4f76c8066ede-000000@email.amazonses.com> <1375811455.25420.39.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.06-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Might as well change is_debug_stack() to use __this_cpu_read() instead
> of __get_cpu_var().





Subject: x86: use this_cpu for debug_stack_usage

Reduces overhead a bit and frees up a couple of registers.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/x86/include/asm/debugreg.h
===================================================================
--- linux.orig/arch/x86/include/asm/debugreg.h	2013-08-06 13:52:23.740092873 -0500
+++ linux/arch/x86/include/asm/debugreg.h	2013-08-06 13:52:23.740092873 -0500
@@ -97,11 +97,11 @@ extern void hw_breakpoint_restore(void);
 DECLARE_PER_CPU(int, debug_stack_usage);
 static inline void debug_stack_usage_inc(void)
 {
-	__get_cpu_var(debug_stack_usage)++;
+	__this_cpu_inc(debug_stack_usage);
 }
 static inline void debug_stack_usage_dec(void)
 {
-	__get_cpu_var(debug_stack_usage)--;
+	__this_cpu_dec(debug_stack_usage);
 }
 int is_debug_stack(unsigned long addr);
 void debug_stack_set_zero(void);
Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c	2013-07-19 09:06:36.850047837 -0500
+++ linux/arch/x86/kernel/cpu/common.c	2013-08-06 13:54:36.426384889 -0500
@@ -1144,9 +1144,9 @@ DEFINE_PER_CPU(int, debug_stack_usage);

 int is_debug_stack(unsigned long addr)
 {
-	return __get_cpu_var(debug_stack_usage) ||
-		(addr <= __get_cpu_var(debug_stack_addr) &&
-		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
+	return __this_cpu_read(debug_stack_usage) ||
+		(addr <= __this_cpu_read(debug_stack_addr) &&
+		 addr > (__this_cpu_read(debug_stack_addr) - DEBUG_STKSZ));
 }

 DEFINE_PER_CPU(u32, debug_idt_ctr);
