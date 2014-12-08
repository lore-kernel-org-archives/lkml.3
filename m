Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaLHISr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:18:47 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40513 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaLHISo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:18:44 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/7] CXL: Add timeout to process element commands
Date: Mon,  8 Dec 2014 19:17:56 +1100
Message-Id: <1418026681-14787-2-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
References: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120808-0033-0000-0000-000000B05039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

In the event that something goes wrong in the hardware and it is unable
to complete a process element comment we would end up polling forever,
effectively making the associated process unkillable.

This patch adds a timeout to the process element command code path, so
that we will give up if the hardware does not respond in a reasonable
time.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/native.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/cxl/native.c b/drivers/misc/cxl/native.c
index 1001cf4..f2b37b4 100644
--- a/drivers/misc/cxl/native.c
+++ b/drivers/misc/cxl/native.c
@@ -277,6 +277,7 @@ static int do_process_element_cmd(struct cxl_context *ctx,
 				  u64 cmd, u64 pe_state)
 {
 	u64 state;
+	unsigned long timeout = jiffies + (HZ * CXL_TIMEOUT);
 
 	WARN_ON(!ctx->afu->enabled);
 
@@ -286,6 +287,10 @@ static int do_process_element_cmd(struct cxl_context *ctx,
 	smp_mb();
 	cxl_p1n_write(ctx->afu, CXL_PSL_LLCMD_An, cmd | ctx->pe);
 	while (1) {
+		if (time_after_eq(jiffies, timeout)) {
+			dev_warn(&ctx->afu->dev, "WARNING: Process Element Command timed out!\n");
+			return -EBUSY;
+		}
 		state = be64_to_cpup(ctx->afu->sw_command_status);
 		if (state == ~0ULL) {
 			pr_err("cxl: Error adding process element to AFU\n");
-- 
2.1.3

