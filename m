Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaGHXqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:46:42 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:40508
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaGHXqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:46:34 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 5/8] Drivers: scsi: storvsc: Fix a bug in the handling of SRB status flags
Date: Tue,  8 Jul 2014 17:46:49 -0700
Message-Id: <1404866812-26950-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1404866812-26950-1-git-send-email-kys@microsoft.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SRB status can have additional information. Mask these out before processing SRB status.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 428dbda..8f1b263 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -299,11 +299,14 @@ enum storvsc_request_type {
  */
 
 #define SRB_STATUS_AUTOSENSE_VALID	0x80
+#define SRB_STATUS_QUEUE_FROZEN		0x40
 #define SRB_STATUS_INVALID_LUN	0x20
 #define SRB_STATUS_SUCCESS	0x01
 #define SRB_STATUS_ABORTED	0x02
 #define SRB_STATUS_ERROR	0x04
 
+#define SRB_STATUS(status) \
+	(status & ~(SRB_STATUS_AUTOSENSE_VALID | SRB_STATUS_QUEUE_FROZEN))
 /*
  * This is the end of Protocol specific defines.
  */
@@ -1007,7 +1010,7 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 	void (*process_err_fn)(struct work_struct *work);
 	bool do_work = false;
 
-	switch (vm_srb->srb_status) {
+	switch (SRB_STATUS(vm_srb->srb_status)) {
 	case SRB_STATUS_ERROR:
 		/*
 		 * If there is an error; offline the device since all
-- 
1.7.4.1

