Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3FDXLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:11:40 -0400
Received: from 1wt.eu ([62.212.114.60]:35487 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab3FDWm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:29 -0400
Message-Id: <20130604172133.497585069@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Xiaotian Feng <dannyfeng@tencent.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 077/184] libata: fix Null pointer dereference on disk error
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaotian Feng <xtfeng@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/ata/libata-scsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 553edcc..57e895a1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -338,7 +338,8 @@ ata_scsi_activity_show(struct device *dev, struct device_attribute *attr,
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
 
-	if (ap->ops->sw_activity_show && (ap->flags & ATA_FLAG_SW_ACTIVITY))
+	if (atadev && ap->ops->sw_activity_show &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY))
 		return ap->ops->sw_activity_show(atadev, buf);
 	return -EINVAL;
 }
@@ -353,7 +354,8 @@ ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
 	enum sw_activity val;
 	int rc;
 
-	if (ap->ops->sw_activity_store && (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
+	if (atadev && ap->ops->sw_activity_store &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
 		val = simple_strtoul(buf, NULL, 0);
 		switch (val) {
 		case OFF: case BLINK_ON: case BLINK_OFF:
-- 
1.7.12.2.21.g234cd45.dirty



