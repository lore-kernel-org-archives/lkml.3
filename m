Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964774AbaFXPy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:54:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbaFXPyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:54:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, David Held <drheld@google.com>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 33/68] udp: ipv4: do not waste time in __udp4_lib_mcast_demux_lookup
Date: Tue, 24 Jun 2014 11:50:52 -0400
Message-Id: <20140624154725.418299802@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 63c6f81cdde58c41da62a8d8a209592e42a0203e ]

Its too easy to add thousand of UDP sockets on a particular bucket,
and slow down an innocent multicast receiver.

Early demux is supposed to be an optimization, we should avoid spending
too much time in it.

It is interesting to note __udp4_lib_demux_lookup() only tries to
match first socket in the chain.

10 is the threshold we already have in __udp4_lib_lookup() to switch
to secondary hash.

Fixes: 421b3885bf6d5 ("udp: ipv4: Add udp early demux")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: David Held <drheld@google.com>
Cc: Shawn Bohrer <sbohrer@rgmadvisors.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1833,6 +1833,10 @@ static struct sock *__udp4_lib_mcast_dem
 	unsigned int count, slot = udp_hashfn(net, hnum, udp_table.mask);
 	struct udp_hslot *hslot = &udp_table.hash[slot];
 
+	/* Do not bother scanning a too big list */
+	if (hslot->count > 10)
+		return NULL;
+
 	rcu_read_lock();
 begin:
 	count = 0;


