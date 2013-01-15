Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab3AOWoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:44:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:43733 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742Ab3AOWfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 194/221] libceph: dont use rb_init_node() in ceph_osdc_alloc_request()
Date: Tue, 15 Jan 2013 10:52:01 -0800
Message-Id: <20130115185012.039140000@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit a978fa20fb657548561dddbfb605fe43654f0825)

The red-black node in the ceph osd request structure is initialized
in ceph_osdc_alloc_request() using rbd_init_node().  We do need to
initialize this, because in __unregister_request() we call
RB_EMPTY_NODE(), which expects the node it's checking to have
been initialized.  But rb_init_node() is apparently overkill, and
may in fact be on its way out.  So use RB_CLEAR_NODE() instead.

For a little more background, see this commit:
    4c199a93 rbtree: empty nodes have no color"

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -221,6 +221,7 @@ struct ceph_osd_request *ceph_osdc_alloc
 	kref_init(&req->r_kref);
 	init_completion(&req->r_completion);
 	init_completion(&req->r_safe_completion);
+	RB_CLEAR_NODE(&req->r_node);
 	INIT_LIST_HEAD(&req->r_unsafe_item);
 	INIT_LIST_HEAD(&req->r_linger_item);
 	INIT_LIST_HEAD(&req->r_linger_osd);


