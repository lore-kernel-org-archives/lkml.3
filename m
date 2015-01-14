Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbbANHfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:35:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745AbbANHfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:35:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>,
        Markus Blank-Burian <burian@muenster.de>
Subject: [PATCH 3.14 53/77] ceph: fix null pointer dereference in discard_cap_releases()
Date: Tue, 13 Jan 2015 23:23:33 -0800
Message-Id: <20150114072227.167146869@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit 00bd8edb861eb41d274938cfc0338999d9c593a3 upstream.

send_mds_reconnect() may call discard_cap_releases() after all
release messages have been dropped by cleanup_cap_releases()

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Cc: Markus Blank-Burian <burian@muenster.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/mds_client.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1461,15 +1461,18 @@ static void discard_cap_releases(struct
 
 	dout("discard_cap_releases mds%d\n", session->s_mds);
 
-	/* zero out the in-progress message */
-	msg = list_first_entry(&session->s_cap_releases,
-			       struct ceph_msg, list_head);
-	head = msg->front.iov_base;
-	num = le32_to_cpu(head->num);
-	dout("discard_cap_releases mds%d %p %u\n", session->s_mds, msg, num);
-	head->num = cpu_to_le32(0);
-	msg->front.iov_len = sizeof(*head);
-	session->s_num_cap_releases += num;
+	if (!list_empty(&session->s_cap_releases)) {
+		/* zero out the in-progress message */
+		msg = list_first_entry(&session->s_cap_releases,
+					struct ceph_msg, list_head);
+		head = msg->front.iov_base;
+		num = le32_to_cpu(head->num);
+		dout("discard_cap_releases mds%d %p %u\n",
+		     session->s_mds, msg, num);
+		head->num = cpu_to_le32(0);
+		msg->front.iov_len = sizeof(*head);
+		session->s_num_cap_releases += num;
+	}
 
 	/* requeue completed messages */
 	while (!list_empty(&session->s_cap_releases_done)) {


