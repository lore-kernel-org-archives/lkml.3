Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaHDQ7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:59:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56587 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sasha Levin" <sasha.levin@oracle.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Phil Turnbull" <phil.turnbull@oracle.com>, "Willy Tarreau" <w@1wt.eu>,
        "David Miller" <davem@davemloft.net>,
        "James Chapman" <jchapman@katalix.com>,
        "Vegard Nossum" <vegard.nossum@oracle.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.996722237@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 47/94] net/l2tp: don't fall back on UDP [get|set]sockopt
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/l2tp/l2tp_ppp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1351,7 +1351,7 @@ static int pppol2tp_setsockopt(struct so
 	int err;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.setsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -1477,7 +1477,7 @@ static int pppol2tp_getsockopt(struct so
 	struct pppol2tp_session *ps;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.getsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (get_user(len, (int __user *) optlen))
 		return -EFAULT;

