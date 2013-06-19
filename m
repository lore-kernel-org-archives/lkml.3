Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab3FSLpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:45:34 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58891 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab3FSLpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:45:33 -0400
Subject: [PATCH] sh/kprobes: Fix illslot handler not to unregister but disarm
 kprobe
To: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 19 Jun 2013 20:42:44 +0900
Message-ID: <20130619114244.19843.90351.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix illegal slot exception handler not to unregister the kprobe
but just to disarm it. Since the unregister_kprobe must sleep (by
synchronize_sched), it must not be called from any exception/
interrupt handlers. Disarming is safe because it just recovers
original instruction code.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 arch/sh/kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/kernel/kprobes.c b/arch/sh/kernel/kprobes.c
index 42b46e6..5ec8182 100644
--- a/arch/sh/kernel/kprobes.c
+++ b/arch/sh/kernel/kprobes.c
@@ -82,7 +82,7 @@ int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 
 /**
  * If an illegal slot instruction exception occurs for an address
- * containing a kprobe, remove the probe.
+ * containing a kprobe, disarm the probe.
  *
  * Returns 0 if the exception was handled successfully, 1 otherwise.
  */
@@ -93,7 +93,7 @@ int __kprobes kprobe_handle_illslot(unsigned long pc)
 	if (p != NULL) {
 		printk("Warning: removing kprobe from delay slot: 0x%.8x\n",
 		       (unsigned int)pc + 2);
-		unregister_kprobe(p);
+		arch_disarm_kprobe(p);
 		return 0;
 	}
 


