Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbaGHADr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:03:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbaGHADd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 44/44] powerpc/sysfs: Disable writing to PURR in guest mode
Date: Mon,  7 Jul 2014 17:07:34 -0700
Message-Id: <20140707235859.949000343@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>

commit d1211af3049f4c9c1d8d4eb8f8098cc4f4f0d0c7 upstream.

arch/powerpc/kernel/sysfs.c exports PURR with write permission.
This may be valid for kernel in phyp mode. But writing to
the file in guest mode causes crash due to a priviledge violation

Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[Backported to 3.4: adjust context]
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/sysfs.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -17,6 +17,7 @@
 #include <asm/machdep.h>
 #include <asm/smp.h>
 #include <asm/pmc.h>
+#include <asm/firmware.h>
 
 #include "cacheinfo.h"
 
@@ -179,15 +180,25 @@ SYSFS_PMCSETUP(spurr, SPRN_SPURR);
 SYSFS_PMCSETUP(dscr, SPRN_DSCR);
 SYSFS_PMCSETUP(pir, SPRN_PIR);
 
+/*
+  Lets only enable read for phyp resources and
+  enable write when needed with a separate function.
+  Lets be conservative and default to pseries.
+ */
 static DEVICE_ATTR(mmcra, 0600, show_mmcra, store_mmcra);
 static DEVICE_ATTR(spurr, 0600, show_spurr, NULL);
 static DEVICE_ATTR(dscr, 0600, show_dscr, store_dscr);
-static DEVICE_ATTR(purr, 0600, show_purr, store_purr);
+static DEVICE_ATTR(purr, 0400, show_purr, store_purr);
 static DEVICE_ATTR(pir, 0400, show_pir, NULL);
 
 unsigned long dscr_default = 0;
 EXPORT_SYMBOL(dscr_default);
 
+static void add_write_permission_dev_attr(struct device_attribute *attr)
+{
+	attr->attr.mode |= 0200;
+}
+
 static ssize_t show_dscr_default(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -394,8 +405,11 @@ static void __cpuinit register_cpu_onlin
 	if (cpu_has_feature(CPU_FTR_MMCRA))
 		device_create_file(s, &dev_attr_mmcra);
 
-	if (cpu_has_feature(CPU_FTR_PURR))
+	if (cpu_has_feature(CPU_FTR_PURR)) {
+		if (!firmware_has_feature(FW_FEATURE_LPAR))
+			add_write_permission_dev_attr(&dev_attr_purr);
 		device_create_file(s, &dev_attr_purr);
+	}
 
 	if (cpu_has_feature(CPU_FTR_SPURR))
 		device_create_file(s, &dev_attr_spurr);


