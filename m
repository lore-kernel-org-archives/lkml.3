Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaJIVNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:13:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59752 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaJIVMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:12:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robin Murphy <robin.murphy@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 148/163] ARM: 8165/1: alignment: don't break misaligned NEON load/store
Date: Thu,  9 Oct 2014 14:02:53 -0700
Message-Id: <1412888588-26755-149-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 5ca918e5e3f9df4634077c06585c42bc6a8d699a upstream.

The alignment fixup incorrectly decodes faulting ARM VLDn/VSTn
instructions (where the optional alignment hint is given but incorrect)
as LDR/STR, leading to register corruption. Detect these and correctly
treat them as unhandled, so that userspace gets the fault it expects.

Reported-by: Simon Hosie <simon.hosie@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mm/alignment.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 9240364..d301662 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -40,6 +40,7 @@
  * This code is not portable to processors with late data abort handling.
  */
 #define CODING_BITS(i)	(i & 0x0e000000)
+#define COND_BITS(i)	(i & 0xf0000000)
 
 #define LDST_I_BIT(i)	(i & (1 << 26))		/* Immediate constant	*/
 #define LDST_P_BIT(i)	(i & (1 << 24))		/* Preindex		*/
@@ -817,6 +818,8 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 		break;
 
 	case 0x04000000:	/* ldr or str immediate */
+		if (COND_BITS(instr) == 0xf0000000) /* NEON VLDn, VSTn */
+			goto bad;
 		offset.un = OFFSET_BITS(instr);
 		handler = do_alignment_ldrstr;
 		break;
-- 
1.9.1

