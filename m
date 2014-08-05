Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaHESSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:18:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbaHESQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:16:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        James Chapman <jchapman@katalix.com>,
        David Miller <davem@davemloft.net>,
        Phil Turnbull <phil.turnbull@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 25/27] net/l2tp: dont fall back on UDP [get|set]sockopt
Date: Tue,  5 Aug 2014 11:14:17 -0700
Message-Id: <20140805181345.009524838@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181344.268039690@linuxfoundation.org>
References: <20140805181344.268039690@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 3cf521f7dc87c031617fd47e4b7aa2593c2f3daf upstream.

The l2tp [get|set]sockopt() code has fallen back to the UDP functions
for socket option levels != SOL_PPPOL2TP since day one, but that has
never actually worked, since the l2tp socket isn't an inet socket.

As David Miller points out:

  "If we wanted this to work, it'd have to look up the tunnel and then
   use tunnel->sk, but I wonder how useful that would be"

Since this can never have worked so nobody could possibly have depended
on that functionality, just remove the broken code and return -EINVAL.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: James Chapman <jchapman@katalix.com>
Acked-by: David Miller <davem@davemloft.net>
Cc: Phil Turnbull <phil.turnbull@oracle.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/l2tp/l2tp_ppp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1365,7 +1365,7 @@ static int pppol2tp_setsockopt(struct so
 	int err;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.setsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -1491,7 +1491,7 @@ static int pppol2tp_getsockopt(struct so
 	struct pppol2tp_session *ps;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.getsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (get_user(len, optlen))
 		return -EFAULT;


