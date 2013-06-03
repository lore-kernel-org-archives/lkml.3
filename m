Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab3FCWWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:22:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20804 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784Ab3FCWL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:11:59 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=pmMIZtSJ5KsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VcHyjQdWaU8A:10 a=tmtSDGaQAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=B9-N0CrjNPqreQ1gjakA:9 a=jkObVMfX7fAA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221154.159834794@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ric Wheeler <rwheeler@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [12/65] sd: fix array cache flushing bug causing performance problems
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0012-sd-fix-array-cache-flushing-bug-causing-performance-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

[ Upstream commit 39c60a0948cc06139e2fbfe084f83cb7e7deae3b ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/sd.c |   20 ++++++++++++++++++++
 drivers/scsi/sd.h |    1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..88ced02 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -141,6 +141,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	char *buffer_data;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
+	const char *temp = "temporary ";
 	int len;
 
 	if (sdp->type != TYPE_DISK)
@@ -149,6 +150,13 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
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
@@ -161,6 +169,13 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
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
@@ -2127,6 +2142,10 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	int old_rcd = sdkp->RCD;
 	int old_dpofua = sdkp->DPOFUA;
 
+
+	if (sdkp->cache_override)
+		return;
+
 	first_len = 4;
 	if (sdp->skip_ms_page_8) {
 		if (sdp->type == TYPE_RBC)
@@ -2613,6 +2632,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	sdkp->capacity = 0;
 	sdkp->media_present = 1;
 	sdkp->write_prot = 0;
+	sdkp->cache_override = 0;
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 	sdkp->ATO = 0;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f703f48..e2b2956 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -67,6 +67,7 @@ struct scsi_disk {
 	u8		protection_type;/* Data Integrity Field */
 	u8		provisioning_mode;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
+	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
-- 
1.7.10.4


