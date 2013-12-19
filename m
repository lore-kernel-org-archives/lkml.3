Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3LSAgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:36:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3LSAgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:36:40 -0500
Date: Wed, 18 Dec 2013 16:36:25 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-rd908t9c8kvcojdabtmm94mb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, realmode: Pointer walk cleanups,
  pull out invariant use of __pa()
Git-Commit-ID: 7306006f103567fcf595d23dd741da0b8642f4c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 16:36:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7306006f103567fcf595d23dd741da0b8642f4c5
Gitweb:     http://git.kernel.org/tip/7306006f103567fcf595d23dd741da0b8642f4c5
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 18 Dec 2013 15:52:13 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 18 Dec 2013 16:07:53 -0800

x86, realmode: Pointer walk cleanups, pull out invariant use of __pa()

The pointer arithmetic in this function was really bizarre, where in
fact all we really wanted was a simple pointer array walk.  Use the
much more idiomatic construction for that (*ptr++).

Factor an invariant use of __pa() out of the relocation loop.  At
least on 64 bits it seems gcc isn't capable of doing that
automatically.

Change the scope of a couple of variables to make it extra obvious
that they are extremely local temp variables.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-rd908t9c8kvcojdabtmm94mb@git.kernel.org
---
 arch/x86/realmode/init.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index a44f457..bad628a 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -29,12 +29,10 @@ void __init reserve_real_mode(void)
 void __init setup_real_mode(void)
 {
 	u16 real_mode_seg;
-	u32 *rel;
+	const u32 *rel;
 	u32 count;
-	u32 *ptr;
-	u16 *seg;
-	int i;
 	unsigned char *base;
+	unsigned long phys_base;
 	struct trampoline_header *trampoline_header;
 	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
 #ifdef CONFIG_X86_64
@@ -46,23 +44,23 @@ void __init setup_real_mode(void)
 
 	memcpy(base, real_mode_blob, size);
 
-	real_mode_seg = __pa(base) >> 4;
+	phys_base = __pa(base);
+	real_mode_seg = phys_base >> 4;
+
 	rel = (u32 *) real_mode_relocs;
 
 	/* 16-bit segment relocations. */
-	count = rel[0];
-	rel = &rel[1];
-	for (i = 0; i < count; i++) {
-		seg = (u16 *) (base + rel[i]);
+	count = *rel++;
+	while (count--) {
+		u16 *seg = (u16 *) (base + *rel++);
 		*seg = real_mode_seg;
 	}
 
 	/* 32-bit linear relocations. */
-	count = rel[i];
-	rel =  &rel[i + 1];
-	for (i = 0; i < count; i++) {
-		ptr = (u32 *) (base + rel[i]);
-		*ptr += __pa(base);
+	count = *rel++;
+	while (count--) {
+		u32 *ptr = (u32 *) (base + *rel++);
+		*ptr += phys_base;
 	}
 
 	/* Must be perfomed *after* relocation. */
