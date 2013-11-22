Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3KVKKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 05:10:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32950 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3KVKJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 05:09:59 -0500
From: Vaughan Cao <vaughan.cao@oracle.com>
To: rajashekhar.a@netapp.com, vijay.chauhan@netapp.com, hare@suse.de,
        michaelc@cs.wisc.edu
Cc: JBottomley@parallels.com, vaughan.cao@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] scsi_dh_alua: restrain retries during AAS transition period
Date: Fri, 22 Nov 2013 18:12:00 +0800
Message-Id: <1385115120-18309-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SCSI ALUA handler currently retries the submit_rtpg continuously in a
loop (in the alua_rtpg routine) during the entire ALUA transitioning period
i.e.
during the time when the target replies with a NOT READY status - ASYMMETRIC
ACCESS STATE TRANSITION as shown below:

err = alua_check_sense(sdev, &sense_hdr);
if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
        goto retry;

This causes the host to flood the target with RTPG commands during this
transitioning window (till ALUA_FAILOVER_TIMEOUT fires). This problem is also
applicable to normal block/fs read or write IO that hits the above NOT READY
status, which causes the SCSI ml to retry almost right away (through
scsi_decide_disposition->scsi_check_sense->alua_check_sense which returns
ADD_TO_MLQUEUE).

This may cause targets to be overwhelmed during this ALUA transitioning period,
leading to performance degradation. Ideally, one would want the host to perform
restrained retries during this transitioning period in all relevant code paths
including the alua_rtpg routine.

Restrain retries in the same way already implemented when state =
TPGS_STATE_TRANSITIONING is returned by extended RTPG.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 68adb89..d79e57dd 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -563,8 +563,15 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 		}
 
 		err = alua_check_sense(sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
+		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
+			if (sense_hdr.sense_key == NOT_READY &&
+			    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
+				/* State transition, restrained retry */
+				interval += 2000;
+				msleep(interval);
+			}
 			goto retry;
+		}
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: rtpg sense code %02x/%02x/%02x\n",
 			    ALUA_DH_NAME, sense_hdr.sense_key,
-- 
1.8.3.1

