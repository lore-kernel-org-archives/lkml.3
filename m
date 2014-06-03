Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaFCL57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:57:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbaFCLmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>, Yehuda Sadeh <yehuda@inktank.com>,
        Chunwei Chen <tuxoko@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 090/138] libceph: fix corruption when using page_count 0 page in rbd
Date: Tue,  3 Jun 2014 12:38:56 +0100
Message-Id: <1401795584-22664-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/messenger.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index f8579689d10d..33b4405da8ac 100644
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

