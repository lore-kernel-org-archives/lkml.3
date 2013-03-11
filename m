Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3CKLmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:42:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37379 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CKLl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:41:58 -0400
Date: Mon, 11 Mar 2013 14:40:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] mpt3sas: move dereference under check
Message-ID: <20130311114014.GA8235@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_pool_free() dereferences "ioc->sense_dma_pool" but we check it
for NULL on the following line.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1836003..06a84ef 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2479,9 +2479,11 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	if (ioc->sense) {
-		pci_pool_free(ioc->sense_dma_pool, ioc->sense, ioc->sense_dma);
-		if (ioc->sense_dma_pool)
+		if (ioc->sense_dma_pool) {
+			pci_pool_free(ioc->sense_dma_pool, ioc->sense,
+				      ioc->sense_dma);
 			pci_pool_destroy(ioc->sense_dma_pool);
+		}
 		dexitprintk(ioc, pr_info(MPT3SAS_FMT
 			"sense_pool(0x%p): free\n",
 			ioc->name, ioc->sense));
