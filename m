Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaAMQcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:32:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53409 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaAMQDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Durgin <josh.durgin@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 125/208] libceph: add function to ensure notifies are complete
Date: Mon, 13 Jan 2014 15:59:26 +0000
Message-Id: <1389628849-1614-126-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit dd935f44a40f8fb02aff2cc0df2269c92422df1c upstream.

Without a way to flush the osd client's notify workqueue, a watch
event that is unregistered could continue receiving callbacks
indefinitely.

Unregistering the event simply means no new notifies are added to the
queue, but there may still be events in the queue that will call the
watch callback for the event. If the queue is flushed after the event
is unregistered, the caller can be sure no more watch callbacks will
occur for the canceled watch.

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/ceph/osd_client.h |  2 ++
 net/ceph/osd_client.c           | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index ce6df39..8f47625 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -335,6 +335,8 @@ extern int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
 				  struct ceph_osd_request *req);
 extern void ceph_osdc_sync(struct ceph_osd_client *osdc);
 
+extern void ceph_osdc_flush_notifies(struct ceph_osd_client *osdc);
+
 extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
 			       struct ceph_vino vino,
 			       struct ceph_file_layout *layout,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 0c49ec4..1ee21cd 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2209,6 +2209,17 @@ void ceph_osdc_sync(struct ceph_osd_client *osdc)
 EXPORT_SYMBOL(ceph_osdc_sync);
 
 /*
+ * Call all pending notify callbacks - for use after a watch is
+ * unregistered, to make sure no more callbacks for it will be invoked
+ */
+extern void ceph_osdc_flush_notifies(struct ceph_osd_client *osdc)
+{
+	flush_workqueue(osdc->notify_wq);
+}
+EXPORT_SYMBOL(ceph_osdc_flush_notifies);
+
+
+/*
  * init, shutdown
  */
 int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
-- 
1.8.3.2

