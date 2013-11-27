Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3K0Qvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:51:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:1373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565Ab3K0QvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:51:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,783,1378882800"; 
   d="scan'208";a="443137822"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Siva Krishna Kumar Reddy Yerramreddy 
	<siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>
Subject: [PATCH char-misc-linus v3 2/6] misc: mic: Minor bug fix in 'retry' loops.
Date: Wed, 27 Nov 2013 08:58:39 -0800
Message-Id: <3804d3e395aaac3ca92a7d39068ccc69ca6cf21f.1385569514.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1385527468.git.ashutosh.dixit@intel.com>
References: <cover.1385527468.git.ashutosh.dixit@intel.com>
In-Reply-To: <cover.1385569514.git.ashutosh.dixit@intel.com>
References: <cover.1385569514.git.ashutosh.dixit@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Dutt <sudeep.dutt@intel.com>

The bug would result in incorrect 'retry' value being printed in debug
statements as well as dead code in mic_find_vqs(...) in
drivers/misc/mic/card/mic_virtio.c.

Reported-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/card/mic_virtio.c |  8 ++++----
 drivers/misc/mic/host/mic_virtio.c | 12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 1ebc51c..4dce912 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -154,14 +154,14 @@ static void mic_reset_inform_host(struct virtio_device *vdev)
 {
 	struct mic_vdev *mvdev = to_micvdev(vdev);
 	struct mic_device_ctrl __iomem *dc = mvdev->dc;
-	int retry = 100, i;
+	int retry;
 
 	iowrite8(0, &dc->host_ack);
 	iowrite8(1, &dc->vdev_reset);
 	mic_send_intr(mvdev->mdev, mvdev->c2h_vdev_db);
 
 	/* Wait till host completes all card accesses and acks the reset */
-	for (i = retry; i--;) {
+	for (retry = 100; retry--;) {
 		if (ioread8(&dc->host_ack))
 			break;
 		msleep(100);
@@ -310,7 +310,7 @@ static int mic_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 {
 	struct mic_vdev *mvdev = to_micvdev(vdev);
 	struct mic_device_ctrl __iomem *dc = mvdev->dc;
-	int i, err, retry = 100;
+	int i, err, retry;
 
 	/* We must have this many virtqueues. */
 	if (nvqs > ioread8(&mvdev->desc->num_vq))
@@ -332,7 +332,7 @@ static int mic_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	 * rings have been re-assigned.
 	 */
 	mic_send_intr(mvdev->mdev, mvdev->c2h_vdev_db);
-	for (i = retry; i--;) {
+	for (retry = 100; retry--;) {
 		if (!ioread8(&dc->used_address_updated))
 			break;
 		msleep(100);
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index 5b8494b..945a3d0 100644
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -378,7 +378,7 @@ int mic_virtio_config_change(struct mic_vdev *mvdev,
 			void __user *argp)
 {
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wake);
-	int ret = 0, retry = 100, i;
+	int ret = 0, retry, i;
 	struct mic_bootparam *bootparam = mvdev->mdev->dp;
 	s8 db = bootparam->h2c_config_db;
 
@@ -401,7 +401,7 @@ int mic_virtio_config_change(struct mic_vdev *mvdev,
 	mvdev->dc->config_change = MIC_VIRTIO_PARAM_CONFIG_CHANGED;
 	mvdev->mdev->ops->send_intr(mvdev->mdev, db);
 
-	for (i = retry; i--;) {
+	for (retry = 100; retry--;) {
 		ret = wait_event_timeout(wake,
 			mvdev->dc->guest_ack, msecs_to_jiffies(100));
 		if (ret)
@@ -639,7 +639,7 @@ void mic_virtio_del_device(struct mic_vdev *mvdev)
 	struct mic_vdev *tmp_mvdev;
 	struct mic_device *mdev = mvdev->mdev;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wake);
-	int i, ret, retry = 100;
+	int i, ret, retry;
 	struct mic_vqconfig *vqconfig;
 	struct mic_bootparam *bootparam = mdev->dp;
 	s8 db;
@@ -652,16 +652,16 @@ void mic_virtio_del_device(struct mic_vdev *mvdev)
 		"Requesting hot remove id %d\n", mvdev->virtio_id);
 	mvdev->dc->config_change = MIC_VIRTIO_PARAM_DEV_REMOVE;
 	mdev->ops->send_intr(mdev, db);
-	for (i = retry; i--;) {
+	for (retry = 100; retry--;) {
 		ret = wait_event_timeout(wake,
 			mvdev->dc->guest_ack, msecs_to_jiffies(100));
 		if (ret)
 			break;
 	}
 	dev_dbg(mdev->sdev->parent,
-		"Device id %d config_change %d guest_ack %d\n",
+		"Device id %d config_change %d guest_ack %d retry %d\n",
 		mvdev->virtio_id, mvdev->dc->config_change,
-		mvdev->dc->guest_ack);
+		mvdev->dc->guest_ack, retry);
 	mvdev->dc->config_change = 0;
 	mvdev->dc->guest_ack = 0;
 skip_hot_remove:
-- 
1.8.2.3

