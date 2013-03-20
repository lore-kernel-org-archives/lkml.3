Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3CTLHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:07:12 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab3CTLHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:07:09 -0400
From: Richard Weinberger <richard@nod.at>
To: tony.luck@intel.com
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] IA64: Fix stack overflow in create_palinfo_proc_entries
Date: Wed, 20 Mar 2013 12:06:59 +0100
Message-Id: <1363777619-15830-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having more than 99 CPUs causes an overflow of cpustr.
If an attacker is able to control the number CPUs he might able to inject code
...kind of. ;-)

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/ia64/kernel/palinfo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index 77597e5..35bee152 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -971,20 +971,18 @@ palinfo_read_entry(char *page, char **start, off_t off, int count, int *eof, voi
 static void __cpuinit
 create_palinfo_proc_entries(unsigned int cpu)
 {
-#	define CPUSTR	"cpu%d"
-
 	pal_func_cpu_u_t f;
 	struct proc_dir_entry **pdir;
 	struct proc_dir_entry *cpu_dir;
 	int j;
-	char cpustr[sizeof(CPUSTR)];
+	char cpustr[32];
 
 
 	/*
 	 * we keep track of created entries in a depth-first order for
 	 * cleanup purposes. Each entry is stored into palinfo_proc_entries
 	 */
-	sprintf(cpustr,CPUSTR, cpu);
+	snprintf(cpustr, sizeof(cpustr), "cpu%d", cpu);
 
 	cpu_dir = proc_mkdir(cpustr, palinfo_dir);
 
-- 
1.8.1.4

