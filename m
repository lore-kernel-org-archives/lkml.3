Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaJ1Dlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:41:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbaJ1Dl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:41:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Bob Picco <bob.picco@oracle.com>
Subject: [PATCH 3.17 140/146] sparc64: Increase MAX_PHYS_ADDRESS_BITS to 53.
Date: Tue, 28 Oct 2014 11:34:42 +0800
Message-Id: <20141028033349.529948894@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

Make sure, at compile time, that the kernel can properly support
whatever MAX_PHYS_ADDRESS_BITS is defined to.

On M7 chips, use a max_phys_bits value of 49.

Based upon a patch by Bob Picco.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/page_64.h    |    8 ++++----
 arch/sparc/include/asm/pgtable_64.h |    4 ++++
 arch/sparc/mm/init_64.c             |    9 ++++++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -122,11 +122,11 @@ extern unsigned long PAGE_OFFSET;
 
 #endif /* !(__ASSEMBLY__) */
 
-/* The maximum number of physical memory address bits we support, this
- * is used to size various tables used to manage kernel TLB misses and
- * also the sparsemem code.
+/* The maximum number of physical memory address bits we support.  The
+ * largest value we can support is whatever "KPGD_SHIFT + KPTE_BITS"
+ * evaluates to.
  */
-#define MAX_PHYS_ADDRESS_BITS	47
+#define MAX_PHYS_ADDRESS_BITS	53
 
 #define ILOG2_4MB		22
 #define ILOG2_256MB		28
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -67,6 +67,10 @@
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 #define PGDIR_BITS	(PAGE_SHIFT - 3)
 
+#if (MAX_PHYS_ADDRESS_BITS > PGDIR_SHIFT + PGDIR_BITS)
+#error MAX_PHYS_ADDRESS_BITS exceeds what kernel page tables can support
+#endif
+
 #if (PGDIR_SHIFT + PGDIR_BITS) != 53
 #error Page table parameters do not cover virtual address space properly.
 #endif
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1690,12 +1690,19 @@ static void __init setup_page_offset(voi
 		case SUN4V_CHIP_NIAGARA4:
 		case SUN4V_CHIP_NIAGARA5:
 		case SUN4V_CHIP_SPARC64X:
-		default:
+		case SUN4V_CHIP_SPARC_M6:
 			/* T4 and later support 52-bit virtual addresses.  */
 			sparc64_va_hole_top =    0xfff8000000000000UL;
 			sparc64_va_hole_bottom = 0x0008000000000000UL;
 			max_phys_bits = 47;
 			break;
+		case SUN4V_CHIP_SPARC_M7:
+		default:
+			/* M7 and later support 52-bit virtual addresses.  */
+			sparc64_va_hole_top =    0xfff8000000000000UL;
+			sparc64_va_hole_bottom = 0x0008000000000000UL;
+			max_phys_bits = 49;
+			break;
 		}
 	}
 


