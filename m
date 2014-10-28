Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbaJ1LPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:15:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaJ1LPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:15:17 -0400
Date: Tue, 28 Oct 2014 04:15:06 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-258801563ba1be05793f2417ae30557b43a24e4e@git.kernel.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, luto@amacapital.net,
        mingo@kernel.org, hpa@zytor.com
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, luto@amacapital.net,
        mingo@kernel.org, tglx@linutronix.de
In-Reply-To: <d492f7b55136cbc60f016adae79160707b2e03b7.1411494540.git.luto@amacapital.net>
References: <d492f7b55136cbc60f016adae79160707b2e03b7.1411494540.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86/vdso:
  Change the PER_CPU segment to use struct desc_struct
Git-Commit-ID: 258801563ba1be05793f2417ae30557b43a24e4e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  258801563ba1be05793f2417ae30557b43a24e4e
Gitweb:     http://git.kernel.org/tip/258801563ba1be05793f2417ae30557b43a24e4e
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 23 Sep 2014 10:50:53 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:22:10 +0100

x86/vdso: Change the PER_CPU segment to use struct desc_struct

This makes it easier to see what's going on.  It produces
exactly the same segment descriptor as the old code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/d492f7b55136cbc60f016adae79160707b2e03b7.1411494540.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/vdso/vma.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index a155dca..261b134 100644
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
