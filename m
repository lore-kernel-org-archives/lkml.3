Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaJ1Dhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:37:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaJ1Dhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.17 038/146] qla2xxx: Fix shost use-after-free on device removal
Date: Tue, 28 Oct 2014 11:33:00 +0800
Message-Id: <20141028033345.068752469@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <joe.lawrence@stratus.com>

commit db7157d4cfce6edf052452fb1d327d4d11b67f4c upstream.

Once calling scsi_host_put, be careful to not access qla_hw_data through
the Scsi_Host private data (ie, scsi_qla_host base_vha).

Fixes: fe1b806f4f71 ("qla2xxx: Refactor shutdown code so some functionality can be reused")
Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_os.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3119,10 +3119,8 @@ qla2x00_unmap_iobases(struct qla_hw_data
 }
 
 static void
-qla2x00_clear_drv_active(scsi_qla_host_t *vha)
+qla2x00_clear_drv_active(struct qla_hw_data *ha)
 {
-	struct qla_hw_data *ha = vha->hw;
-
 	if (IS_QLA8044(ha)) {
 		qla8044_idc_lock(ha);
 		qla8044_clear_drv_active(ha);
@@ -3193,7 +3191,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_host_put(base_vha->host);
 
-	qla2x00_clear_drv_active(base_vha);
+	qla2x00_clear_drv_active(ha);
 
 	qla2x00_unmap_iobases(ha);
 


