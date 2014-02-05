Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaBEVGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:06:09 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48027 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaBEUEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Nandita Dukkipati <nanditad@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tom Herbert <therbert@google.com>, Yuchung Cheng <ycheng@google.com>,
        "H.K. Jerry Chu" <hkchu@google.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 040/213] tcp: tcp_sendpages() should call tcp_push() once
Date: Wed, 5 Feb 2014 14:59:55 -0500
Message-ID: <1391630568-49251-41-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 35f9c09fe9c72eb8ca2b8e89a593e1c151f28fc2 upstream.

commit 2f533844242 (tcp: allow splice() to build full TSO packets) added
a regression for splice() calls using SPLICE_F_MORE.

We need to call tcp_flush() at the end of the last page processed in
tcp_sendpages(), or else transmits can be deferred and future sends
stall.

Add a new internal flag, MSG_SENDPAGE_NOTLAST, acting like MSG_MORE, but
with different semantic.

For all sendpage() providers, its a transparent change. Only
sock_sendpage() and tcp_sendpages() can differentiate the two different
flags provided by pipe_to_sendpage()

Reported-by: Tom Herbert <therbert@google.com>
Cc: Nandita Dukkipati <nanditad@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: H.K. Jerry Chu <hkchu@google.com>
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Mahesh Bandewar <maheshb@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail>com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/splice.c            | 5 ++++-
 include/linux/socket.h | 2 +-
 net/ipv4/tcp.c         | 2 +-
 net/socket.c           | 6 +++---
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index cc617b09e4c2..3bec7c63be64 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -31,6 +31,7 @@
 #include <linux/uio.h>
 #include <linux/security.h>
 #include <linux/gfp.h>
+#include <linux/socket.h>
 
 /*
  * Attempt to steal a page from a pipe buffer. This should perhaps go into
@@ -638,7 +639,9 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
 
 	ret = buf->ops->confirm(pipe, buf);
 	if (!ret) {
-		more = (sd->flags & SPLICE_F_MORE) || sd->len < sd->total_len;
+		more = (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
+		if (sd->len < sd->total_len)
+			more |= MSG_SENDPAGE_NOTLAST;
 		if (file->f_op && file->f_op->sendpage)
 			ret = file->f_op->sendpage(file, buf->page, buf->offset,
 						   sd->len, &pos, more);
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 354cc5617f8b..7cfb4f881644 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -256,7 +256,7 @@ struct ucred {
 #define MSG_NOSIGNAL	0x4000	/* Do not generate SIGPIPE */
 #define MSG_MORE	0x8000	/* Sender will send more */
 #define MSG_WAITFORONE	0x10000	/* recvmmsg(): block until 1+ packets avail */
-
+#define MSG_SENDPAGE_NOTLAST 0x20000 /* sendpage() internal : not the last page */
 #define MSG_EOF         MSG_FIN
 
 #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exit for file
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cea0a9223c5d..df671c76f196 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -849,7 +849,7 @@ wait_for_memory:
 	}
 
 out:
-	if (copied && !(flags & MSG_MORE))
+	if (copied && !(flags & MSG_SENDPAGE_NOTLAST))
 		tcp_push(sk, flags, mss_now, tp->nonagle);
 	return copied;
 
diff --git a/net/socket.c b/net/socket.c
index c63ebf4e31b5..c802797e3a4a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -746,9 +746,9 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 
 	sock = file->private_data;
 
-	flags = !(file->f_flags & O_NONBLOCK) ? 0 : MSG_DONTWAIT;
-	if (more)
-		flags |= MSG_MORE;
+	flags = (file->f_flags & O_NONBLOCK) ? MSG_DONTWAIT : 0;
+	/* more is a combination of MSG_MORE and MSG_SENDPAGE_NOTLAST */
+	flags |= more;
 
 	return kernel_sendpage(sock, page, offset, size, flags);
 }
-- 
1.8.5.2

