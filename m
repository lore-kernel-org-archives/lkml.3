Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3KLCQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:16:28 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:22205 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3KLCQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:16:12 -0500
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        penberg@kernel.org, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, jerry.hoemann@hp.com
Subject: [PATCH 2/3] x86: avoid efi_reserve_boot_services
Date: Mon, 11 Nov 2013 19:15:57 -0700
Message-Id: <1384222558-38527-3-git-send-email-jerry.hoemann@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platform have firmware that violate UEFI spec and access boot service
code or data segments after the system has called Exit Boot Services.

The call to efi_reserve_boot_services is a work around to avoid using
boot service memory until after the kernel has done Set Virtual Map.

However, this reservation fragments memory which can cause
large allocations early in boot (e.g. crash kernel) to fail.

Avoid calling efi_reserve_boot_services if the memmap
is "correct."

Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
---
 arch/x86/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..1186ff9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1074,7 +1074,7 @@ void __init setup_arch(char **cmdline_p)
 	 * The EFI specification says that boot service code won't be called
 	 * after ExitBootServices(). This is, in fact, a lie.
 	 */
-	if (efi_enabled(EFI_MEMMAP))
+	if (efi_enabled(EFI_MEMMAP) && !efi_enabled(EFI_MEMMAP_CORRECT))
 		efi_reserve_boot_services();
 
 	/* preallocate 4k for mptable mpc */
-- 
1.7.11.3

