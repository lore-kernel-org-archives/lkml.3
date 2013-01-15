Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042Ab3AOXSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:18:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:47409 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933757Ab3AOWxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>
Subject: [ 164/171] ceph: Fix infinite loop in __wake_requests
Date: Tue, 15 Jan 2013 14:45:29 -0800
Message-Id: <20130115224325.155970120@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Yan, Zheng" <zheng.z.yan@intel.com>

__wake_requests() will enter infinite loop if we use it to wake
requests in the session->s_waiting list. __wake_requests() deletes
requests from the list and __do_request() adds requests back to
the list.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
(cherry picked from commit ed75ec2cd19b47efcd292b6e23f58e56f4c5bc34)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1886,9 +1886,14 @@ finish:
 static void __wake_requests(struct ceph_mds_client *mdsc,
 			    struct list_head *head)
 {
-	struct ceph_mds_request *req, *nreq;
+	struct ceph_mds_request *req;
+	LIST_HEAD(tmp_list);
 
-	list_for_each_entry_safe(req, nreq, head, r_wait) {
+	list_splice_init(head, &tmp_list);
+
+	while (!list_empty(&tmp_list)) {
+		req = list_entry(tmp_list.next,
+				 struct ceph_mds_request, r_wait);
 		list_del_init(&req->r_wait);
 		__do_request(mdsc, req);
 	}


