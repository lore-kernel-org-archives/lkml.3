Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054Ab3AOWyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:54:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:47602 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933925Ab3AOWyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:54:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 03/71] s390/cio: fix pgid reserved check
Date: Tue, 15 Jan 2013 14:54:00 -0800
Message-Id: <20130115225340.634562767@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

commit d99e79ec5574fc556c988f613ed6175f6de66f4a upstream.

The check to whom a device is reserved is done by checking the path
state of the affected channel paths. If it turns out that one path is
flagged as reserved by someone else the whole device is marked as such.

However the meaning of the RESVD_ELSE bit is that the addressed device
is reserved to a different pathgroup (and not reserved to a different
LPAR). If we do this test on a path which is currently not a member of
the pathgroup we could erroneously mark the device as reserved to
someone else.

To fix this collect the reserved state for all potential members of the
pathgroup and only mark the device as reserved if all of those potential
members have the RESVD_ELSE bit set.

Acked-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/cio/device_pgid.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/s390/cio/device_pgid.c
+++ b/drivers/s390/cio/device_pgid.c
@@ -234,7 +234,7 @@ static int pgid_cmp(struct pgid *p1, str
  * Determine pathgroup state from PGID data.
  */
 static void pgid_analyze(struct ccw_device *cdev, struct pgid **p,
-			 int *mismatch, int *reserved, u8 *reset)
+			 int *mismatch, u8 *reserved, u8 *reset)
 {
 	struct pgid *pgid = &cdev->private->pgid[0];
 	struct pgid *first = NULL;
@@ -248,7 +248,7 @@ static void pgid_analyze(struct ccw_devi
 		if ((cdev->private->pgid_valid_mask & lpm) == 0)
 			continue;
 		if (pgid->inf.ps.state2 == SNID_STATE2_RESVD_ELSE)
-			*reserved = 1;
+			*reserved |= lpm;
 		if (pgid_is_reset(pgid)) {
 			*reset |= lpm;
 			continue;
@@ -316,14 +316,14 @@ static void snid_done(struct ccw_device
 	struct subchannel *sch = to_subchannel(cdev->dev.parent);
 	struct pgid *pgid;
 	int mismatch = 0;
-	int reserved = 0;
+	u8 reserved = 0;
 	u8 reset = 0;
 	u8 donepm;
 
 	if (rc)
 		goto out;
 	pgid_analyze(cdev, &pgid, &mismatch, &reserved, &reset);
-	if (reserved)
+	if (reserved == cdev->private->pgid_valid_mask)
 		rc = -EUSERS;
 	else if (mismatch)
 		rc = -EOPNOTSUPP;
@@ -336,7 +336,7 @@ static void snid_done(struct ccw_device
 	}
 out:
 	CIO_MSG_EVENT(2, "snid: device 0.%x.%04x: rc=%d pvm=%02x vpm=%02x "
-		      "todo=%02x mism=%d rsvd=%d reset=%02x\n", id->ssid,
+		      "todo=%02x mism=%d rsvd=%02x reset=%02x\n", id->ssid,
 		      id->devno, rc, cdev->private->pgid_valid_mask, sch->vpm,
 		      cdev->private->pgid_todo_mask, mismatch, reserved, reset);
 	switch (rc) {


