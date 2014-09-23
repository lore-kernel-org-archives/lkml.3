Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaIWRvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:51:21 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61531 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbaIWRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:51:17 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 4/8] x86,vdso: Make the PER_CPU segment start out accessed
Date: Tue, 23 Sep 2014 10:50:54 -0700
Message-Id: <ac63814ca4c637a08ec2fd0360d67ca67560a9ee.1411494540.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1411494540.git.luto@amacapital.net>
References: <cover.1411494540.git.luto@amacapital.net>
In-Reply-To: <cover.1411494540.git.luto@amacapital.net>
References: <cover.1411494540.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first userspace attempt to read or write the PER_CPU segment
will write the accessed bit to the GDT.  This is visible to
userspace using the LAR instruction, and it also pointlessly
dirties a cache line.

Set the segment's accessed bit at boot to prevent userspace
access to segments from having side effects.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 261b1349acc9..0c7997467be0 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -264,7 +264,7 @@ static void vsyscall_set_cpu(int cpu)
 	d = (struct desc_struct) {
 		.limit0 = cpu | ((node & 0xf) << 12),
 		.limit = node >> 4,
-		.type = 4,		/* RO data, expand down */
+		.type = 5,		/* RO data, expand down, accessed */
 		.dpl = 3,		/* Visible to user code */
 		.s = 1,			/* Not a system segment */
 		.p = 1,			/* Present */
-- 
1.9.3

