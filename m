Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab3KIHeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:34:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327Ab3KIGuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 32/74] vhost/scsi: Fix incorrect usage of get_user_pages_fast write parameter
Date: Fri,  8 Nov 2013 22:51:37 -0800
Message-Id: <20131109065115.774268642@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 60a01f558af9c48b0bb31f303c479e32721add3f upstream.

This patch addresses a long-standing bug where the get_user_pages_fast()
write parameter used for setting the underlying page table entry permission
bits was incorrectly set to write=1 for data_direction=DMA_TO_DEVICE, and
passed into get_user_pages_fast() via vhost_scsi_map_iov_to_sgl().

However, this parameter is intended to signal WRITEs to pinned userspace
PTEs for the virtio-scsi DMA_FROM_DEVICE -> READ payload case, and *not*
for the virtio-scsi DMA_TO_DEVICE -> WRITE payload case.

This bug would manifest itself as random process segmentation faults on
KVM host after repeated vhost starts + stops and/or with lots of vhost
endpoints + LUNs.

Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Asias He <asias@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1017,7 +1017,7 @@ static void vhost_scsi_handle_vq(struct
 		if (data_direction != DMA_NONE) {
 			ret = vhost_scsi_map_iov_to_sgl(tv_cmd,
 					&vq->iov[data_first], data_num,
-					data_direction == DMA_TO_DEVICE);
+					data_direction == DMA_FROM_DEVICE);
 			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to sgl\n");
 				goto err_free;


