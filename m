Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbaBEUja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:39:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:55149 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaBEUGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 122/213] fix Null pointer dereference on disk error
Date: Wed, 5 Feb 2014 15:01:17 -0500
Message-ID: <1391630568-49251-123-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <xtfeng@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 26cd4d65deba587f3cf2329b6869ce02bcbe68ec upstream.

Following oops were observed when disk error happened:

[ 4272.896937] sd 0:0:0:0: [sda] Unhandled error code
[ 4272.896939] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4272.896942] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 5a de a7 00 00 08 00
[ 4272.896951] end_request: I/O error, dev sda, sector 5955239
[ 4291.574947] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 4291.658305] IP: [] ahci_activity_show+0x1/0x40
[ 4291.730090] PGD 76dbbc067 PUD 6c4fba067 PMD 0
[ 4291.783408] Oops: 0000 [#1] SMP
[ 4291.822100] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/sw_activity
[ 4291.934235] CPU 9
[ 4291.958301] Pid: 27942, comm: hwinfo ......

ata_scsi_find_dev could return NULL, so ata_scsi_activity_{show,store} should check if atadev is NULL.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/ata/libata-scsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0dfa46877e39..191b375df95e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -339,7 +339,8 @@ ata_scsi_activity_show(struct device *dev, struct device_attribute *attr,
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
 
-	if (ap->ops->sw_activity_show && (ap->flags & ATA_FLAG_SW_ACTIVITY))
+	if (atadev && ap->ops->sw_activity_show &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY))
 		return ap->ops->sw_activity_show(atadev, buf);
 	return -EINVAL;
 }
@@ -354,7 +355,8 @@ ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
 	enum sw_activity val;
 	int rc;
 
-	if (ap->ops->sw_activity_store && (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
+	if (atadev && ap->ops->sw_activity_store &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
 		val = simple_strtoul(buf, NULL, 0);
 		switch (val) {
 		case OFF: case BLINK_ON: case BLINK_OFF:
-- 
1.8.5.2

