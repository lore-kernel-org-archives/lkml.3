Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaBUAAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:00:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbaBTXyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:54:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH 3.13 85/99] misc: mic: fix possible signed underflow (undefined behavior) in userspace API
Date: Thu, 20 Feb 2014 15:53:20 -0800
Message-Id: <20140220235120.667780237@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Dutt <sudeep.dutt@intel.com>

commit 3b1cc9b9622a022208ec95b1259b05bbdf712eb7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mic/host/mic_virtio.c |    3 ++-
 include/uapi/linux/mic_ioctl.h     |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -156,7 +156,8 @@ static int mic_vringh_copy(struct mic_vd
 static int _mic_virtio_copy(struct mic_vdev *mvdev,
 	struct mic_copy_desc *copy)
 {
-	int ret = 0, iovcnt = copy->iovcnt;
+	int ret = 0;
+	u32 iovcnt = copy->iovcnt;
 	struct iovec iov;
 	struct iovec __user *u_iov = copy->iov;
 	void __user *ubuf = NULL;
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


