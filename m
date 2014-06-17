Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965404AbaFQWMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:12:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54606 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965781AbaFQVv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>, Yehuda Sadeh <yehuda@inktank.com>,
        Chunwei Chen <tuxoko@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 137/212] libceph: fix corruption when using page_count 0 page in rbd
Date: Tue, 17 Jun 2014 14:43:51 -0700
Message-Id: <1403041506-13646-138-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunwei Chen <tuxoko@gmail.com>

commit 178eda29ca721842f2146378e73d43e0044c4166 upstream.

It has been reported that using ZFSonLinux on rbd will result in memory
corruption. The bug report can be found here:

https://github.com/zfsonlinux/spl/issues/241
http://tracker.ceph.com/issues/7790

The reason is that ZFS will send pages with page_count 0 into rbd, which in
turns send them to tcp_sendpage. However, tcp_sendpage cannot deal with
page_count 0, as it will do get_page and put_page, and erroneously free the
page.

This type of issue has been noted before, and handled in iscsi, drbd,
etc. So, rbd should also handle this. This fix address this issue by fall back
to slower sendmsg when page_count 0 detected.

Cc: Sage Weil <sage@inktank.com>
Cc: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Chunwei Chen <tuxoko@gmail.com>
Reviewed-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ceph/messenger.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 464303f..ce83d07 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -556,7 +556,7 @@ static int ceph_tcp_sendmsg(struct socket *sock, struct kvec *iov,
 	return r;
 }
 
-static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
+static int __ceph_tcp_sendpage(struct socket *sock, struct page *page,
 		     int offset, size_t size, bool more)
 {
 	int flags = MSG_DONTWAIT | MSG_NOSIGNAL | (more ? MSG_MORE : MSG_EOR);
@@ -569,6 +569,24 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
 	return ret;
 }
 
+static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
+		     int offset, size_t size, bool more)
+{
+	int ret;
+	struct kvec iov;
+
+	/* sendpage cannot properly handle pages with page_count == 0,
+	 * we need to fallback to sendmsg if that's the case */
+	if (page_count(page) >= 1)
+		return __ceph_tcp_sendpage(sock, page, offset, size, more);
+
+	iov.iov_base = kmap(page) + offset;
+	iov.iov_len = size;
+	ret = ceph_tcp_sendmsg(sock, &iov, 1, size, more);
+	kunmap(page);
+
+	return ret;
+}
 
 /*
  * Shutdown/close the socket for the given connection.
-- 
1.9.1

