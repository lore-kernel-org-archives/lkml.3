Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab3AXUWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:22:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49970 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030228Ab3AXUVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:21:17 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 08/35] x86, 64bit: Copy zero-page early
Date: Thu, 24 Jan 2013 12:19:49 -0800
Message-Id: <1359058816-7615-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

real mode data/boot_params aka zero-page could be above 4g.
We will have #PF handler to set page table for not accessible ram
early, but want to limit it before x86_64_start_reservations to limit
the code change to native path only.

Also we will need the ramdisk info in zero-page to access the microcode
blob in ramdisk in x86_64_start_kernel, so copy zero-page early makes
it accessing ramdisk info simple.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/head64.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 7b215a5..c0a25e0 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -87,6 +87,8 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	}
 	load_idt((const struct desc_ptr *)&idt_descr);
 
+	copy_bootdata(__va(real_mode_data));
+
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
@@ -95,7 +97,9 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
-	copy_bootdata(__va(real_mode_data));
+	/* version is always not zero if it is copied */
+	if (!boot_params.hdr.version)
+		copy_bootdata(__va(real_mode_data));
 
 	memblock_reserve(__pa_symbol(_text),
 			 (unsigned long)__bss_stop - (unsigned long)_text);
-- 
1.7.10.4

