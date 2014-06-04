Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaFDXXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaFDXXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sage Weil <sage@inktank.com>, Yehuda Sadeh <yehuda@inktank.com>,
        Chunwei Chen <tuxoko@gmail.com>,
        Ilya Dryomov <ilya.dryomov@inktank.com>
Subject: [PATCH 3.14 221/228] libceph: fix corruption when using page_count 0 page in rbd
Date: Wed,  4 Jun 2014 16:24:10 -0700
Message-Id: <20140604232355.146645589@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/messenger.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -557,7 +557,7 @@ static int ceph_tcp_sendmsg(struct socke
 	return r;
 }
 
-static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
+static int __ceph_tcp_sendpage(struct socket *sock, struct page *page,
 		     int offset, size_t size, bool more)
 {
 	int flags = MSG_DONTWAIT | MSG_NOSIGNAL | (more ? MSG_MORE : MSG_EOR);
@@ -570,6 +570,24 @@ static int ceph_tcp_sendpage(struct sock
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


