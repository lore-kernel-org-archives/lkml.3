Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3JUIwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:52:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39703 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754058Ab3JUIwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Madhavan Srinivasan" <maddy@linux.vnet.ibm.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.871863470@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 099/149] powerpc/sysfs: Disable writing to PURR in
 guest mode
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>

commit d1211af3049f4c9c1d8d4eb8f8098cc4f4f0d0c7 upstream.

arch/powerpc/kernel/sysfs.c exports PURR with write permission.
This may be valid for kernel in phyp mode. But writing to
the file in guest mode causes crash due to a priviledge violation

Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[bwh: Backported to 3.2:
 - Adjust context
 - CPUs are sysdev and we must use the sysdev API]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/sysfs.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -18,6 +18,7 @@
 #include <asm/machdep.h>
 #include <asm/smp.h>
 #include <asm/pmc.h>
+#include <asm/firmware.h>
 
 #include "cacheinfo.h"
 
@@ -178,14 +179,24 @@ SYSFS_PMCSETUP(purr, SPRN_PURR);
 SYSFS_PMCSETUP(spurr, SPRN_SPURR);
 SYSFS_PMCSETUP(dscr, SPRN_DSCR);
 
+/*
+  Lets only enable read for phyp resources and
+  enable write when needed with a separate function.
+  Lets be conservative and default to pseries.
+*/
 static SYSDEV_ATTR(mmcra, 0600, show_mmcra, store_mmcra);
 static SYSDEV_ATTR(spurr, 0600, show_spurr, NULL);
 static SYSDEV_ATTR(dscr, 0600, show_dscr, store_dscr);
-static SYSDEV_ATTR(purr, 0600, show_purr, store_purr);
+static SYSDEV_ATTR(purr, 0400, show_purr, store_purr);
 
 unsigned long dscr_default = 0;
 EXPORT_SYMBOL(dscr_default);
 
+static void add_write_permission_dev_attr(struct sysdev_attribute *attr)
+{
+	attr->attr.mode |= 0200;
+}
+
 static ssize_t show_dscr_default(struct sysdev_class *class,
 		struct sysdev_class_attribute *attr, char *buf)
 {
@@ -394,8 +405,11 @@ static void __cpuinit register_cpu_onlin
 	if (cpu_has_feature(CPU_FTR_MMCRA))
 		sysdev_create_file(s, &attr_mmcra);
 
-	if (cpu_has_feature(CPU_FTR_PURR))
+	if (cpu_has_feature(CPU_FTR_PURR)) {
+		if (!firmware_has_feature(FW_FEATURE_LPAR))
+			add_write_permission_dev_attr(&attr_purr);
 		sysdev_create_file(s, &attr_purr);
+	}
 
 	if (cpu_has_feature(CPU_FTR_SPURR))
 		sysdev_create_file(s, &attr_spurr);

