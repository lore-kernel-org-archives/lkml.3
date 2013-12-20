Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab3LTA1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:27:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab3LTA12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:27:28 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [PATCH] turbostat, servers do not support uncore power register
Date: Thu, 19 Dec 2013 19:27:22 -0500
Message-Id: <1387499242-30364-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the Intel Software Developer's Manual section 14.7.4,

"For server platforms, PP1 domain is not supported, but its PP0 domain
supports the MSR_PP0_PERF_STATUS interface."

When I run 'turbostat ls' I see the following error:

/dev/cpu/0/msr offset 0x641 read failed

because the server doesn't support the MSR_PP1_ENERGY_STATUS
register (0x641).  This patch implements a get_msr_nowarn() which suppresses the
above warning and then sets !RAPL_GFX.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 tools/power/x86/turbostat/turbostat.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 9d77f13..ff505c2 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -219,7 +219,7 @@ int cpu_migrate(int cpu)
 		return 0;
 }
 
-int get_msr(int cpu, off_t offset, unsigned long long *msr)
+int _get_msr(int cpu, off_t offset, unsigned long long *msr, int warn)
 {
 	ssize_t retval;
 	char pathname[32];
@@ -234,13 +234,25 @@ int get_msr(int cpu, off_t offset, unsigned long long *msr)
 	close(fd);
 
 	if (retval != sizeof *msr) {
-		fprintf(stderr, "%s offset 0x%zx read failed\n", pathname, offset);
+		if (warn)
+			fprintf(stderr, "%s offset 0x%zx read failed\n",
+				pathname, offset);
 		return -1;
 	}
 
 	return 0;
 }
 
+int get_msr(int cpu, off_t offset, unsigned long long *msr)
+{
+	return _get_msr(cpu, offset, msr, 1);
+}
+
+int get_msr_nowarn(int cpu, off_t offset, unsigned long long *msr)
+{
+	return _get_msr(cpu, offset, msr, 0);
+}
+
 void print_header(void)
 {
 	if (show_pkg)
@@ -953,9 +965,10 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 		p->energy_dram = msr & 0xFFFFFFFF;
 	}
 	if (do_rapl & RAPL_GFX) {
-		if (get_msr(cpu, MSR_PP1_ENERGY_STATUS, &msr))
-			return -16;
-		p->energy_gfx = msr & 0xFFFFFFFF;
+		if (get_msr_nowarn(cpu, MSR_PP1_ENERGY_STATUS, &msr))
+			do_rapl &= ~RAPL_GFX; /* unsupported on servers */
+		else
+			p->energy_gfx = msr & 0xFFFFFFFF;
 	}
 	if (do_rapl & RAPL_PKG_PERF_STATUS) {
 		if (get_msr(cpu, MSR_PKG_PERF_STATUS, &msr))
-- 
1.7.9.3

