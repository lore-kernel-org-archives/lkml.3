Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab3EQWU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:20:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab3EQVhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ric Wheeler <rwheeler@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 030/102] SCSI: sd: fix array cache flushing bug causing performance problems
Date: Fri, 17 May 2013 14:35:45 -0700
Message-Id: <20130517213247.513216554@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |   20 ++++++++++++++++++++
 drivers/scsi/sd.h |    1 +
 2 files changed, 21 insertions(+)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -142,6 +142,7 @@ sd_store_cache_type(struct device *dev,
 	char *buffer_data;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
+	const char *temp = "temporary ";
 	int len;
 
 	if (sdp->type != TYPE_DISK)
@@ -150,6 +151,13 @@ sd_store_cache_type(struct device *dev,
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
@@ -162,6 +170,13 @@ sd_store_cache_type(struct device *dev,
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
@@ -2319,6 +2334,10 @@ sd_read_cache_type(struct scsi_disk *sdk
 	int old_rcd = sdkp->RCD;
 	int old_dpofua = sdkp->DPOFUA;
 
+
+	if (sdkp->cache_override)
+		return;
+
 	first_len = 4;
 	if (sdp->skip_ms_page_8) {
 		if (sdp->type == TYPE_RBC)
@@ -2812,6 +2831,7 @@ static void sd_probe_async(void *data, a
 	sdkp->capacity = 0;
 	sdkp->media_present = 1;
 	sdkp->write_prot = 0;
+	sdkp->cache_override = 0;
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 	sdkp->ATO = 0;
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


