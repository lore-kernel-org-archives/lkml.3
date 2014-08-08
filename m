Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbaHHW3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:29:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40196 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbaHHUlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Phil Turnbull <phil.turnbull@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 134/259] net/l2tp: don't fall back on UDP [get|set]sockopt
Date: Fri,  8 Aug 2014 13:39:17 -0700
Message-Id: <1407530482-4483-135-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/l2tp/l2tp_ppp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 8580b78..cfa1406 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1365,7 +1365,7 @@ static int pppol2tp_setsockopt(struct socket *sock, int level, int optname,
 	int err;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.setsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -1491,7 +1491,7 @@ static int pppol2tp_getsockopt(struct socket *sock, int level, int optname,
 	struct pppol2tp_session *ps;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.getsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (get_user(len, optlen))
 		return -EFAULT;
-- 
1.9.1

