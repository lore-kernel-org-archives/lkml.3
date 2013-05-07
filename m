Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab3EGSLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 14:11:23 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52935 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab3EGSLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 14:11:20 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org
Cc: Jiang Liu <liuj97@gmail.com>, eunb.song@samsung.com,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v2] MIPS: Make virt_to_phys() work for all unmapped addresses.
Date: Tue,  7 May 2013 11:11:16 -0700
Message-Id: <1367950276-7455-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

As reported:
  This problem was discovered when doing BGP traffic with the TCP MD5 option
  activated, where the following call chain caused a crash:

   * tcp_v4_rcv
   *  tcp_v4_timewait_ack
   *   tcp_v4_send_ack -> follow stack variable rep.th
   *    tcp_v4_md5_hash_hdr
   *     tcp_md5_hash_header
   *      sg_init_one
   *       sg_set_buf
   *        virt_to_page

  I noticed that tcp_v4_send_reset uses a similar stack variable and
  also calls tcp_v4_md5_hash_hdr, so it has the same problem.

The networking core can indirectly call virt_to_phys() on stack
addresses, if this is done from PID 0, the stack will usually be in
CKSEG0, so virt_to_phys() needs to work there as well

Signed-off-by: David Daney <david.daney@cavium.com>
---

This one appears to build against Linus' tree.

This could also fix problems noted by Eunbong Song with the
free_initmem_default() call.

 arch/mips/include/asm/io.h   | 2 +-
 arch/mips/include/asm/page.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/io.h b/arch/mips/include/asm/io.h
index 1be1372..b7e5985 100644
--- a/arch/mips/include/asm/io.h
+++ b/arch/mips/include/asm/io.h
@@ -118,7 +118,7 @@ static inline void set_io_port_base(unsigned long base)
  */
 static inline unsigned long virt_to_phys(volatile const void *address)
 {
-	return (unsigned long)address - PAGE_OFFSET + PHYS_OFFSET;
+	return __pa(address);
 }
 
 /*
diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index eab99e5..ec1ca53 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -46,7 +46,6 @@
 #endif /* CONFIG_MIPS_HUGE_TLB_SUPPORT */
 
 #include <linux/pfn.h>
-#include <asm/io.h>
 
 extern void build_clear_page(void);
 extern void build_copy_page(void);
@@ -151,6 +150,7 @@ typedef struct { unsigned long pgprot; } pgprot_t;
     ((unsigned long)(x) - PAGE_OFFSET + PHYS_OFFSET)
 #endif
 #define __va(x)		((void *)((unsigned long)(x) + PAGE_OFFSET - PHYS_OFFSET))
+#include <asm/io.h>
 
 /*
  * RELOC_HIDE was originally added by 6007b903dfe5f1d13e0c711ac2894bdd4a61b1ad
-- 
1.7.11.7

