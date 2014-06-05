Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaFEET6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:19:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaFEET4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:19:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 016/214] net: sctp: test if association is dead in sctp_wake_up_waiters
Date: Wed,  4 Jun 2014 21:16:19 -0700
Message-Id: <20140605041641.952967662@linuxfoundation.org>
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

[ Upstream commit 1e1cdf8ac78793e0875465e98a648df64694a8d0 ]

In function sctp_wake_up_waiters(), we need to involve a test
if the association is declared dead. If so, we don't have any
reference to a possible sibling association anymore and need
to invoke sctp_write_space() instead, and normally walk the
socket's associations and notify them of new wmem space. The
reason for special casing is that otherwise, we could run
into the following issue when a sctp_primitive_SEND() call
from sctp_sendmsg() fails, and tries to flush an association's
outq, i.e. in the following way:

sctp_association_free()
`-> list_del(&asoc->asocs)         <-- poisons list pointer
    asoc->base.dead = true
    sctp_outq_free(&asoc->outqueue)
    `-> __sctp_outq_teardown()
     `-> sctp_chunk_free()
      `-> consume_skb()
       `-> sctp_wfree()
        `-> sctp_wake_up_waiters() <-- dereferences poisoned pointers
                                       if asoc->ep->sndbuf_policy=0

Therefore, only walk the list in an 'optimized' way if we find
that the current association is still active. We could also use
list_del_init() in addition when we call sctp_association_free(),
but as Vlad suggests, we want to trap such bugs and thus leave
it poisoned as is.

Why is it safe to resolve the issue by testing for asoc->base.dead?
Parallel calls to sctp_sendmsg() are protected under socket lock,
that is lock_sock()/release_sock(). Only within that path under
lock held, we're setting skb/chunk owner via sctp_set_owner_w().
Eventually, chunks are freed directly by an association still
under that lock. So when traversing association list on destruction
time from sctp_wake_up_waiters() via sctp_wfree(), a different
CPU can't be running sctp_wfree() while another one calls
sctp_association_free() as both happens under the same lock.
Therefore, this can also not race with setting/testing against
asoc->base.dead as we are guaranteed for this to happen in order,
under lock. Further, Vlad says: the times we check asoc->base.dead
is when we've cached an association pointer for later processing.
In between cache and processing, the association may have been
freed and is simply still around due to reference counts. We check
asoc->base.dead under a lock, so it should always be safe to check
and not race against sctp_association_free(). Stress-testing seems
fine now, too.

Fixes: cd253f9f357d ("net: sctp: wake up all assocs if sndbuf policy is per socket")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Vlad Yasevich <vyasevic@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6380,6 +6380,12 @@ static void sctp_wake_up_waiters(struct
 	if (asoc->ep->sndbuf_policy)
 		return __sctp_write_space(asoc);
 
+	/* If association goes down and is just flushing its
+	 * outq, then just normally notify others.
+	 */
+	if (asoc->base.dead)
+		return sctp_write_space(sk);
+
 	/* Accounting for the sndbuf space is per socket, so we
 	 * need to wake up others, try to be fair and in case of
 	 * other associations, let them have a go first instead


