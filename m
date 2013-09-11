Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3IKSCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:02:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab3IKSC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:02:29 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Len Brown <len.brown@intel.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [PATCH] x86 powertop, replace numa based core ID with physical ID
Date: Wed, 11 Sep 2013 14:02:19 -0400
Message-Id: <1378922539-21387-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len, here are some test results.

On a 2-socket AMD 6276 system with the existing turbostat I see

pk cor CPU   GHz  TSC
          0.74 1.15
0   0   8 1.48 2.30
0   1   9 1.48 2.30
0   2  10 1.53 2.30
0   3  11 1.46 2.30
0   4  12 1.49 2.30
0   5  13 1.47 2.30
0   6  14 1.48 2.30
0   7  15 1.54 2.30
1   0  24 1.49 2.30
1   1  25 1.48 2.30
1   2  26 1.48 2.30
1   3  27 1.51 2.30
1   4  28 1.52 2.30
1   5  29 1.43 2.30
1   6  30 1.51 2.30
1   7  31 1.49 2.30

As you can see only 8 of each 16 cores are reported.  The issue is that the
core_id sysfs file is not physical-based; it is numa-based and it may differ
from that of the physical enumeration, especially in the cases where sockets
are split by numa nodes.  It looks like we really want the physical core_id
and not the numa core_id.  After the patch,

pk cor CPU   GHz  TSC
           1.47 2.30
 0   0   0 1.46 2.30
 0   1   1 1.44 2.30
 0   2   2 1.51 2.30
 0   3   3 1.49 2.30
 0   4   4 1.51 2.30
 0   5   5 1.51 2.30
 0   6   6 1.49 2.30
 0   7   7 1.49 2.30
 0   8   8 1.47 2.30
 0   9   9 1.48 2.30
 0  10  10 1.64 2.30
 0  11  11 1.54 2.30
 0  12  12 1.51 2.30
 0  13  13 1.46 2.30
 0  14  14 1.49 2.30
 0  15  15 1.46 2.30
 1   0  16 1.49 2.30
 1   1  17 1.44 2.30
 1   2  18 1.51 2.30
 1   3  19 1.44 2.30
 1   4  20 1.50 2.30
 1   5  21 1.44 2.30
 1   6  22 1.50 2.30
 1   7  23 1.44 2.30
 1   8  24 1.48 2.30
 1   9  25 1.46 2.30
 1  10  26 1.47 2.30
 1  11  27 1.49 2.30
 1  12  28 1.52 2.30
 1  13  29 1.43 2.30
 1  14  30 1.51 2.30
 1  15  31 1.45 2.30

As a sanity check I also ran on a dual-socket E5-26XX v2 system:

pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W RAM_W PKG_% RAM_%
             0.04 1.30 2.69   0   0.12   0.00  99.84   0.00   32   32  12.28   0.00  86.59   0.00  11.20   2.74  6.48  0.00  0.00
 0   0   0   0.23 1.20 2.69   0   0.43   0.00  99.34   0.00   26   27  12.39   0.00  86.61   0.00   5.76   1.53  1.85  0.00  0.00
 0   0  20   0.05 1.21 2.69   0   0.61
 0   1   1   0.02 1.23 2.69   0   0.08   0.00  99.90   0.00   26
 0   1  21   0.02 1.26 2.69   0   0.08
 0   2   2   0.02 1.29 2.69   0   0.06   0.00  99.92   0.00   25
 0   2  22   0.02 1.35 2.69   0   0.06
 0   3   3   0.02 1.28 2.69   0   0.06   0.00  99.92   0.00   25
 0   3  23   0.02 1.35 2.69   0   0.06
 0   4   4   0.03 1.25 2.69   0   0.06   0.00  99.90   0.00   32
 0   4  24   0.02 1.33 2.69   0   0.08
 0   9   5   0.02 1.35 2.69   0   0.05   0.00  99.93   0.00   28
 0   9  25   0.02 1.34 2.69   0   0.05
 0  10   6   0.02 1.25 2.69   0   0.05   0.00  99.93   0.00   21
 0  10  26   0.02 1.34 2.69   0   0.05
 0  11   7   0.02 1.29 2.69   0   0.06   0.00  99.92   0.00   32
 0  11  27   0.02 1.35 2.69   0   0.06
 0  12   8   0.02 1.27 2.69   0   0.06   0.00  99.92   0.00   31
 0  12  28   0.02 1.33 2.69   0   0.06
 0  13   9   0.02 1.25 2.69   0   0.05   0.00  99.93   0.00   20
 0  13  29   0.02 1.30 2.69   0   0.06
 1   0  10   0.04 1.23 2.69   0   0.10   0.00  99.86   0.00   29   32  12.16   0.00  86.59   0.00   5.45   1.22  4.63  0.00  0.00
 1   0  30   0.03 1.20 2.69   0   0.11
 1   1  11   0.04 1.20 2.69   0   0.10   0.00  99.86   0.00   30
 1   1  31   0.03 1.20 2.69   0   0.11
 1   2  12   0.03 1.20 2.69   0   0.08   0.00  99.89   0.00   29
 1   2  32   0.02 1.20 2.69   0   0.09
 1   3  13   0.21 1.20 2.69   0   0.11   0.00  99.68   0.00   29
 1   3  33   0.03 1.20 2.69   0   0.30
 1   4  14   0.04 1.20 2.69   0   0.08   0.00  99.88   0.00   31
 1   4  34   0.02 1.20 2.69   0   0.10
 1   9  15   0.03 1.20 2.69   0   0.08   0.00  99.88   0.00   26
 1   9  35   0.02 1.20 2.69   0   0.10
 1  10  16   0.03 1.20 2.69   0   0.08   0.00  99.89   0.00   28
 1  10  36   0.02 1.20 2.69   0   0.09
 1  11  17   0.03 1.20 2.69   0   0.08   0.00  99.89   0.00   26
 1  11  37   0.02 1.20 2.69   0   0.09
 1  12  18   0.33 1.44 2.69   0   0.09   0.00  99.58   0.00   25
 1  12  38   0.02 1.20 2.69   0   0.40
 1  13  19   0.11 1.74 2.69   0   0.10   0.00  99.79   0.00   31
 1  13  39   0.03 1.20 2.69   0   0.17

And after the patch,

pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W RAM_W PKG_% RAM_%
             0.04 1.22 2.69   0  50.05   0.00  99.83   0.00   33   32  12.29   0.00  86.75   0.00  11.33   2.73  6.35  0.00  0.00
 0   0   0   0.14 1.21 2.69   0   0.34   0.00  99.53   0.00   26   27  12.43   0.00  86.77   0.00   5.83   1.53  1.92  0.00  0.00
 0   1   1   0.02 1.24 2.69   0   0.06   0.00  99.92   0.00   26
 0   2   2   0.02 1.29 2.69   0   0.09   0.00  99.90   0.00   26
 0   3   3   0.02 1.31 2.69   0   0.09   0.00  99.89   0.00   24
 0   4   4   0.03 1.27 2.69   0   0.11   0.00  99.87   0.00   33
 0   5   5   0.02 1.30 2.69   0   0.10   0.00  99.88   0.00   28
 0   6   6   0.02 1.25 2.69   0   0.08   0.00  99.90   0.00   21
 0   7   7   0.02 1.22 2.69   0   0.09   0.00  99.89   0.00   32
 0   8   8   0.02 1.26 2.69   0   0.10   0.00  99.88   0.00   31
 0   9   9   0.02 1.30 2.69   0   0.08   0.00  99.90   0.00   21
 0  20  20   0.04 1.23 2.69   0  99.96
 0  21  21   0.02 1.30 2.69   0  99.98
 0  22  22   0.02 1.34 2.69   0  99.98
 0  23  23   0.02 1.33 2.69   0  99.98
 0  24  24   0.02 1.28 2.69   0  99.98
 0  25  25   0.02 1.27 2.69   0  99.98
 0  26  26   0.02 1.34 2.69   0  99.98
 0  27  27   0.02 1.33 2.69   0  99.98
 0  28  28   0.02 1.29 2.69   0  99.98
 0  29  29   0.02 1.31 2.69   0  99.98
 1   0  30   0.02 1.20 2.69   0  99.98
 1   1  31   0.03 1.20 2.69   0  99.97
 1   2  32   0.02 1.20 2.69   0  99.98
 1   3  33   0.03 1.20 2.69   0  99.97
 1   4  34   0.02 1.20 2.69   0  99.98
 1   5  35   0.02 1.20 2.69   0  99.98
 1   6  36   0.02 1.20 2.69   0  99.98
 1   7  37   0.02 1.20 2.69   0  99.98
 1   8  38   0.02 1.20 2.69   0  99.98
 1   9  39   0.02 1.20 2.69   0  99.98
 1  10  10   0.05 1.20 2.69   0   0.13   0.00  99.82   0.00   29   32  12.16   0.00  86.74   0.00   5.50   1.21  4.43  0.00  0.00
 1  11  11   0.03 1.20 2.69   0   0.14   0.00  99.83   0.00   29
 1  12  12   0.40 1.20 2.69   0   0.11   0.00  99.49   0.00   30
 1  13  13   0.03 1.20 2.69   0   0.12   0.00  99.85   0.00   29
 1  14  14   0.03 1.20 2.69   0   0.09   0.00  99.88   0.00   32
 1  15  15   0.03 1.20 2.69   0   0.10   0.00  99.87   0.00   27
 1  16  16   0.03 1.20 2.69   0   0.10   0.00  99.86   0.00   29
 1  17  17   0.03 1.20 2.69   0   0.11   0.00  99.86   0.00   28
 1  18  18   0.03 1.20 2.69   0   0.09   0.00  99.88   0.00   26
 1  19  19   0.04 1.20 2.69   0   0.10   0.00  99.86   0.00   30

which AFAICT is correct.

P.

-------------8<-----------------

x86 powertop, replace numa based core ID with physical ID

On a 2-socket AMD 6276 processor system, where each socket has 8 2-thread
cores for a total of 16, turbostat only reports 8 cores for each socket
and drops data.

This happens because the sysfs file
/sys/devices/system/cpu/cpu%d/topology/core_id which is used to fetch the
"core_id" of each core is numa-centric and not physically based.

This results in fewer cores being allocated than are present and data gets
dropped.

For example, on the system above "turbostat -vvv" reports

max_core_id 7, sizing for 8 cores per package
max_package_id 1, sizing for 2 packages

when it should report

max_core_id 31, sizing for 16 cores per package
max_package_id 1, sizing for 2 packages

This patch swaps the numa based core_id for the physical core_id, which is
what we really want.  The numa core_id is now only used for debug output.

Successfully tested on the system above and also verified on an Intel
dual-socket E5-26XX system.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 tools/power/x86/turbostat/turbostat.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index fe70207..f7c91e0 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2009,6 +2009,7 @@ void topology_probe()
 {
 	int i;
 	int max_core_id = 0;
+	int min_core_id = 0;
 	int max_package_id = 0;
 	int max_siblings = 0;
 	struct cpu_topology {
@@ -2058,7 +2059,7 @@ void topology_probe()
 
 	/*
 	 * For online cpus
-	 * find max_core_id, max_package_id
+	 * find min_core_id, max_core_id, max_package_id
 	 */
 	for (i = 0; i <= topo.max_cpu_num; ++i) {
 		int siblings;
@@ -2068,22 +2069,27 @@ void topology_probe()
 				fprintf(stderr, "cpu%d NOT PRESENT\n", i);
 			continue;
 		}
-		cpus[i].core_id = get_core_id(i);
+		cpus[i].core_id = i;
 		if (cpus[i].core_id > max_core_id)
 			max_core_id = cpus[i].core_id;
 
 		cpus[i].physical_package_id = get_physical_package_id(i);
-		if (cpus[i].physical_package_id > max_package_id)
+		if (cpus[i].physical_package_id > max_package_id) {
 			max_package_id = cpus[i].physical_package_id;
+			min_core_id = i;
+		}
 
 		siblings = get_num_ht_siblings(i);
 		if (siblings > max_siblings)
 			max_siblings = siblings;
 		if (verbose > 1)
-			fprintf(stderr, "cpu %d pkg %d core %d\n",
-				i, cpus[i].physical_package_id, cpus[i].core_id);
+			fprintf(stderr,
+				"cpu %d pkg %d phys-core %d numa-core %d\n",
+				i, cpus[i].physical_package_id,
+				cpus[i].core_id, get_core_id(i));
 	}
-	topo.num_cores_per_pkg = max_core_id + 1;
+	topo.num_cores_per_pkg = (max_core_id - min_core_id) + 1;
+
 	if (verbose > 1)
 		fprintf(stderr, "max_core_id %d, sizing for %d cores per package\n",
 			max_core_id, topo.num_cores_per_pkg);
@@ -2175,7 +2181,7 @@ int initialize_counters(int cpu_id)
 	int my_thread_id, my_core_id, my_package_id;
 
 	my_package_id = get_physical_package_id(cpu_id);
-	my_core_id = get_core_id(cpu_id);
+	my_core_id = cpu_id % topo.num_cores_per_pkg;
 
 	if (cpu_is_first_sibling_in_core(cpu_id)) {
 		my_thread_id = 0;
-- 
1.7.9.3

