Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaCFOgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:36:15 -0500
Received: from lvk-gate.cs.msu.ru ([188.44.42.233]:53693 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082AbaCFOgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:36:13 -0500
X-Greylist: delayed 665 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 09:36:12 EST
X-Spam-ASN: 
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
To: kexec@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Hari Bathini <hbathini@linux.vnet.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, nyushchenko@dev.rtsoft.ru,
        lugovskoy@dev.rtsoft.ru, yadviga@dev.rtsoft.ru
Subject: [PATCH] kexec/powerpc: fix exporting memory limit
Date: Thu,  6 Mar 2014 18:24:14 +0400
Message-Id: <1394115854-11709-1-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When preparing dump-capturing kernel, kexec userspace tool needs to know
actual amount of memory used by the running kernel. This may differ from
extire available DRAM for a couple of reasons. To address this issue,
kdump kernel support code injects several attributes into device tree that
are later captured by userspace kexec tool via /proc interface.

One such attrubute is 'chosen/linux,memory_limit' that is used to pass
memory limit of the running kernel.

This was initialized using kernel's 'memory_limit' variable, that is set
by early init code based on mem= kernel parameter and other reasons.

But there are cases when memory_limit variable does not contain proper
information. One such case is when !CONFIG_HIGHMEM kernel runs on system
with memory large enough not to fit into lowmem.

This patch fixes initialization of 'chosen/linux,memory_limit' to use
values from memblock subsystem. These are adjusted at kernel memory
management init and thus always contain values that match reality.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 arch/powerpc/kernel/machine_kexec.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index 015ae55..372cda5 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -250,8 +250,14 @@ static void __init export_crashk_values(struct device_node *node)
 	/*
 	 * memory_limit is required by the kexec-tools to limit the
 	 * crash regions to the actual memory used.
+	 *
+	 * There are cases when memory_limit variable does not hold actual
+	 * limit, for example when memory was limited by no kernel support
+	 * for HIGHMEM. Reliable information is known by memblock because
+	 * memory management init adjusts it.
 	 */
-	mem_limit = cpu_to_be_ulong(memory_limit);
+	mem_limit = cpu_to_be_ulong(memblock_end_of_DRAM() -
+					memblock_start_of_DRAM());
 	of_update_property(node, &memory_limit_prop);
 }
 
-- 
1.7.10.4

