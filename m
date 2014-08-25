Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbaHYQ4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:56:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59904 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbaHYQz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:55:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Phil Turnbull <phil.turnbull@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 13/13] net/l2tp: don't fall back on UDP [get|set]sockopt
Date: Mon, 25 Aug 2014 09:54:59 -0700
Message-Id: <1408985699-31838-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408985699-31838-1-git-send-email-kamal@canonical.com>
References: <1408985699-31838-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.28 -stable review patch.  If anyone has any objections, please let me know.

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
CVE-2014-4943
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/l2tp/l2tp_ppp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 26dbd9a..fbd6bbf 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1404,7 +1404,7 @@ static int pppol2tp_setsockopt(struct socket *sock, int level, int optname,
 	int err;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.setsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -1530,7 +1530,7 @@ static int pppol2tp_getsockopt(struct socket *sock, int level, int optname,
 	struct pppol2tp_session *ps;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.getsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (get_user(len, optlen))
 		return -EFAULT;
-- 
1.9.1

