Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaLFSAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:00:06 -0500
Received: from 1wt.eu ([62.212.114.60]:40713 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbaLFRy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:54:56 -0500
Message-Id: <20141206174149.105395374@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:42:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>, James Chapman <jchapman@katalix.com>,
        David Miller <davem@davemloft.net>,
        Phil Turnbull <phil.turnbull@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 16/25] net/l2tp: dont fall back on UDP [get|set]sockopt
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

(commit 3cf521f7dc87c031617fd47e4b7aa2593c2f3daf upstream)

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
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

[geissert: adjust file paths and context for 2.6.32]
[wt: fixes CVE-2014-4943]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/pppol2tp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
index 4cdc1cf..4c8f019 100644
--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -2190,7 +2190,7 @@ static int pppol2tp_setsockopt(struct socket *sock, int level, int optname,
 	int err;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.setsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -2314,7 +2314,7 @@ static int pppol2tp_getsockopt(struct socket *sock, int level,
 	int err;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.getsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (get_user(len, (int __user *) optlen))
 		return -EFAULT;
-- 
1.7.12.2.21.g234cd45.dirty



