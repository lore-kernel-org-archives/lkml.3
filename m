Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbaAFXGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:06:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153AbaAFWlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josh Durgin <josh.durgin@inktank.com>, Sage Weil <sage@inktank.com>,
        Alex Elder <elder@linaro.org>
Subject: [PATCH 3.10 113/129] libceph: add function to ensure notifies are complete
Date: Mon,  6 Jan 2014 14:39:02 -0800
Message-Id: <20140106223902.826868994@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ceph/osd_client.h |    2 ++
 net/ceph/osd_client.c           |   11 +++++++++++
 2 files changed, 13 insertions(+)

--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -335,6 +335,8 @@ extern int ceph_osdc_wait_request(struct
 				  struct ceph_osd_request *req);
 extern void ceph_osdc_sync(struct ceph_osd_client *osdc);
 
+extern void ceph_osdc_flush_notifies(struct ceph_osd_client *osdc);
+
 extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
 			       struct ceph_vino vino,
 			       struct ceph_file_layout *layout,
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2209,6 +2209,17 @@ void ceph_osdc_sync(struct ceph_osd_clie
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


