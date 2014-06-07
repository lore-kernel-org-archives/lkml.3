Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaFGBhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:37:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36025 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sage Weil" <sage@newdream.net>,
        "Alex Elder" <elder@dreamhost.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.555947440@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 74/92] libceph: only call kernel_sendpage() via helper
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@dreamhost.com>

commit e36b13cceb46136d849aeee06b4907ad3570ba78 upstream.

Make ceph_tcp_sendpage() be the only place kernel_sendpage() is
used, by using this helper in write_partial_msg_pages().

Signed-off-by: Alex Elder <elder@dreamhost.com>
Reviewed-by: Sage Weil <sage@newdream.net>
[bwh: Backported to 3.2:
 - Add ceph_tcp_sendpage(), from commit 31739139f3ed ('libceph: use
   kernel_sendpage() for sending zeroes'), the rest of which is not
   applicable
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ceph/messenger.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -284,6 +284,19 @@ static int ceph_tcp_sendmsg(struct socke
 	return r;
 }
 
+static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
+		     int offset, size_t size, bool more)
+{
+	int flags = MSG_DONTWAIT | MSG_NOSIGNAL | (more ? MSG_MORE : MSG_EOR);
+	int ret;
+
+	ret = kernel_sendpage(sock, page, offset, size, flags);
+	if (ret == -EAGAIN)
+		ret = 0;
+
+	return ret;
+}
+
 
 /*
  * Shutdown/close the socket for the given connection.
@@ -851,18 +864,14 @@ static int write_partial_msg_pages(struc
 				cpu_to_le32(crc32c(tmpcrc, base, len));
 			con->out_msg_pos.did_page_crc = 1;
 		}
-		ret = kernel_sendpage(con->sock, page,
+		ret = ceph_tcp_sendpage(con->sock, page,
 				      con->out_msg_pos.page_pos + page_shift,
-				      len,
-				      MSG_DONTWAIT | MSG_NOSIGNAL |
-				      MSG_MORE);
+				      len, 1);
 
 		if (crc &&
 		    (msg->pages || msg->pagelist || msg->bio || in_trail))
 			kunmap(page);
 
-		if (ret == -EAGAIN)
-			ret = 0;
 		if (ret <= 0)
 			goto out;
 

