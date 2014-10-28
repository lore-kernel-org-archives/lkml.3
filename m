Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaJ1LYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:24:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51465 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJ1LYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:24:46 -0400
Date: Tue, 28 Oct 2014 04:24:34 -0700
From: tip-bot for Minfei Huang <tipbot@zytor.com>
Message-ID: <tip-96e70f83285676d8794f62f3c294d0247bef6b21@git.kernel.org>
Cc: tglx@linutronix.de, mingo@kernel.org, torvalds@linux-foundation.org,
        mnfhuang@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@kernel.org, mnfhuang@gmail.com, torvalds@linux-foundation.org
In-Reply-To: <6B680A9E-6CE9-4C96-934B-CB01DCB58278@gmail.com>
References: <6B680A9E-6CE9-4C96-934B-CB01DCB58278@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Avoid overlap the fixmap area on i386
Git-Commit-ID: 96e70f83285676d8794f62f3c294d0247bef6b21
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96e70f83285676d8794f62f3c294d0247bef6b21
Gitweb:     http://git.kernel.org/tip/96e70f83285676d8794f62f3c294d0247bef6b21
Author:     Minfei Huang <mnfhuang@gmail.com>
AuthorDate: Thu, 23 Oct 2014 23:36:17 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 12:21:48 +0100

x86/mm: Avoid overlap the fixmap area on i386

It is a problem when configuring high memory off where the
vmalloc reserve area could end up overlapping the early_ioremap
fixmap area on i386.

The ordering of the VMALLOC_RESERVE space is:

 FIXADDR_TOP
                       fixed_addresses
 FIXADDR_START
                       early_ioremap fixed addresses
 FIXADDR_BOOT_START
                       Persistent kmap area
 PKMAP_BASE
 VMALLOC_END
                       Vmalloc area
 VMALLOC_START
 high_memory

The available address we can use is lower than
FIXADDR_BOOT_START. So we will set the kmap boundary below the
FIXADDR_BOOT_START, if we configure high memory.

If we configure high memory, the vmalloc reserve area should
end up to PKMAP_BASE, otherwise should end up to
FIXADDR_BOOT_START.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/6B680A9E-6CE9-4C96-934B-CB01DCB58278@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/pgtable_32_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
index ed5903b..2ac5fc8 100644
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -43,7 +43,7 @@ extern bool __vmalloc_start_set; /* set once high_memory is set */
 #ifdef CONFIG_HIGHMEM
 # define VMALLOC_END	(PKMAP_BASE - 2 * PAGE_SIZE)
 #else
-# define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
+# define VMALLOC_END	(FIXADDR_BOOT_START - 2 * PAGE_SIZE)
 #endif
 
 #define MODULES_VADDR	VMALLOC_START
