Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3F1S5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:57:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41874 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3F1S53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 094/105] s390/ipl: Fix FCP WWPN and LUN format strings for read
Date: Fri, 28 Jun 2013 11:51:56 -0700
Message-Id: <1372445527-24414-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

commit eda4ddf7e3a2245888e8c45c566fd514cdd5abbb upstream.

The following git commit changed the behavior of sscanf:

commit 53809751ac230a3611b5cdd375f3389f3207d471
Author: Jan Beulich <JBeulich@suse.com>
Date:   Mon Dec 17 16:01:31 2012 -0800
    sscanf: don't ignore field widths for numeric conversions

This broke the WWPN and LUN sysfs attributes for s390 reipl and dump
on panic.

Example:

$ echo 0x0123456701234567 > /sys/firmware/reipl/fcp/wwpn
$ cat /sys/firmware/reipl/fcp/wwpn
0x0001234567012345

So fix this and use format strings that work also with the
new sscanf implementation:

$ echo 0x012345670123456789 > /sys/firmware/reipl/fcp/wwpn
$ cat /sys/firmware/reipl/fcp/wwpn
0x0123456701234567

Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kernel/ipl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 6ffcd32..28c748c 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -754,9 +754,9 @@ static struct bin_attribute sys_reipl_fcp_scp_data_attr = {
 	.write = reipl_fcp_scpdata_write,
 };
 
-DEFINE_IPL_ATTR_RW(reipl_fcp, wwpn, "0x%016llx\n", "%016llx\n",
+DEFINE_IPL_ATTR_RW(reipl_fcp, wwpn, "0x%016llx\n", "%llx\n",
 		   reipl_block_fcp->ipl_info.fcp.wwpn);
-DEFINE_IPL_ATTR_RW(reipl_fcp, lun, "0x%016llx\n", "%016llx\n",
+DEFINE_IPL_ATTR_RW(reipl_fcp, lun, "0x%016llx\n", "%llx\n",
 		   reipl_block_fcp->ipl_info.fcp.lun);
 DEFINE_IPL_ATTR_RW(reipl_fcp, bootprog, "%lld\n", "%lld\n",
 		   reipl_block_fcp->ipl_info.fcp.bootprog);
@@ -1323,9 +1323,9 @@ static struct shutdown_action __refdata reipl_action = {
 
 /* FCP dump device attributes */
 
-DEFINE_IPL_ATTR_RW(dump_fcp, wwpn, "0x%016llx\n", "%016llx\n",
+DEFINE_IPL_ATTR_RW(dump_fcp, wwpn, "0x%016llx\n", "%llx\n",
 		   dump_block_fcp->ipl_info.fcp.wwpn);
-DEFINE_IPL_ATTR_RW(dump_fcp, lun, "0x%016llx\n", "%016llx\n",
+DEFINE_IPL_ATTR_RW(dump_fcp, lun, "0x%016llx\n", "%llx\n",
 		   dump_block_fcp->ipl_info.fcp.lun);
 DEFINE_IPL_ATTR_RW(dump_fcp, bootprog, "%lld\n", "%lld\n",
 		   dump_block_fcp->ipl_info.fcp.bootprog);
-- 
1.8.1.2

