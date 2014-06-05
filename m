Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaFEETy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:19:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaFEETv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:19:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 015/214] net: sctp: wake up all assocs if sndbuf policy is per socket
Date: Wed,  4 Jun 2014 21:16:18 -0700
Message-Id: <20140605041641.821071132@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 52c35befb69b005c3fc5afdaae3a5717ad013411 ]

SCTP charges chunks for wmem accounting via skb->truesize in
sctp_set_owner_w(), and sctp_wfree() respectively as the
reverse operation. If a sender runs out of wmem, it needs to
wait via sctp_wait_for_sndbuf(), and gets woken up by a call
to __sctp_write_space() mostly via sctp_wfree().

__sctp_write_space() is being called per association. Although
we assign sk->sk_write_space() to sctp_write_space(), which
is then being done per socket, it is only used if send space
is increased per socket option (SO_SNDBUF), as SOCK_USE_WRITE_QUEUE
is set and therefore not invoked in sock_wfree().

Commit 4c3a5bdae293 ("sctp: Don't charge for data in sndbuf
again when transmitting packet") fixed an issue where in case
sctp_packet_transmit() manages to queue up more than sndbuf
bytes, sctp_wait_for_sndbuf() will never be woken up again
unless it is interrupted by a signal. However, a still
remaining issue is that if net.sctp.sndbuf_policy=0, that is
accounting per socket, and one-to-many sockets are in use,
the reclaimed write space from sctp_wfree() is 'unfairly'
handed back on the server to the association that is the lucky
one to be woken up again via __sctp_write_space(), while
the remaining associations are never be woken up again
(unless by a signal).

The effect disappears with net.sctp.sndbuf_policy=1, that
is wmem accounting per association, as it guarantees a fair
share of wmem among associations.

Therefore, if we have reclaimed memory in case of per socket
accounting, wake all related associations to a socket in a
fair manner, that is, traverse the socket association list
starting from the current neighbour of the association and
issue a __sctp_write_space() to everyone until we end up
waking ourselves. This guarantees that no association is
preferred over another and even if more associations are
taken into the one-to-many session, all receivers will get
messages from the server and are not stalled forever on
high load. This setting still leaves the advantage of per
socket accounting in touch as an association can still use
up global limits if unused by others.

Fixes: 4eb701dfc618 ("[SCTP] Fix SCTP sendbuffer accouting.")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Vlad Yasevich <vyasevic@redhat.com>
Acked-by: Vlad Yasevich <vyasevic@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6369,6 +6369,40 @@ static void __sctp_write_space(struct sc
 	}
 }
 
+static void sctp_wake_up_waiters(struct sock *sk,
+				 struct sctp_association *asoc)
+{
+	struct sctp_association *tmp = asoc;
+
+	/* We do accounting for the sndbuf space per association,
+	 * so we only need to wake our own association.
+	 */
+	if (asoc->ep->sndbuf_policy)
+		return __sctp_write_space(asoc);
+
+	/* Accounting for the sndbuf space is per socket, so we
+	 * need to wake up others, try to be fair and in case of
+	 * other associations, let them have a go first instead
+	 * of just doing a sctp_write_space() call.
+	 *
+	 * Note that we reach sctp_wake_up_waiters() only when
+	 * associations free up queued chunks, thus we are under
+	 * lock and the list of associations on a socket is
+	 * guaranteed not to change.
+	 */
+	for (tmp = list_next_entry(tmp, asocs); 1;
+	     tmp = list_next_entry(tmp, asocs)) {
+		/* Manually skip the head element. */
+		if (&tmp->asocs == &((sctp_sk(sk))->ep->asocs))
+			continue;
+		/* Wake up association. */
+		__sctp_write_space(tmp);
+		/* We've reached the end. */
+		if (tmp == asoc)
+			break;
+	}
+}
+
 /* Do accounting for the sndbuf space.
  * Decrement the used sndbuf space of the corresponding association by the
  * data size which was just transmitted(freed).
@@ -6396,7 +6430,7 @@ static void sctp_wfree(struct sk_buff *s
 	sk_mem_uncharge(sk, skb->truesize);
 
 	sock_wfree(skb);
-	__sctp_write_space(asoc);
+	sctp_wake_up_waiters(sk, asoc);
 
 	sctp_association_put(asoc);
 }


