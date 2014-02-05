Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaBEUEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:04:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:54421 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaBEUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:39 -0500
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
Subject: [v2.6.34-stable 039/213] tcp: allow splice() to build full TSO packets
Date: Wed, 5 Feb 2014 14:59:54 -0500
Message-ID: <1391630568-49251-40-git-send-email-paul.gortmaker@windriver.com>
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

commit 2f53384424251c06038ae612e56231b96ab610ee upstream.

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
Signed-off-by: Eric Dumazet <eric.dumazet@gmail>com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3a8cbf72b06e..cea0a9223c5d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -849,7 +849,7 @@ wait_for_memory:
 	}
 
 out:
-	if (copied)
+	if (copied && !(flags & MSG_MORE))
 		tcp_push(sk, flags, mss_now, tp->nonagle);
 	return copied;
 
-- 
1.8.5.2

