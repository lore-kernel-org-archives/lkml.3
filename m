Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab3APQCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:02:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab3APQB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 071/222] s390/cio: fix pgid reserved check
Date: Wed, 16 Jan 2013 13:54:31 -0200
Message-Id: <1358351822-7675-72-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/s390/cio/device_pgid.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/device_pgid.c b/drivers/s390/cio/device_pgid.c
index 07a4fd2..daa6b90 100644
--- a/drivers/s390/cio/device_pgid.c
+++ b/drivers/s390/cio/device_pgid.c
@@ -234,7 +234,7 @@ static int pgid_cmp(struct pgid *p1, struct pgid *p2)
  * Determine pathgroup state from PGID data.
  */
 static void pgid_analyze(struct ccw_device *cdev, struct pgid **p,
-			 int *mismatch, int *reserved, u8 *reset)
+			 int *mismatch, u8 *reserved, u8 *reset)
 {
 	struct pgid *pgid = &cdev->private->pgid[0];
 	struct pgid *first = NULL;
@@ -248,7 +248,7 @@ static void pgid_analyze(struct ccw_device *cdev, struct pgid **p,
 		if ((cdev->private->pgid_valid_mask & lpm) == 0)
 			continue;
 		if (pgid->inf.ps.state2 == SNID_STATE2_RESVD_ELSE)
-			*reserved = 1;
+			*reserved |= lpm;
 		if (pgid_is_reset(pgid)) {
 			*reset |= lpm;
 			continue;
@@ -316,14 +316,14 @@ static void snid_done(struct ccw_device *cdev, int rc)
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
@@ -336,7 +336,7 @@ static void snid_done(struct ccw_device *cdev, int rc)
 	}
 out:
 	CIO_MSG_EVENT(2, "snid: device 0.%x.%04x: rc=%d pvm=%02x vpm=%02x "
-		      "todo=%02x mism=%d rsvd=%d reset=%02x\n", id->ssid,
+		      "todo=%02x mism=%d rsvd=%02x reset=%02x\n", id->ssid,
 		      id->devno, rc, cdev->private->pgid_valid_mask, sch->vpm,
 		      cdev->private->pgid_todo_mask, mismatch, reserved, reset);
 	switch (rc) {
-- 
1.7.9.5

