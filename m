Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3EVWKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:10:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab3EVWKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Anvin <hpa@linux.intel.com>,
        =?UTF-8?q?Fernando=20Luis=20V=C3=A1zquez=20Cao?= 
	<fernando@oss.ntt.co.jp>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 07/21] x86: Fix bit corruption at CPU resume time
Date: Wed, 22 May 2013 15:10:25 -0700
Message-Id: <20130522205233.510330591@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5e427ec2d066b48a5c27b3a5a3315f7e4e729077 upstream.

In commit 78d77df71510 ("x86-64, init: Do not set NX bits on non-NX
capable hardware") we added the early_pmd_flags that gets the NX bit set
when a CPU supports NX. However, the new variable was marked __initdata,
because the main _use_ of this is in an __init routine.

However, the bit setting happens from secondary_startup_64(), which is
called not only at bootup, but on every secondary CPU start.  Including
resuming from STR and at CPU hotplug time.  So the value cannot be
__initdata.

Reported-bisected-and-tested-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Peter Anvin <hpa@linux.intel.com>
Cc: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/head64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -34,7 +34,7 @@
 extern pgd_t early_level4_pgt[PTRS_PER_PGD];
 extern pmd_t early_dynamic_pgts[EARLY_DYNAMIC_PAGE_TABLES][PTRS_PER_PMD];
 static unsigned int __initdata next_early_pgt = 2;
-pmdval_t __initdata early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
+pmdval_t early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
 
 /* Wipe all early page tables except for the kernel symbol map */
 static void __init reset_early_page_tables(void)


