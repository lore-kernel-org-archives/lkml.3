Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3AaWhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:37:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45016 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3AaWhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:37:12 -0500
Date: Thu, 31 Jan 2013 14:37:01 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-cd745be89e1580e8a1b47454a39f97f9c5c4b1e0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1356075872-3054-12-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-12-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/mm/init.c:
  Copy ucode from initrd image to kernel memory
Git-Commit-ID: cd745be89e1580e8a1b47454a39f97f9c5c4b1e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:37:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd745be89e1580e8a1b47454a39f97f9c5c4b1e0
Gitweb:     http://git.kernel.org/tip/cd745be89e1580e8a1b47454a39f97f9c5c4b1e0
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 20 Dec 2012 23:44:31 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 13:20:26 -0800

x86/mm/init.c: Copy ucode from initrd image to kernel memory

Before initrd image is freed, copy valid ucode patches from initrd image
to kernel memory. The saved ucode will be used to update AP in resume
or hotplug.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1356075872-3054-12-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d418152..4903a03 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -16,6 +16,7 @@
 #include <asm/tlb.h>
 #include <asm/proto.h>
 #include <asm/dma.h>		/* for MAX_DMA_PFN */
+#include <asm/microcode.h>
 
 #include "mm_internal.h"
 
@@ -534,6 +535,15 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
+#ifdef CONFIG_MICROCODE_EARLY
+	/*
+	 * Remember, initrd memory may contain microcode or other useful things.
+	 * Before we lose initrd mem, we need to find a place to hold them
+	 * now that normal virtual memory is enabled.
+	 */
+	save_microcode_in_initrd();
+#endif
+
 	/*
 	 * end could be not aligned, and We can not align that,
 	 * decompresser could be confused by aligned initrd_end
