Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbaBBCMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 21:12:08 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:52744
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaBBCMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 21:12:06 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Cleanup the packet send path
Date: Sat,  1 Feb 2014 19:02:20 -0800
Message-Id: <1391310140-20424-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current channel code is using scatterlist abstraction to pass data to the
ringbuffer API on the send path. This causes unnecessary translations
between virtual and physical addresses. Fix this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel.c      |   42 +++++++++++++++++++++++-------------------
 drivers/hv/hyperv_vmbus.h |    4 ++--
 drivers/hv/ring_buffer.c  |   17 +++++++----------
 include/linux/hyperv.h    |    2 +-
 4 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 69ea36f..602ca86 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/hyperv.h>
+#include <linux/uio.h>
 
 #include "hyperv_vmbus.h"
 
@@ -554,14 +555,14 @@ EXPORT_SYMBOL_GPL(vmbus_close);
  *
  * Mainly used by Hyper-V drivers.
  */
-int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
+int vmbus_sendpacket(struct vmbus_channel *channel, void *buffer,
 			   u32 bufferlen, u64 requestid,
 			   enum vmbus_packet_type type, u32 flags)
 {
 	struct vmpacket_descriptor desc;
 	u32 packetlen = sizeof(struct vmpacket_descriptor) + bufferlen;
 	u32 packetlen_aligned = ALIGN(packetlen, sizeof(u64));
-	struct scatterlist bufferlist[3];
+	struct kvec bufferlist[3];
 	u64 aligned_data = 0;
 	int ret;
 	bool signal = false;
@@ -575,11 +576,12 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	desc.len8 = (u16)(packetlen_aligned >> 3);
 	desc.trans_id = requestid;
 
-	sg_init_table(bufferlist, 3);
-	sg_set_buf(&bufferlist[0], &desc, sizeof(struct vmpacket_descriptor));
-	sg_set_buf(&bufferlist[1], buffer, bufferlen);
-	sg_set_buf(&bufferlist[2], &aligned_data,
-		   packetlen_aligned - packetlen);
+	bufferlist[0].iov_base = &desc;
+	bufferlist[0].iov_len = sizeof(struct vmpacket_descriptor);
+	bufferlist[1].iov_base = buffer;
+	bufferlist[1].iov_len = bufferlen;
+	bufferlist[2].iov_base = &aligned_data;
+	bufferlist[2].iov_len = (packetlen_aligned - packetlen);
 
 	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3, &signal);
 
@@ -605,7 +607,7 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	u32 descsize;
 	u32 packetlen;
 	u32 packetlen_aligned;
-	struct scatterlist bufferlist[3];
+	struct kvec bufferlist[3];
 	u64 aligned_data = 0;
 	bool signal = false;
 
@@ -637,11 +639,12 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 		desc.range[i].pfn	 = pagebuffers[i].pfn;
 	}
 
-	sg_init_table(bufferlist, 3);
-	sg_set_buf(&bufferlist[0], &desc, descsize);
-	sg_set_buf(&bufferlist[1], buffer, bufferlen);
-	sg_set_buf(&bufferlist[2], &aligned_data,
-		packetlen_aligned - packetlen);
+	bufferlist[0].iov_base = &desc;
+	bufferlist[0].iov_len = descsize;
+	bufferlist[1].iov_base = buffer;
+	bufferlist[1].iov_len = bufferlen;
+	bufferlist[2].iov_base = &aligned_data;
+	bufferlist[2].iov_len = (packetlen_aligned - packetlen);
 
 	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3, &signal);
 
@@ -665,7 +668,7 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	u32 descsize;
 	u32 packetlen;
 	u32 packetlen_aligned;
-	struct scatterlist bufferlist[3];
+	struct kvec bufferlist[3];
 	u64 aligned_data = 0;
 	bool signal = false;
 	u32 pfncount = NUM_PAGES_SPANNED(multi_pagebuffer->offset,
@@ -700,11 +703,12 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	memcpy(desc.range.pfn_array, multi_pagebuffer->pfn_array,
 	       pfncount * sizeof(u64));
 
-	sg_init_table(bufferlist, 3);
-	sg_set_buf(&bufferlist[0], &desc, descsize);
-	sg_set_buf(&bufferlist[1], buffer, bufferlen);
-	sg_set_buf(&bufferlist[2], &aligned_data,
-		packetlen_aligned - packetlen);
+	bufferlist[0].iov_base = &desc;
+	bufferlist[0].iov_len = descsize;
+	bufferlist[1].iov_base = buffer;
+	bufferlist[1].iov_len = bufferlen;
+	bufferlist[2].iov_base = &aligned_data;
+	bufferlist[2].iov_len = (packetlen_aligned - packetlen);
 
 	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3, &signal);
 
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index e055176..1544609 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -559,8 +559,8 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info, void *buffer,
 void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
 
 int hv_ringbuffer_write(struct hv_ring_buffer_info *ring_info,
-		    struct scatterlist *sglist,
-		    u32 sgcount, bool *signal);
+		    struct kvec *kv_list,
+		    u32 kv_count, bool *signal);
 
 int hv_ringbuffer_peek(struct hv_ring_buffer_info *ring_info, void *buffer,
 		   u32 buflen);
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 26c93cf..15db66b 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/hyperv.h>
+#include <linux/uio.h>
 
 #include "hyperv_vmbus.h"
 
@@ -387,23 +388,20 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
  *
  */
 int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
-		    struct scatterlist *sglist, u32 sgcount, bool *signal)
+		    struct kvec *kv_list, u32 kv_count, bool *signal)
 {
 	int i = 0;
 	u32 bytes_avail_towrite;
 	u32 bytes_avail_toread;
 	u32 totalbytes_towrite = 0;
 
-	struct scatterlist *sg;
 	u32 next_write_location;
 	u32 old_write;
 	u64 prev_indices = 0;
 	unsigned long flags;
 
-	for_each_sg(sglist, sg, sgcount, i)
-	{
-		totalbytes_towrite += sg->length;
-	}
+	for (i = 0; i < kv_count; i++)
+		totalbytes_towrite += kv_list[i].iov_len;
 
 	totalbytes_towrite += sizeof(u64);
 
@@ -427,12 +425,11 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 
 	old_write = next_write_location;
 
-	for_each_sg(sglist, sg, sgcount, i)
-	{
+	for (i = 0; i < kv_count; i++) {
 		next_write_location = hv_copyto_ringbuffer(outring_info,
 						     next_write_location,
-						     sg_virt(sg),
-						     sg->length);
+						     kv_list[i].iov_base,
+						     kv_list[i].iov_len);
 	}
 
 	/* Set previous packet start */
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 15da677..830f3d6 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1118,7 +1118,7 @@ extern int vmbus_open(struct vmbus_channel *channel,
 extern void vmbus_close(struct vmbus_channel *channel);
 
 extern int vmbus_sendpacket(struct vmbus_channel *channel,
-				  const void *buffer,
+				  void *buffer,
 				  u32 bufferLen,
 				  u64 requestid,
 				  enum vmbus_packet_type type,
-- 
1.7.4.1

