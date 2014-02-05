Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaBEU5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:57:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:54744 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaBEUFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Willy Tarreau <w@1wt.eu>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 063/213] tcp: do_tcp_sendpages() must try to push data out on oom conditions
Date: Wed, 5 Feb 2014 15:00:18 -0500
Message-ID: <1391630568-49251-64-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bad115cfe5b509043b684d3a007ab54b80090aa1 upstream.

Since recent changes on TCP splicing (starting with commits 2f533844
"tcp: allow splice() to build full TSO packets" and 35f9c09f "tcp:
tcp_sendpages() should call tcp_push() once"), I started seeing
massive stalls when forwarding traffic between two sockets using
splice() when pipe buffers were larger than socket buffers.

Latest changes (net: netdev_alloc_skb() use build_skb()) made the
problem even more apparent.

The reason seems to be that if do_tcp_sendpages() fails on out of memory
condition without being able to send at least one byte, tcp_push() is not
called and the buffers cannot be flushed.

After applying the attached patch, I cannot reproduce the stalls at all
and the data rate it perfectly stable and steady under any condition
which previously caused the problem to be permanent.

The issue seems to have been there since before the kernel migrated to
git, which makes me think that the stalls I occasionally experienced
with tux during stress-tests years ago were probably related to the
same issue.

This issue was first encountered on 3.0.31 and 3.2.17, so please backport
to -stable.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index df671c76f196..392d594521c1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -839,8 +839,7 @@ new_segment:
 wait_for_sndbuf:
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 wait_for_memory:
-		if (copied)
-			tcp_push(sk, flags & ~MSG_MORE, mss_now, TCP_NAGLE_PUSH);
+		tcp_push(sk, flags & ~MSG_MORE, mss_now, TCP_NAGLE_PUSH);
 
 		if ((err = sk_stream_wait_memory(sk, &timeo)) != 0)
 			goto do_error;
-- 
1.8.5.2

