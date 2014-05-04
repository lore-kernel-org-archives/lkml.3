Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaEDQD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:03:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbaEDPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.10 53/86] SCSI: arcmsr: upper 32 of dma address lost
Date: Sun,  4 May 2014 11:41:28 -0400
Message-Id: <20140504154147.650253075@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit e2c70425f05219b142b3a8a9489a622c736db39d upstream.

The original code always set the upper 32 bits to zero because it was
doing a shift of the wrong variable.

Fixes: 1a4f550a09f8 ('[SCSI] arcmsr: 1.20.00.15: add SATA RAID plus other fixes')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/arcmsr/arcmsr_hba.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2501,16 +2501,15 @@ static int arcmsr_polling_ccbdone(struct
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
 	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
-	dma_addr_t dma_coherent_handle;
+
 	/*
 	********************************************************************
 	** here we need to tell iop 331 our freeccb.HighPart
 	** if freeccb.HighPart is not zero
 	********************************************************************
 	*/
-	dma_coherent_handle = acb->dma_coherent_handle;
-	cdb_phyaddr = (uint32_t)(dma_coherent_handle);
-	cdb_phyaddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);
+	cdb_phyaddr = lower_32_bits(acb->dma_coherent_handle);
+	cdb_phyaddr_hi32 = upper_32_bits(acb->dma_coherent_handle);
 	acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
 	/*
 	***********************************************************************


