Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbbAONNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:13:05 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:17930 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbbAONNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:13:01 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH v3 08/15] MIPS: OCTEON: Add little-endian support to asm/octeon/octeon.h
Date: Thu, 15 Jan 2015 16:11:12 +0300
Message-ID: <1421327487-28679-9-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
References: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Also update union octeon_cvmemctl with new OCTEON II fields.

Signed-off-by: David Daney <david.daney@cavium.com>
[aleksey.makarov@auriga.com: use __BITFIELD_FIELD]
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 arch/mips/include/asm/octeon/octeon.h | 135 ++++++++++++++++++++++++++--------
 1 file changed, 105 insertions(+), 30 deletions(-)

diff --git a/arch/mips/include/asm/octeon/octeon.h b/arch/mips/include/asm/octeon/octeon.h
index 3e505a2..ba5df50 100644
--- a/arch/mips/include/asm/octeon/octeon.h
+++ b/arch/mips/include/asm/octeon/octeon.h
@@ -9,6 +9,7 @@
 #define __ASM_OCTEON_OCTEON_H
 
 #include <asm/octeon/cvmx.h>
+#include <asm/bitfield.h>
 
 extern uint64_t octeon_bootmem_alloc_range_phys(uint64_t size,
 						uint64_t alignment,
@@ -58,6 +59,7 @@ extern void octeon_io_clk_delay(unsigned long);
 #define OCTOEN_SERIAL_LEN	20
 
 struct octeon_boot_descriptor {
+#ifdef __BIG_ENDIAN_BITFIELD
 	/* Start of block referenced by assembly code - do not change! */
 	uint32_t desc_version;
 	uint32_t desc_size;
@@ -109,77 +111,149 @@ struct octeon_boot_descriptor {
 	uint8_t mac_addr_base[6];
 	uint8_t mac_addr_count;
 	uint64_t cvmx_desc_vaddr;
+#else
+	uint32_t desc_size;
+	uint32_t desc_version;
+	uint64_t stack_top;
+	uint64_t heap_base;
+	uint64_t heap_end;
+	/* Only used by bootloader */
+	uint64_t entry_point;
+	uint64_t desc_vaddr;
+	/* End of This block referenced by assembly code - do not change! */
+	uint32_t stack_size;
+	uint32_t exception_base_addr;
+	uint32_t argc;
+	uint32_t heap_size;
+	/*
+	 * Argc count for application.
+	 * Warning low bit scrambled in little-endian.
+	 */
+	uint32_t argv[OCTEON_ARGV_MAX_ARGS];
+
+#define  BOOT_FLAG_INIT_CORE		(1 << 0)
+#define  OCTEON_BL_FLAG_DEBUG		(1 << 1)
+#define  OCTEON_BL_FLAG_NO_MAGIC	(1 << 2)
+	/* If set, use uart1 for console */
+#define  OCTEON_BL_FLAG_CONSOLE_UART1	(1 << 3)
+	/* If set, use PCI console */
+#define  OCTEON_BL_FLAG_CONSOLE_PCI	(1 << 4)
+	/* Call exit on break on serial port */
+#define  OCTEON_BL_FLAG_BREAK		(1 << 5)
+
+	uint32_t core_mask;
+	uint32_t flags;
+	/* physical address of free memory descriptor block. */
+	uint32_t phy_mem_desc_addr;
+	/* DRAM size in megabyes. */
+	uint32_t dram_size;
+	/* CPU clock speed, in hz. */
+	uint32_t eclock_hz;
+	/* used to pass flags from app to debugger. */
+	uint32_t debugger_flags_base_addr;
+	/* SPI4 clock in hz. */
+	uint32_t spi_clock_hz;
+	/* DRAM clock speed, in hz. */
+	uint32_t dclock_hz;
+	uint8_t chip_rev_minor;
+	uint8_t chip_rev_major;
+	uint16_t chip_type;
+	uint8_t board_rev_minor;
+	uint8_t board_rev_major;
+	uint16_t board_type;
+
+	uint64_t unused1[4]; /* Not even filled in by bootloader. */
+
+	uint64_t cvmx_desc_vaddr;
+#endif
 };
 
 union octeon_cvmemctl {
 	uint64_t u64;
 	struct {
 		/* RO 1 = BIST fail, 0 = BIST pass */
-		uint64_t tlbbist:1;
+		__BITFIELD_FIELD(uint64_t tlbbist:1,
 		/* RO 1 = BIST fail, 0 = BIST pass */
-		uint64_t l1cbist:1;
+		__BITFIELD_FIELD(uint64_t l1cbist:1,
 		/* RO 1 = BIST fail, 0 = BIST pass */
-		uint64_t l1dbist:1;
+		__BITFIELD_FIELD(uint64_t l1dbist:1,
 		/* RO 1 = BIST fail, 0 = BIST pass */
-		uint64_t dcmbist:1;
+		__BITFIELD_FIELD(uint64_t dcmbist:1,
 		/* RO 1 = BIST fail, 0 = BIST pass */
-		uint64_t ptgbist:1;
+		__BITFIELD_FIELD(uint64_t ptgbist:1,
 		/* RO 1 = BIST fail, 0 = BIST pass */
-		uint64_t wbfbist:1;
+		__BITFIELD_FIELD(uint64_t wbfbist:1,
 		/* Reserved */
-		uint64_t reserved:22;
+		__BITFIELD_FIELD(uint64_t reserved:17,
+		/* OCTEON II - TLB replacement policy: 0 = bitmask LRU; 1 = NLU.
+		 * This field selects between the TLB replacement policies:
+		 * bitmask LRU or NLU. Bitmask LRU maintains a mask of
+		 * recently used TLB entries and avoids them as new entries
+		 * are allocated. NLU simply guarantees that the next
+		 * allocation is not the last used TLB entry. */
+		__BITFIELD_FIELD(uint64_t tlbnlu:1,
+		/* OCTEON II - Selects the bit in the counter used for
+		 * releasing a PAUSE. This counter trips every 2(8+PAUSETIME)
+		 * cycles. If not already released, the cnMIPS II core will
+		 * always release a given PAUSE instruction within
+		 * 2(8+PAUSETIME). If the counter trip happens to line up,
+		 * the cnMIPS II core may release the PAUSE instantly. */
+		__BITFIELD_FIELD(uint64_t pausetime:3,
+		/* OCTEON II - This field is an extension of
+		 * CvmMemCtl[DIDTTO] */
+		__BITFIELD_FIELD(uint64_t didtto2:1,
 		/* R/W If set, marked write-buffer entries time out
 		 * the same as as other entries; if clear, marked
 		 * write-buffer entries use the maximum timeout. */
-		uint64_t dismarkwblongto:1;
+		__BITFIELD_FIELD(uint64_t dismarkwblongto:1,
 		/* R/W If set, a merged store does not clear the
 		 * write-buffer entry timeout state. */
-		uint64_t dismrgclrwbto:1;
+		__BITFIELD_FIELD(uint64_t dismrgclrwbto:1,
 		/* R/W Two bits that are the MSBs of the resultant
 		 * CVMSEG LM word location for an IOBDMA. The other 8
 		 * bits come from the SCRADDR field of the IOBDMA. */
-		uint64_t iobdmascrmsb:2;
+		__BITFIELD_FIELD(uint64_t iobdmascrmsb:2,
 		/* R/W If set, SYNCWS and SYNCS only order marked
 		 * stores; if clear, SYNCWS and SYNCS only order
 		 * unmarked stores. SYNCWSMARKED has no effect when
 		 * DISSYNCWS is set. */
-		uint64_t syncwsmarked:1;
+		__BITFIELD_FIELD(uint64_t syncwsmarked:1,
 		/* R/W If set, SYNCWS acts as SYNCW and SYNCS acts as
 		 * SYNC. */
-		uint64_t dissyncws:1;
+		__BITFIELD_FIELD(uint64_t dissyncws:1,
 		/* R/W If set, no stall happens on write buffer
 		 * full. */
-		uint64_t diswbfst:1;
+		__BITFIELD_FIELD(uint64_t diswbfst:1,
 		/* R/W If set (and SX set), supervisor-level
 		 * loads/stores can use XKPHYS addresses with
 		 * VA<48>==0 */
-		uint64_t xkmemenas:1;
+		__BITFIELD_FIELD(uint64_t xkmemenas:1,
 		/* R/W If set (and UX set), user-level loads/stores
 		 * can use XKPHYS addresses with VA<48>==0 */
-		uint64_t xkmemenau:1;
+		__BITFIELD_FIELD(uint64_t xkmemenau:1,
 		/* R/W If set (and SX set), supervisor-level
 		 * loads/stores can use XKPHYS addresses with
 		 * VA<48>==1 */
-		uint64_t xkioenas:1;
+		__BITFIELD_FIELD(uint64_t xkioenas:1,
 		/* R/W If set (and UX set), user-level loads/stores
 		 * can use XKPHYS addresses with VA<48>==1 */
-		uint64_t xkioenau:1;
+		__BITFIELD_FIELD(uint64_t xkioenau:1,
 		/* R/W If set, all stores act as SYNCW (NOMERGE must
 		 * be set when this is set) RW, reset to 0. */
-		uint64_t allsyncw:1;
+		__BITFIELD_FIELD(uint64_t allsyncw:1,
 		/* R/W If set, no stores merge, and all stores reach
 		 * the coherent bus in order. */
-		uint64_t nomerge:1;
+		__BITFIELD_FIELD(uint64_t nomerge:1,
 		/* R/W Selects the bit in the counter used for DID
 		 * time-outs 0 = 231, 1 = 230, 2 = 229, 3 =
 		 * 214. Actual time-out is between 1x and 2x this
 		 * interval. For example, with DIDTTO=3, expiration
 		 * interval is between 16K and 32K. */
-		uint64_t didtto:2;
+		__BITFIELD_FIELD(uint64_t didtto:2,
 		/* R/W If set, the (mem) CSR clock never turns off. */
-		uint64_t csrckalwys:1;
+		__BITFIELD_FIELD(uint64_t csrckalwys:1,
 		/* R/W If set, mclk never turns off. */
-		uint64_t mclkalwys:1;
+		__BITFIELD_FIELD(uint64_t mclkalwys:1,
 		/* R/W Selects the bit in the counter used for write
 		 * buffer flush time-outs (WBFLT+11) is the bit
 		 * position in an internal counter used to determine
@@ -187,25 +261,26 @@ union octeon_cvmemctl {
 		 * 2x this interval. For example, with WBFLT = 0, a
 		 * write buffer expires between 2K and 4K cycles after
 		 * the write buffer entry is allocated. */
-		uint64_t wbfltime:3;
+		__BITFIELD_FIELD(uint64_t wbfltime:3,
 		/* R/W If set, do not put Istream in the L2 cache. */
-		uint64_t istrnol2:1;
+		__BITFIELD_FIELD(uint64_t istrnol2:1,
 		/* R/W The write buffer threshold. */
-		uint64_t wbthresh:4;
+		__BITFIELD_FIELD(uint64_t wbthresh:4,
 		/* Reserved */
-		uint64_t reserved2:2;
+		__BITFIELD_FIELD(uint64_t reserved2:2,
 		/* R/W If set, CVMSEG is available for loads/stores in
 		 * kernel/debug mode. */
-		uint64_t cvmsegenak:1;
+		__BITFIELD_FIELD(uint64_t cvmsegenak:1,
 		/* R/W If set, CVMSEG is available for loads/stores in
 		 * supervisor mode. */
-		uint64_t cvmsegenas:1;
+		__BITFIELD_FIELD(uint64_t cvmsegenas:1,
 		/* R/W If set, CVMSEG is available for loads/stores in
 		 * user mode. */
-		uint64_t cvmsegenau:1;
+		__BITFIELD_FIELD(uint64_t cvmsegenau:1,
 		/* R/W Size of local memory in cache blocks, 54 (6912
 		 * bytes) is max legal value. */
-		uint64_t lmemsz:6;
+		__BITFIELD_FIELD(uint64_t lmemsz:6,
+		;)))))))))))))))))))))))))))))))))
 	} s;
 };
 
-- 
2.2.2

