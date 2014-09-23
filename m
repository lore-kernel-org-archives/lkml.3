Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbaIWRwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:52:43 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41115 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbaIWRvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:51:14 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/8] x86,vdso: Change the PER_CPU segment to use struct desc_struct
Date: Tue, 23 Sep 2014 10:50:53 -0700
Message-Id: <d492f7b55136cbc60f016adae79160707b2e03b7.1411494540.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1411494540.git.luto@amacapital.net>
References: <cover.1411494540.git.luto@amacapital.net>
In-Reply-To: <cover.1411494540.git.luto@amacapital.net>
References: <cover.1411494540.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it easier to see what's going on.  It produces exactly
the same segment descriptor as the old code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vma.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index a155dca5edb5..261b1349acc9 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -248,7 +248,7 @@ __setup("vdso=", vdso_setup);
  */
 static void vsyscall_set_cpu(int cpu)
 {
-	unsigned long d;
+	struct desc_struct d;
 	unsigned long node = 0;
 #ifdef CONFIG_NUMA
 	node = cpu_to_node(cpu);
@@ -257,13 +257,18 @@ static void vsyscall_set_cpu(int cpu)
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
+	d = (struct desc_struct) {
+		.limit0 = cpu | ((node & 0xf) << 12),
+		.limit = node >> 4,
+		.type = 4,		/* RO data, expand down */
+		.dpl = 3,		/* Visible to user code */
+		.s = 1,			/* Not a system segment */
+		.p = 1,			/* Present */
+	};
 
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
-- 
1.9.3

