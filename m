Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbbAJGmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 01:42:42 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:60072
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbbAJGm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 01:42:27 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 6/6] Drivers: hv: vmbus: Support a vmbus API for efficiently sending page arrays
Date: Fri,  9 Jan 2015 23:54:34 -0800
Message-Id: <1420876474-9205-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1420876474-9205-1-git-send-email-kys@microsoft.com>
References: <1420876440-9164-1-git-send-email-kys@microsoft.com>
 <1420876474-9205-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the API for sending a multi-page buffer over VMBUS is limited to
a maximum pfn array of MAX_MULTIPAGE_BUFFER_COUNT. This limitation is
not imposed by the host and unnecessarily limits the maximum payload
that can be sent. Implement an API that does not have this restriction.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel.c   |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hyperv.h |   31 +++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index c76ffbe..18c4f23 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -686,6 +686,50 @@ EXPORT_SYMBOL_GPL(vmbus_sendpacket_pagebuffer);
 /*
  * vmbus_sendpacket_multipagebuffer - Send a multi-page buffer packet
  * using a GPADL Direct packet type.
+ * The buffer includes the vmbus descriptor.
+ */
+int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
+			      struct vmbus_packet_mpb_array *desc,
+			      u32 desc_size,
+			      void *buffer, u32 bufferlen, u64 requestid)
+{
+	int ret;
+	u32 packetlen;
+	u32 packetlen_aligned;
+	struct kvec bufferlist[3];
+	u64 aligned_data = 0;
+	bool signal = false;
+
+	packetlen = desc_size + bufferlen;
+	packetlen_aligned = ALIGN(packetlen, sizeof(u64));
+
+	/* Setup the descriptor */
+	desc->type = VM_PKT_DATA_USING_GPA_DIRECT;
+	desc->flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
+	desc->dataoffset8 = desc_size >> 3; /* in 8-bytes grandularity */
+	desc->length8 = (u16)(packetlen_aligned >> 3);
+	desc->transactionid = requestid;
+	desc->rangecount = 1;
+
+	bufferlist[0].iov_base = desc;
+	bufferlist[0].iov_len = desc_size;
+	bufferlist[1].iov_base = buffer;
+	bufferlist[1].iov_len = bufferlen;
+	bufferlist[2].iov_base = &aligned_data;
+	bufferlist[2].iov_len = (packetlen_aligned - packetlen);
+
+	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3, &signal);
+
+	if (ret == 0 && signal)
+		vmbus_setevent(channel);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vmbus_sendpacket_mpb_desc);
+
+/*
+ * vmbus_sendpacket_multipagebuffer - Send a multi-page buffer packet
+ * using a GPADL Direct packet type.
  */
 int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 				struct hv_multipage_buffer *multi_pagebuffer,
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 476c685..259023a 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -57,6 +57,18 @@ struct hv_multipage_buffer {
 	u64 pfn_array[MAX_MULTIPAGE_BUFFER_COUNT];
 };
 
+/*
+ * Multiple-page buffer array; the pfn array is variable size:
+ * The number of entries in the PFN array is determined by
+ * "len" and "offset".
+ */
+struct hv_mpb_array {
+	/* Length and Offset determines the # of pfns in the array */
+	u32 len;
+	u32 offset;
+	u64 pfn_array[];
+};
+
 /* 0x18 includes the proprietary packet header */
 #define MAX_PAGE_BUFFER_PACKET		(0x18 +			\
 					(sizeof(struct hv_page_buffer) * \
@@ -814,6 +826,18 @@ struct vmbus_channel_packet_multipage_buffer {
 	struct hv_multipage_buffer range;
 } __packed;
 
+/* The format must be the same as struct vmdata_gpa_direct */
+struct vmbus_packet_mpb_array {
+	u16 type;
+	u16 dataoffset8;
+	u16 length8;
+	u16 flags;
+	u64 transactionid;
+	u32 reserved;
+	u32 rangecount;         /* Always 1 in this case */
+	struct hv_mpb_array range;
+} __packed;
+
 
 extern int vmbus_open(struct vmbus_channel *channel,
 			    u32 send_ringbuffersize,
@@ -845,6 +869,13 @@ extern int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 					u32 bufferlen,
 					u64 requestid);
 
+extern int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
+				     struct vmbus_packet_mpb_array *mpb,
+				     u32 desc_size,
+				     void *buffer,
+				     u32 bufferlen,
+				     u64 requestid);
+
 extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
 				      void *kbuffer,
 				      u32 size,
-- 
1.7.4.1

