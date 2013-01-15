Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab3AOXUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:20:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:47350 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933868Ab3AOWxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>
Subject: [ 158/171] ceph: dont reference req after put
Date: Tue, 15 Jan 2013 14:45:23 -0800
Message-Id: <20130115224324.735579554@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

In __unregister_request(), there is a call to list_del_init()
referencing a request that was the subject of a call to
ceph_osdc_put_request() on the previous line.  This is not
safe, because the request structure could have been freed
by the time we reach the list_del_init().

Fix this by reversing the order of these lines.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-off-by: Sage Weil <sage@inktank.com>
(cherry picked from commit 7d5f24812bd182a2471cb69c1c2baf0648332e1f)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -871,9 +871,9 @@ static void __unregister_request(struct
 			req->r_osd = NULL;
 	}
 
+	list_del_init(&req->r_req_lru_item);
 	ceph_osdc_put_request(req);
 
-	list_del_init(&req->r_req_lru_item);
 	if (osdc->num_requests == 0) {
 		dout(" no requests, canceling timeout\n");
 		__cancel_osd_timeout(osdc);


