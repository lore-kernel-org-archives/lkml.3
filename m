Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaFGBtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:49:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35919 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ilya Dryomov" <ilya.dryomov@inktank.com>,
        "Yehuda Sadeh" <yehuda@inktank.com>, "Chunwei Chen" <tuxoko@gmail.com>,
        "Sage Weil" <sage@inktank.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.296295002@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 75/92] libceph: fix corruption when using page_count 0
 page in rbd
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ceph/messenger.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -284,7 +284,7 @@ static int ceph_tcp_sendmsg(struct socke
 	return r;
 }
 
-static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
+static int __ceph_tcp_sendpage(struct socket *sock, struct page *page,
 		     int offset, size_t size, bool more)
 {
 	int flags = MSG_DONTWAIT | MSG_NOSIGNAL | (more ? MSG_MORE : MSG_EOR);
@@ -297,6 +297,24 @@ static int ceph_tcp_sendpage(struct sock
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

