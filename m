Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3GAUK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:10:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3GAUKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 01/26] s390/ipl: Fix FCP WWPN and LUN format strings for read
Date: Mon,  1 Jul 2013 13:09:56 -0700
Message-Id: <20130701200730.052755815@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/ipl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -754,9 +754,9 @@ static struct bin_attribute sys_reipl_fc
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
@@ -1323,9 +1323,9 @@ static struct shutdown_action __refdata
 
 /* FCP dump device attributes */
 
-DEFINE_IPL_ATTR_RW(dump_fcp, wwpn, "0x%016llx\n", "%016llx\n",
+DEFINE_IPL_ATTR_RW(dump_fcp, wwpn, "0x%016llx\n", "%llx\n",
 		   dump_block_fcp->ipl_info.fcp.wwpn);
-DEFINE_IPL_ATTR_RW(dump_fcp, lun, "0x%016llx\n", "%016llx\n",
+DEFINE_IPL_ATTR_RW(dump_fcp, lun, "0x%016llx\n", "%llx\n",
 		   dump_block_fcp->ipl_info.fcp.lun);
 DEFINE_IPL_ATTR_RW(dump_fcp, bootprog, "%lld\n", "%lld\n",
 		   dump_block_fcp->ipl_info.fcp.bootprog);


