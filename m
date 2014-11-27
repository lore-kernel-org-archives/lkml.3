Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaK0Ite (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:49:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:42492 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbaK0It3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:29 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 69/91] ARM: 8165/1: alignment: don't break misaligned NEON load/store
Date: Thu, 27 Nov 2014 16:42:52 +0800
Message-Id: <1417077794-9299-69-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 5ca918e5e3f9df4634077c06585c42bc6a8d699a upstream.

The alignment fixup incorrectly decodes faulting ARM VLDn/VSTn
instructions (where the optional alignment hint is given but incorrect)
as LDR/STR, leading to register corruption. Detect these and correctly
treat them as unhandled, so that userspace gets the fault it expects.

Reported-by: Simon Hosie <simon.hosie@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/arm/mm/alignment.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index fc000e3..17f4ea2 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -39,6 +39,7 @@
  * This code is not portable to processors with late data abort handling.
  */
 #define CODING_BITS(i)	(i & 0x0e000000)
+#define COND_BITS(i)	(i & 0xf0000000)
 
 #define LDST_I_BIT(i)	(i & (1 << 26))		/* Immediate constant	*/
 #define LDST_P_BIT(i)	(i & (1 << 24))		/* Preindex		*/
@@ -813,6 +814,8 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 		break;
 
 	case 0x04000000:	/* ldr or str immediate */
+		if (COND_BITS(instr) == 0xf0000000) /* NEON VLDn, VSTn */
+			goto bad;
 		offset.un = OFFSET_BITS(instr);
 		handler = do_alignment_ldrstr;
 		break;
-- 
1.9.1

