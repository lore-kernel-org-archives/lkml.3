Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3JXDvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 23:51:14 -0400
Received: from intranet.asianux.com ([58.214.24.6]:25259 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3JXDvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 23:51:13 -0400
X-Spam-Score: -100.8
Message-ID: <526898F1.7010609@asianux.com>
Date: Thu, 24 Oct 2013 11:50:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>, jason.wessel@windriver.com,
        mjonker@synopsys.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: kernel: kgdb: add default implementation for kgdb_roundup_cpus()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arc supports kgdb, but need update -- add function kgdb_roundup_cpus(),
or can not pass compiling. At present, add the simple generic one just
like other architectures(e.g. tile, mips ...).

The related error (with allmodconfig):

  kernel/built-in.o: In function `kgdb_cpu_enter':
  kernel/debug/debug_core.c:580: undefined reference to `kgdb_roundup_cpus'


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/kernel/kgdb.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arc/kernel/kgdb.c b/arch/arc/kernel/kgdb.c
index a7698fb..a2ff5c5 100644
--- a/arch/arc/kernel/kgdb.c
+++ b/arch/arc/kernel/kgdb.c
@@ -196,6 +196,18 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 	instruction_pointer(regs) = ip;
 }
 
+static void kgdb_call_nmi_hook(void *ignored)
+{
+	kgdb_nmicallback(raw_smp_processor_id(), NULL);
+}
+
+void kgdb_roundup_cpus(unsigned long flags)
+{
+	local_irq_enable();
+	smp_call_function(kgdb_call_nmi_hook, NULL, 0);
+	local_irq_disable();
+}
+
 struct kgdb_arch arch_kgdb_ops = {
 	/* breakpoint instruction: TRAP_S 0x3 */
 #ifdef CONFIG_CPU_BIG_ENDIAN
-- 
1.7.7.6
