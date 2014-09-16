Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaIPCdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:33:37 -0400
Received: from mail-bn1on0113.outbound.protection.outlook.com ([157.56.110.113]:5376
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752716AbaIPCdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:33:36 -0400
X-WSS-ID: 0NBZ33P-08-TT4-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-apci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <astone@redhat.com>,
        <hanjun.guo@linaro.org>, <rjw@rjwysocki.net>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <Sudeep.Holla@arm.com>, <olof@lixom.net>,
        <grant.likely@linaro.org>, <graeme.gregory@linaro.org>,
        <arnd@arndb.de>, <jason@lakedaemon.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/4] arm64/efi: efistub: don't abort if base of DRAM is occupied
Date: Mon, 15 Sep 2014 19:47:24 -0500
Message-ID: <1410828446-28502-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(97736003)(31966008)(83322001)(105586002)(86152002)(4396001)(20776003)(33646002)(106466001)(107046002)(53416004)(83072002)(36756003)(95666004)(89996001)(84676001)(92726001)(90102001)(77096002)(44976005)(87286001)(87936001)(68736004)(85306004)(76482001)(62966002)(19580395003)(86362001)(76176999)(229853001)(93916002)(102836001)(104166001)(77156001)(21056001)(101416001)(48376002)(47776003)(2201001)(99396002)(88136002)(19580405001)(50986999)(92566001)(50226001)(81342003)(74662003)(81542003)(74502003)(80022003)(79102003)(77982003)(46102003)(85852003)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR02MB484;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

If we cannot relocate the kernel Image to its preferred offset of base of DRAM
plus TEXT_OFFSET, instead relocate it to the lowest available 2 MB boundary plus
TEXT_OFFSET. We may lose a bit of memory at the low end, but we can still
proceed normally otherwise.

Acked-by: Mark Salter <msalter@redhat.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
Tested-by: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kernel/efi-stub.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 1317fef..d27dd98 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -28,20 +28,16 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 	kernel_size = _edata - _text;
 	if (*image_addr != (dram_base + TEXT_OFFSET)) {
 		kernel_memsize = kernel_size + (_end - _edata);
-		status = efi_relocate_kernel(sys_table, image_addr,
-					     kernel_size, kernel_memsize,
-					     dram_base + TEXT_OFFSET,
-					     PAGE_SIZE);
+		status = efi_low_alloc(sys_table, kernel_memsize + TEXT_OFFSET,
+				       SZ_2M, reserve_addr);
 		if (status != EFI_SUCCESS) {
 			pr_efi_err(sys_table, "Failed to relocate kernel\n");
 			return status;
 		}
-		if (*image_addr != (dram_base + TEXT_OFFSET)) {
-			pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
-			efi_free(sys_table, kernel_memsize, *image_addr);
-			return EFI_LOAD_ERROR;
-		}
-		*image_size = kernel_memsize;
+		memcpy((void *)*reserve_addr + TEXT_OFFSET, (void *)*image_addr,
+		       kernel_size);
+		*image_addr = *reserve_addr + TEXT_OFFSET;
+		*reserve_size = kernel_memsize + TEXT_OFFSET;
 	}
 
 
-- 
1.9.3

