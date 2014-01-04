Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaADAJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:09:10 -0500
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:57277 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753834AbaADAI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:08:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:2898:2914:3138:3139:3140:3141:3142:3352:3865:3868:4250:4321:4605:5007:6261:7904:10004:10026:10848:11026:11233:11473:11657:11658:11914:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: heart14_137bd43ff4246
X-Filterd-Recvd-Size: 2252
From: Joe Perches <joe@perches.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] efi: Fix krealloc defect
Date: Fri,  3 Jan 2014 16:08:47 -0800
Message-Id: <9a8eb1c9478049318e834d5223053a5fb7484bff.1388793978.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1388793978.git.joe@perches.com>
References: <cover.1388793978.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

krealloc should use a temporary pointer for allocations
and check the temporary pointer returned against NULL too.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/platform/efi/efi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cceb813..ef7b7b4 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -798,6 +798,8 @@ void __init efi_enter_virtual_mode(void)
 	}
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		void *new_memmap2;
+
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
 #ifdef CONFIG_X86_64
@@ -834,9 +836,13 @@ void __init efi_enter_virtual_mode(void)
 			systab += md->virt_addr - md->phys_addr;
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
-		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
-				      GFP_KERNEL);
+		new_memmap2 = krealloc(new_memmap,
+				       (count + 1) * memmap.desc_size,
+				       GFP_KERNEL);
+		if (!new_memmap2)
+			continue;
+
+		new_memmap = new_memmap2;
 		memcpy(new_memmap + (count * memmap.desc_size), md,
 		       memmap.desc_size);
 		count++;
-- 
1.8.1.2.459.gbcd45b4.dirty

