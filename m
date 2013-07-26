Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab3GZVcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:32:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759958Ab3GZUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 56/79] SCSI: mpt3sas: fix for kernel panic when driver loads with HBA conected to non LUN 0 configured expander
Date: Fri, 26 Jul 2013 13:47:46 -0700
Message-Id: <20130726204728.508230929@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

commit b65cfedf4560af65305bd7b3b9f26c02c6fb3660 upstream.

With some enclosures when LUN 0 is not created but LUN 1 or LUN X is created
then SCSI scan procedure calls target_alloc, slave_alloc call back functions
for LUN 0 and slave_destory() for same LUN 0.

In these kind of cases within slave_destroy, pointer to scsi_target in
_sas_device structure is set to NULL, following which when slave_alloc for LUN
1 is called then starget would not be set properly for this LUN.  So,
scsi_target pointer pointing to NULL value would lead to a crash later in the
discovery procedure.

To solve this issue set the sas_device's scsi_target pointer to scsi_device's
scsi_target if it is NULL earlier in slave_alloc callback function.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1273,6 +1273,7 @@ _scsih_slave_alloc(struct scsi_device *s
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_target *starget;
 	struct _raid_device *raid_device;
+	struct _sas_device *sas_device;
 	unsigned long flags;
 
 	sas_device_priv_data = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
@@ -1301,6 +1302,19 @@ _scsih_slave_alloc(struct scsi_device *s
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 	}
 
+	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+					sas_target_priv_data->sas_address);
+		if (sas_device && (sas_device->starget == NULL)) {
+			sdev_printk(KERN_INFO, sdev,
+			"%s : sas_device->starget set to starget @ %d\n",
+				__func__, __LINE__);
+			sas_device->starget = starget;
+		}
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	}
+
 	return 0;
 }
 


