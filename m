Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaGHXqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:46:40 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:40505
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaGHXqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:46:33 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Date: Tue,  8 Jul 2014 17:46:51 -0700
Message-Id: <1404866812-26950-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1404866812-26950-1-git-send-email-kys@microsoft.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly set SRB flags for all valid I/O directions. Some IHV drivers on the
Windows host require this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 82fb590..6540fb6 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1613,26 +1613,24 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	vm_srb = &cmd_request->vstor_packet.vm_srb;
 	vm_srb->win8_extension.time_out_value = 60;
 
+	vm_srb->win8_extension.srb_flags |=
+		(SRB_FLAGS_QUEUE_ACTION_ENABLE |
+		SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
 
 	/* Build the SRB */
 	switch (scmnd->sc_data_direction) {
 	case DMA_TO_DEVICE:
 		vm_srb->data_in = WRITE_TYPE;
 		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_DATA_OUT;
-		vm_srb->win8_extension.srb_flags |=
-			(SRB_FLAGS_QUEUE_ACTION_ENABLE |
-			SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
 		break;
 	case DMA_FROM_DEVICE:
 		vm_srb->data_in = READ_TYPE;
 		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_DATA_IN;
-		vm_srb->win8_extension.srb_flags |=
-			(SRB_FLAGS_QUEUE_ACTION_ENABLE |
-			SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
 		break;
 	default:
 		vm_srb->data_in = UNKNOWN_TYPE;
-		vm_srb->win8_extension.srb_flags = 0;
+		vm_srb->win8_extension.srb_flags |= (SRB_FLAGS_DATA_IN |
+						     SRB_FLAGS_DATA_OUT);
 		break;
 	}
 
-- 
1.7.4.1

