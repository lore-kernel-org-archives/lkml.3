Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaLHITa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:19:30 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46428 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbaLHISr (ORCPT
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
Subject: [PATCH 4/7] CXL: Early return from cxl_handle_fault for a shut down context
Date: Mon,  8 Dec 2014 19:17:58 +1100
Message-Id: <1418026681-14787-4-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
References: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120808-0029-0000-0000-000000C4C389
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

If a context is being detached and we get a translation fault for it
there is little point getting it's mm and handling the fault, so just
respond with an address error and return earlier.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/fault.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/misc/cxl/fault.c b/drivers/misc/cxl/fault.c
index c99e896..3e8c06a 100644
--- a/drivers/misc/cxl/fault.c
+++ b/drivers/misc/cxl/fault.c
@@ -176,6 +176,12 @@ void cxl_handle_fault(struct work_struct *fault_work)
 		return;
 	}
 
+	/* Early return if the context is being / has been detached */
+	if (ctx->status == CLOSED) {
+		cxl_ack_ae(ctx);
+		return;
+	}
+
 	pr_devel("CXL BOTTOM HALF handling fault for afu pe: %i. "
 		"DSISR: %#llx DAR: %#llx\n", ctx->pe, dsisr, dar);
 
-- 
2.1.3

