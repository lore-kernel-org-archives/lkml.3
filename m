Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab3E1Vmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:42:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59537 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab3E1VVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 12/78] [SCSI] sd: fix array cache flushing bug causing performance problems
Date: Tue, 28 May 2013 14:19:21 -0700
Message-Id: <1369776027-17859-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit 39c60a0948cc06139e2fbfe084f83cb7e7deae3b upstream.

Some arrays synchronize their full non volatile cache when the sd driver sends
a SYNCHRONIZE CACHE command.  Unfortunately, they can have Terrabytes of this
and we send a SYNCHRONIZE CACHE for every barrier if an array reports it has a
writeback cache.  This leads to massive slowdowns on journalled filesystems.

The fix is to allow userspace to turn off the writeback cache setting as a
temporary measure (i.e. without doing the MODE SELECT to write it back to the
device), so even though the device reported it has a writeback cache, the
user, knowing that the cache is non volatile and all they care about is
filesystem correctness, can turn that bit off in the kernel and avoid the
performance ruinous (and safety irrelevant) SYNCHRONIZE CACHE commands.

The way you do this is add a 'temporary' prefix when performing the usual
cache setting operations, so

echo temporary write through > /sys/class/scsi_disk/<disk>/cache_type

Reported-by: Ric Wheeler <rwheeler@redhat.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/sd.c | 20 ++++++++++++++++++++
 drivers/scsi/sd.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..82910cc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -142,6 +142,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	char *buffer_data;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
+	const char *temp = "temporary ";
 	int len;
 
 	if (sdp->type != TYPE_DISK)
@@ -150,6 +151,13 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 		 * it's not worth the risk */
 		return -EINVAL;
 
+	if (strncmp(buf, temp, sizeof(temp) - 1) == 0) {
+		buf += sizeof(temp) - 1;
+		sdkp->cache_override = 1;
+	} else {
+		sdkp->cache_override = 0;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(sd_cache_types); i++) {
 		len = strlen(sd_cache_types[i]);
 		if (strncmp(sd_cache_types[i], buf, len) == 0 &&
@@ -162,6 +170,13 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	rcd = ct & 0x01 ? 1 : 0;
 	wce = ct & 0x02 ? 1 : 0;
+
+	if (sdkp->cache_override) {
+		sdkp->WCE = wce;
+		sdkp->RCD = rcd;
+		return count;
+	}
+
 	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
 			    SD_MAX_RETRIES, &data, NULL))
 		return -EINVAL;
@@ -2319,6 +2334,10 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	int old_rcd = sdkp->RCD;
 	int old_dpofua = sdkp->DPOFUA;
 
+
+	if (sdkp->cache_override)
+		return;
+
 	first_len = 4;
 	if (sdp->skip_ms_page_8) {
 		if (sdp->type == TYPE_RBC)
@@ -2812,6 +2831,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	sdkp->capacity = 0;
 	sdkp->media_present = 1;
 	sdkp->write_prot = 0;
+	sdkp->cache_override = 0;
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 	sdkp->ATO = 0;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 74a1e4c..2386aeb 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -73,6 +73,7 @@ struct scsi_disk {
 	u8		protection_type;/* Data Integrity Field */
 	u8		provisioning_mode;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
+	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
-- 
1.8.1.2

