Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaBCWyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:54:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:23506 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaBCWx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:53:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,775,1384329600"; 
   d="scan'208";a="469316101"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>
Subject: [PATCH char-misc-linus] misc: mic: fix possible signed underflow (undefined behavior) in userspace API
Date: Mon,  3 Feb 2014 14:53:19 -0800
Message-Id: <a40665dc7ea26c79337408bece3dc6af2846fc1a.1391408255.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iovcnt is declared as a signed integer in both the userspace API and
as a local variable in mic_virtio.c. The while() loop in mic_virtio.c
iterates until the local variable iovcnt reaches the value 0. If
userspace passes e.g. INT_MIN as iovcnt field, this loop then appears
to depend on an undefined behavior (signed underflow) to complete.
The fix is to use unsigned integers in both the userspace API and
the local variable.

This issue was reported @ https://lkml.org/lkml/2014/1/10/10

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/host/mic_virtio.c | 3 ++-
 include/uapi/linux/mic_ioctl.h     | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index 752ff87..7e1ef0e 100644
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -156,7 +156,8 @@ static int mic_vringh_copy(struct mic_vdev *mvdev, struct vringh_kiov *iov,
 static int _mic_virtio_copy(struct mic_vdev *mvdev,
 	struct mic_copy_desc *copy)
 {
-	int ret = 0, iovcnt = copy->iovcnt;
+	int ret = 0;
+	u32 iovcnt = copy->iovcnt;
 	struct iovec iov;
 	struct iovec __user *u_iov = copy->iov;
 	void __user *ubuf = NULL;
diff --git a/include/uapi/linux/mic_ioctl.h b/include/uapi/linux/mic_ioctl.h
index 7fabba5..feb0b4c 100644
--- a/include/uapi/linux/mic_ioctl.h
+++ b/include/uapi/linux/mic_ioctl.h
@@ -39,7 +39,7 @@ struct mic_copy_desc {
 #else
 	struct iovec *iov;
 #endif
-	int iovcnt;
+	__u32 iovcnt;
 	__u8 vr_idx;
 	__u8 update_used;
 	__u32 out_len;
-- 
1.8.2.1

