Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaDNTCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:02:07 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:24772 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaDNTCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:02:04 -0400
Date: Mon, 14 Apr 2014 14:01:09 -0500
From: scameron@beardog.cce.hp.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        Jiang Liu <jiang.liu@linux.intel.com>, scameron@beardog.cce.hp.com
Subject: [PATCH] hpsa: fix NULL dereference in hpsa_put_ctlr_into_performant_mode()
Message-ID: <20140414190109.GD21686@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Initialize local variable trans_support before it is used rather
than after.  It is supposed to contain the value of a register on the
controller containing bits that describe which transport modes the
controller supports (e.g. "performant", "ioaccel1",  "ioaccel2").  A
NULL pointer dereference will almost certainly occur if trans_support
is not initialized at the right point.  If for example the uninitialized
trans_support value does not have the bit set for ioaccel2 support when it
should be, then ioaccel2_alloc_cmds_and_bft() will not get called as it
should be and the h->ioaccel2_blockFetchTable array will remain NULL
instead of being allocated.  Too late, trans_support finally gets
initialized with the correct value with ioaccel2 mode bit set,
which later causes calc_bucket_map() to be called to fill in
h->ioaccel2_blockFetchTable[].  However h->ioaccel2_blockFetchTable
is NULL because it didn't get allocated because earlier trans_support
wasn't initialized at the right point.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8cf4a0c..9a6e4a2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7463,6 +7463,10 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	if (hpsa_simple_mode)
 		return;
 
+	trans_support = readl(&(h->cfgtable->TransportSupport));
+	if (!(trans_support & PERFORMANT_MODE))
+		return;
+
 	/* Check for I/O accelerator mode support */
 	if (trans_support & CFGTBL_Trans_io_accel1) {
 		transMethod |= CFGTBL_Trans_io_accel1 |
@@ -7479,10 +7483,6 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	}
 
 	/* TODO, check that this next line h->nreply_queues is correct */
-	trans_support = readl(&(h->cfgtable->TransportSupport));
-	if (!(trans_support & PERFORMANT_MODE))
-		return;
-
 	h->nreply_queues = h->msix_vector > 0 ? h->msix_vector : 1;
 	hpsa_get_max_perf_mode_cmds(h);
 	/* Performant mode ring buffer and supporting data structures */
-- 
1.7.1

