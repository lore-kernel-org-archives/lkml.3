Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaLHITm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:19:42 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46545 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbaLHITk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:19:40 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/7] CXL: Fix leaking interrupts if attach process fails
Date: Mon,  8 Dec 2014 19:17:57 +1100
Message-Id: <1418026681-14787-3-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
References: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120808-0029-0000-0000-000000C4C3DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

In this particular error path we have already allocated the AFU
interrupts, but have not yet set the status to STARTED. The detach
context code will only attempt to release the interrupts if the context
is in state STARTED, so in this case the interrupts would remain
allocated.

This patch releases the AFU interrupts immediately if the attach call
fails to prevent them leaking.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/cxl/file.c b/drivers/misc/cxl/file.c
index 378b099..2e067a5 100644
--- a/drivers/misc/cxl/file.c
+++ b/drivers/misc/cxl/file.c
@@ -181,8 +181,10 @@ static long afu_ioctl_start_work(struct cxl_context *ctx,
 	ctx->pid = get_pid(get_task_pid(current, PIDTYPE_PID));
 
 	if ((rc = cxl_attach_process(ctx, false, work.work_element_descriptor,
-				     amr)))
+				     amr))) {
+		afu_release_irqs(ctx);
 		goto out;
+	}
 
 	ctx->status = STARTED;
 	rc = 0;
-- 
2.1.3

