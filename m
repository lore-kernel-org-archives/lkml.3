Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3KRSlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:41:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3KRShd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:37:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Thomas <Mark.Thomas@metaswitch.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 02/19] net: sctp: do not trigger BUG_ON in sctp_cmd_delete_tcb
Date: Mon, 18 Nov 2013 10:37:15 -0800
Message-Id: <20131118183644.791664449@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118183644.030738675@linuxfoundation.org>
References: <20131118183644.030738675@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 7926c1d5be0b7cbe5b8d5c788d7d39237e7b212c ]

Introduced in f9e42b853523 ("net: sctp: sideeffect: throw BUG if
primary_path is NULL"), we intended to find a buggy assoc that's
part of the assoc hash table with a primary_path that is NULL.
However, we better remove the BUG_ON for now and find a more
suitable place to assert for these things as Mark reports that
this also triggers the bug when duplication cookie processing
happens, and the assoc is not part of the hash table (so all
good in this case). Such a situation can for example easily be
reproduced by:

  tc qdisc add dev eth0 root handle 1: prio bands 2 priomap 1 1 1 1 1 1
  tc qdisc add dev eth0 parent 1:2 handle 20: netem loss 20%
  tc filter add dev eth0 protocol ip parent 1: prio 2 u32 match ip \
            protocol 132 0xff match u8 0x0b 0xff at 32 flowid 1:2

This drops 20% of COOKIE-ACK packets. After some follow-up
discussion with Vlad we came to the conclusion that for now we
should still better remove this BUG_ON() assertion, and come up
with two follow-ups later on, that is, i) find a more suitable
place for this assertion, and possibly ii) have a special
allocator/initializer for such kind of temporary assocs.

Reported-by: Mark Thomas <Mark.Thomas@metaswitch.com>
Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_sideeffect.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -860,7 +860,6 @@ static void sctp_cmd_delete_tcb(sctp_cmd
 	    (!asoc->temp) && (sk->sk_shutdown != SHUTDOWN_MASK))
 		return;
 
-	BUG_ON(asoc->peer.primary_path == NULL);
 	sctp_unhash_established(asoc);
 	sctp_association_free(asoc);
 }


