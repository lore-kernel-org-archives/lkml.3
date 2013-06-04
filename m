Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3FDXBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:01:45 -0400
Received: from 1wt.eu ([62.212.114.60]:35645 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab3FDWnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:08 -0400
Message-Id: <20130604172136.849807335@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nandita Dukkipati <nanditad@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tom Herbert <therbert@google.com>, Yuchung Cheng <ycheng@google.com>,
        "H.K. Jerry Chu" <hkchu@google.com>,
        =?ISO-8859-15?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        =?ISO-8859-15?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 158/184] tcp: allow splice() to build full TSO packets
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ This combines upstream commit
  2f53384424251c06038ae612e56231b96ab610ee and the follow-on bug fix
  commit 35f9c09fe9c72eb8ca2b8e89a593e1c151f28fc2 ]

vmsplice()/splice(pipe, socket) call do_tcp_sendpages() one page at a
time, adding at most 4096 bytes to an skb. (assuming PAGE_SIZE=4096)

The call to tcp_push() at the end of do_tcp_sendpages() forces an
immediate xmit when pipe is not already filled, and tso_fragment() try
to split these skb to MSS multiples.

4096 bytes are usually split in a skb with 2 MSS, and a remaining
sub-mss skb (assuming MTU=1500)

This makes slow start suboptimal because many small frames are sent to
qdisc/driver layers instead of big ones (constrained by cwnd and packets
in flight of course)

In fact, applications using sendmsg() (adding an additional memory copy)
instead of vmsplice()/splice()/sendfile() are a bit faster because of
this anomaly, especially if serving small files in environments with
large initial [c]wnd.

Call tcp_push() only if MSG_MORE is not set in the flags parameter.

This bit is automatically provided by splice() internals but for the
last page, or on all pages if user specified SPLICE_F_MORE splice()
flag.

In some workloads, this can reduce number of sent logical packets by an
order of magnitude, making zero-copy TCP actually faster than
one-copy :)

Reported-by: Tom Herbert <therbert@google.com>
Cc: Nandita Dukkipati <nanditad@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: H.K. Jerry Chu <hkchu@google.com>
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Mahesh Bandewar <maheshb@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/splice.c            | 5 ++++-
 include/linux/socket.h | 2 +-
 net/ipv4/tcp.c         | 2 +-
 net/socket.c           | 6 +++---
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index bb92b7c5..f5d5a2b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -30,6 +30,7 @@
 #include <linux/syscalls.h>
 #include <linux/uio.h>
 #include <linux/security.h>
+#include <linux/socket.h>
 
 /*
  * Attempt to steal a page from a pipe buffer. This should perhaps go into
@@ -637,7 +638,9 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
 
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
index 3273a0c..3124c51 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -246,7 +246,7 @@ struct ucred {
 #define MSG_ERRQUEUE	0x2000	/* Fetch message from error queue */
 #define MSG_NOSIGNAL	0x4000	/* Do not generate SIGPIPE */
 #define MSG_MORE	0x8000	/* Sender will send more */
-
+#define MSG_SENDPAGE_NOTLAST 0x20000 /* sendpage() internal : not the last page */
 #define MSG_EOF         MSG_FIN
 
 #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exit for file
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b9644d8..6232462 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -847,7 +847,7 @@ wait_for_memory:
 	}
 
 out:
-	if (copied)
+	if (copied && !(flags & MSG_SENDPAGE_NOTLAST))
 		tcp_push(sk, flags, mss_now, tp->nonagle);
 	return copied;
 
diff --git a/net/socket.c b/net/socket.c
index d449812..bf9fc68 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -732,9 +732,9 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 
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
1.7.12.2.21.g234cd45.dirty



