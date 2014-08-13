Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaHML1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:27:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:22309 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaHML1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:27:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,856,1400050800"; 
   d="scan'208";a="576054605"
Date: Wed, 13 Aug 2014 19:27:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: x86@kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix messed up page fault BUG messages
Message-ID: <20140813112724.GA6338@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 0day boot test robot hits messed up BUG lines like

[   25.732010] BUG: unable to handle kernel paging requestrun: /lkp/wfg/sr at 000000000000d908
[   24.986598] BUG: unable to handle kernel run: /lkp/wfg/srpaging request at 000000000000d908
[   24.914406] BUG: unable to handle kernel run: /lkp/wfg/srearly console in decompress_kernel

Which makes the generated bug ID not stable and hence not bisectable.

Fix it by printing the BUG message in one shot.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/x86/mm/fault.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3664279..f3e0e0a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -599,13 +599,13 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
 	}
 
-	printk(KERN_ALERT "BUG: unable to handle kernel ");
 	if (address < PAGE_SIZE)
-		printk(KERN_CONT "NULL pointer dereference");
+		printk(KERN_ALERT "BUG: unable to handle kernel NULL pointer dereference at %p\n",
+		       (void *) address);
 	else
-		printk(KERN_CONT "paging request");
+		printk(KERN_ALERT "BUG: unable to handle kernel NULL pointer paging request at %p\n",
+		       (void *) address);
 
-	printk(KERN_CONT " at %p\n", (void *) address);
 	printk(KERN_ALERT "IP:");
 	printk_address(regs->ip);
 
-- 
2.1.0.rc1

