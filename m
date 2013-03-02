Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3CBXWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 18:22:01 -0500
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:44271 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3CBXWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 18:22:00 -0500
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Mar 2013 18:22:00 EST
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, len.brown@intel.com,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH] x86: fix 32-bit *_cpu_data initializers
Date: Sun,  3 Mar 2013 00:14:42 +0100
Message-Id: <1362266082-2227-1-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.2.rc1.362.gc8d5142
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 27be457000211a6903968dfce06d5f73f051a217
(x86 idle: remove 32-bit-only "no-hlt" parameter, hlt_works_ok flag)
removed the hlt_works_ok flag from struct cpuinfo_x86, but
boot_cpu_data and new_cpu_data initializers were not changed causing
setting f00f_bug flag, instead of fdiv_bug. If CONFIG_X86_F00F_BUG
is not set the f00f_bug flag is never cleared.

To avoid such problems in future C99-style initialization is now used.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
$ cat < /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 13
model name	: Intel(R) Pentium(R) M processor 1.73GHz
stepping	: 8
microcode	: 0x20
cpu MHz		: 800.000
cache size	: 2048 KB
fdiv_bug	: no
f00f_bug	: yes
...
	
By the way now in struct cpuinfo_x86 for 32-bit systems pad0
should be extended to 2 bytes or removed, because now 32-bit
specific bugs area have now 6 bytes + pad0.

 arch/x86/kernel/setup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 84d3285..90d8cc9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -171,9 +171,15 @@ static struct resource bss_resource = {
 
 #ifdef CONFIG_X86_32
 /* cpu data as detected by the assembly code in head.S */
-struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+struct cpuinfo_x86 new_cpu_data __cpuinitdata = {
+	.wp_works_ok = -1,
+	.fdiv_bug = -1,
+};
 /* common cpu data for all cpus */
-struct cpuinfo_x86 boot_cpu_data __read_mostly = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+struct cpuinfo_x86 boot_cpu_data __read_mostly = {
+	.wp_works_ok = -1,
+	.fdiv_bug = -1,
+};
 EXPORT_SYMBOL(boot_cpu_data);
 
 unsigned int def_to_bigsmp;
-- 
1.8.2.rc1.362.gc8d5142

