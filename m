Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaLHIUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:20:25 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40531 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaLHISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:18:47 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 5/7] CXL: Disable AFU debug flag
Date: Mon,  8 Dec 2014 19:17:59 +1100
Message-Id: <1418026681-14787-5-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
References: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120808-0033-0000-0000-000000B0504D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Upon inspection of the implementation specific registers, it was
discovered that the high bit of the implementation specific RXCTL
register was enabled, which enables the DEADB00F debug feature.

The debug feature causes MMIO reads to a disabled AFU to respond with
0xDEADB00F instead of all Fs. In general this should not be visible as
the kernel will only allow MMIO access to enabled AFUs, but there may be
some circumstances where an AFU may become disabled while it is use.
One such case would be an AFU designed to only be used in the dedicated
process mode and to disable itself after it has completed it's work
(however even in that case the effects of this debug flag would be
limited as the userspace application must have completed any required
MMIO accesses before the AFU disables itself with or without the flag).

This patch removes the debug flag and replaces the magic value
programmed into this register with a preprocessor define so it is
clearer what the rest of this initialisation does.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/cxl.h | 7 +++++++
 drivers/misc/cxl/pci.c | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/cxl/cxl.h b/drivers/misc/cxl/cxl.h
index 7c05239..c1f8aa6 100644
--- a/drivers/misc/cxl/cxl.h
+++ b/drivers/misc/cxl/cxl.h
@@ -287,6 +287,13 @@ static const cxl_p2n_reg_t CXL_PSL_WED_An     = {0x0A0};
 #define CXL_PE_SOFTWARE_STATE_S (1ul << (31 - 30)) /* Suspend */
 #define CXL_PE_SOFTWARE_STATE_T (1ul << (31 - 31)) /* Terminate */
 
+/****** CXL_PSL_RXCTL_An (Implementation Specific) **************************
+ * Controls AFU Hang Pulse, which sets the timeout for the AFU to respond to
+ * the PSL for any response (except MMIO). Timeouts will occur between 1x to 2x
+ * of the hang pulse frequency.
+ */
+#define CXL_PSL_RXCTL_AFUHP_4S      0x7000000000000000ULL
+
 /* SPA->sw_command_status */
 #define CXL_SPA_SW_CMD_MASK         0xffff000000000000ULL
 #define CXL_SPA_SW_CMD_TERMINATE    0x0001000000000000ULL
diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index 0f2cc9f..2ccd0a9 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -348,7 +348,7 @@ static int init_implementation_afu_regs(struct cxl_afu *afu)
 	cxl_p1n_write(afu, CXL_PSL_COALLOC_A, 0xFF000000FEFEFEFEULL);
 	/* for debugging with trace arrays */
 	cxl_p1n_write(afu, CXL_PSL_SLICE_TRACE, 0x0000FFFF00000000ULL);
-	cxl_p1n_write(afu, CXL_PSL_RXCTL_A, 0xF000000000000000ULL);
+	cxl_p1n_write(afu, CXL_PSL_RXCTL_A, CXL_PSL_RXCTL_AFUHP_4S);
 
 	return 0;
 }
-- 
2.1.3

