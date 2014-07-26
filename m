Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbaGZBNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 21:13:20 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40610 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaGZBNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 21:13:10 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/3] x86,vdso: Change the PER_CPU segment to use struct desc_struct
Date: Fri, 25 Jul 2014 18:12:59 -0700
Message-Id: <066c1ca913eb96f6324e8558f321e6f5b010d0d3.1406336986.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1406336986.git.luto@amacapital.net>
References: <cover.1406336986.git.luto@amacapital.net>
In-Reply-To: <cover.1406336986.git.luto@amacapital.net>
References: <cover.1406336986.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it easier to see what's going on.  It produces exactly
the same segment descriptor as the old code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/vsyscall_64.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index e1e1e80..158cdff 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -289,7 +289,7 @@ sigsegv:
  */
 static void vsyscall_set_cpu(int cpu)
 {
-	unsigned long d;
+	struct desc_struct d;
 	unsigned long node = 0;
 #ifdef CONFIG_NUMA
 	node = cpu_to_node(cpu);
@@ -298,13 +298,17 @@ static void vsyscall_set_cpu(int cpu)
 		write_rdtscp_aux((node << 12) | cpu);
 
 	/*
-	 * Store cpu number in limit so that it can be loaded quickly
-	 * in user space in vgetcpu. (12 bits for the CPU and 8 bits for the node)
+	 * Store cpu number in limit so that it can be loaded
+	 * quickly in user space in vgetcpu. (12 bits for the CPU
+	 * and 8 bits for the node)
 	 */
-	d = 0x0f40000000000ULL;
-	d |= cpu;
-	d |= (node & 0xf) << 12;
-	d |= (node >> 4) << 48;
+	memset(&d, 0, sizeof(d));
+	d.limit0 = cpu | ((node & 0xf) << 12);
+	d.limit = node >> 4;
+	d.type = 4;		/* RO data, expand down */
+	d.dpl = 3;		/* Visible to user code */
+	d.s = 1;		/* Non a system segment */
+	d.p = 1;		/* Present */
 
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
-- 
1.9.3

