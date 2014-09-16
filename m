Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaIPCd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:33:59 -0400
Received: from mail-by2on0127.outbound.protection.outlook.com ([207.46.100.127]:13440
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753907AbaIPCdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:33:38 -0400
X-WSS-ID: 0NBZ33W-07-F1R-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-apci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <astone@redhat.com>,
        <hanjun.guo@linaro.org>, <rjw@rjwysocki.net>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <Sudeep.Holla@arm.com>, <olof@lixom.net>,
        <grant.likely@linaro.org>, <graeme.gregory@linaro.org>,
        <arnd@arndb.de>, <jason@lakedaemon.net>,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 3/4] efi/arm64: fix fdt-related memory reservation
Date: Mon, 15 Sep 2014 19:47:25 -0500
Message-ID: <1410828446-28502-4-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(104166001)(99396002)(89996001)(62966002)(101416001)(20776003)(4396001)(85306004)(33646002)(85852003)(88136002)(105586002)(102836001)(47776003)(48376002)(46102003)(80022003)(74502003)(74662003)(79102003)(77982003)(53416004)(81342003)(84676001)(81542003)(87286001)(87936001)(92566001)(92726001)(44976005)(77156001)(77096002)(50226001)(21056001)(76482001)(2201001)(86152002)(31966008)(90102001)(76176999)(229853001)(36756003)(83072002)(86362001)(93916002)(50986999)(106466001)(83322001)(19580395003)(107046002)(97736003)(68736004)(19580405001)(95666004)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB490;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

Commit 86c8b27a01cf:
 "arm64: ignore DT memreserve entries when booting in UEFI mode

prevents early_init_fdt_scan_reserved_mem() from being called for
arm64 kernels booting via UEFI. This was done because the kernel
will use the UEFI memory map to determine reserved memory regions.
That approach has problems in that early_init_fdt_scan_reserved_mem()
also reserves the FDT itself and any node-specific reserved memory.
By chance of some kernel configs, the FDT may be overwritten before
it can be unflattened and the kernel will fail to boot. More subtle
problems will result if the FDT has node specific reserved memory
which is not really reserved.

This patch has the UEFI stub remove the memory reserve map entries
from the FDT as it does with the memory nodes. This allows
early_init_fdt_scan_reserved_mem() to be called unconditionally
so that the other needed reservations are made.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/mm/init.c               |  3 +--
 drivers/firmware/efi/libstub/fdt.c | 10 +++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 5472c24..a83061f 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -149,8 +149,7 @@ void __init arm64_memblock_init(void)
 		memblock_reserve(__virt_to_phys(initrd_start), initrd_end - initrd_start);
 #endif
 
-	if (!efi_enabled(EFI_MEMMAP))
-		early_init_fdt_scan_reserved_mem();
+	early_init_fdt_scan_reserved_mem();
 
 	/* 4GB maximum for 32-bit only capable devices */
 	if (IS_ENABLED(CONFIG_ZONE_DMA))
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index a56bb35..c846a96 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -22,7 +22,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 			unsigned long map_size, unsigned long desc_size,
 			u32 desc_ver)
 {
-	int node, prev;
+	int node, prev, num_rsv;
 	int status;
 	u32 fdt_val32;
 	u64 fdt_val64;
@@ -73,6 +73,14 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 		prev = node;
 	}
 
+	/*
+	 * Delete all memory reserve map entries. When booting via UEFI,
+	 * kernel will use the UEFI memory map to find reserved regions.
+	 */
+	num_rsv = fdt_num_mem_rsv(fdt);
+	while (num_rsv-- > 0)
+		fdt_del_mem_rsv(fdt, num_rsv);
+
 	node = fdt_subnode_offset(fdt, 0, "chosen");
 	if (node < 0) {
 		node = fdt_add_subnode(fdt, 0, "chosen");
-- 
1.9.3

