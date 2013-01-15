Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab3AOW2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:28:02 -0500
Received: from mail.kernel.org ([198.145.19.201]:41305 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551Ab3AOW17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:27:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Xiaotian Feng <dannyfeng@tencent.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 047/221] libata: fix Null pointer dereference on disk error
Date: Tue, 15 Jan 2013 10:49:34 -0800
Message-Id: <20130115185001.417548552@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/ata/libata-scsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -309,7 +309,8 @@ ata_scsi_activity_show(struct device *de
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
 
-	if (ap->ops->sw_activity_show && (ap->flags & ATA_FLAG_SW_ACTIVITY))
+	if (atadev && ap->ops->sw_activity_show &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY))
 		return ap->ops->sw_activity_show(atadev, buf);
 	return -EINVAL;
 }
@@ -324,7 +325,8 @@ ata_scsi_activity_store(struct device *d
 	enum sw_activity val;
 	int rc;
 
-	if (ap->ops->sw_activity_store && (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
+	if (atadev && ap->ops->sw_activity_store &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
 		val = simple_strtoul(buf, NULL, 0);
 		switch (val) {
 		case OFF: case BLINK_ON: case BLINK_OFF:


