Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbaIOVJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:09:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaIOT0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.16 052/158] drivers: scsi: storvsc: Set srb_flags in all cases
Date: Mon, 15 Sep 2014 12:24:51 -0700
Message-Id: <20140915192544.457409900@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit f885fb73f64154690c2158e813de56363389ffec upstream.

Correctly set SRB flags for all valid I/O directions. Some IHV drivers on the
Windows host require this. The host validates the command and SRB flags
prior to passing the command down to native driver stack.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/storvsc_drv.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1601,26 +1601,24 @@ static int storvsc_queuecommand(struct S
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
 


