Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3KHC0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:26:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34896 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab3KHCVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:55 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 64/91] vhost/scsi: Fix incorrect usage of get_user_pages_fast write parameter
Date: Thu,  7 Nov 2013 18:15:19 -0800
Message-Id: <1383876946-2396-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (applied to tcm_vhost.c) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/vhost/tcm_vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/tcm_vhost.c b/drivers/vhost/tcm_vhost.c
index 22321cf..9412440 100644
--- a/drivers/vhost/tcm_vhost.c
+++ b/drivers/vhost/tcm_vhost.c
@@ -696,7 +696,7 @@ static void vhost_scsi_handle_vq(struct vhost_scsi *vs)
 		if (data_direction != DMA_NONE) {
 			ret = vhost_scsi_map_iov_to_sgl(tv_cmd,
 					&vq->iov[data_first], data_num,
-					data_direction == DMA_TO_DEVICE);
+					data_direction == DMA_FROM_DEVICE);
 			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to sgl\n");
 				break; /* TODO */
-- 
1.8.1.2

