Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaLHISw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:18:52 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40552 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaLHISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:18:50 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 6/7] CXL: Disable SPAP register when freeing SPA
Date: Mon,  8 Dec 2014 19:18:00 +1100
Message-Id: <1418026681-14787-6-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
References: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120808-0033-0000-0000-000000B0505C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

When we deactivate the AFU directed mode we free the scheduled process
area, but did not clear the register in the hardware that has a pointer
to it.

This should be fine since we will have already cleared out every context
and we won't do anything that would cause the hardware to access it
until after we have allocated a new one, but just to be safe this patch
clears out the register when we free the page.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/native.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/cxl/native.c b/drivers/misc/cxl/native.c
index f2b37b4..0f24fa5 100644
--- a/drivers/misc/cxl/native.c
+++ b/drivers/misc/cxl/native.c
@@ -185,6 +185,7 @@ static int alloc_spa(struct cxl_afu *afu)
 
 static void release_spa(struct cxl_afu *afu)
 {
+	cxl_p1n_write(afu, CXL_PSL_SPAP_An, 0);
 	free_pages((unsigned long) afu->spa, afu->spa_order);
 }
 
-- 
2.1.3

