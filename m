Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaELBmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:38 -0400
Received: from 1wt.eu ([62.212.114.60]:34549 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbaELBm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:28 -0400
Message-Id: <20140512003204.710327849@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neal Cardwell <ncardwell@google.com>, Eric Dumazet <edumazet@google.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 098/143] inet_diag: fix inet_diag_dump_icsk() timewait socket state logic
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Based upon upstream commit 70315d22d3c7383f9a508d0aab21e2eb35b2303a ]

Fix inet_diag_dump_icsk() to reflect the fact that both TIME_WAIT and
FIN_WAIT2 connections are represented by inet_timewait_sock (not just
TIME_WAIT). Thus:

(a) We need to iterate through the time_wait buckets if the user wants
either TIME_WAIT or FIN_WAIT2. (Before fixing this, "ss -nemoi state
fin-wait-2" would not return any sockets, even if there were some in
FIN_WAIT2.)

(b) We need to check tw_substate to see if the user wants to dump
sockets in the particular substate (TIME_WAIT or FIN_WAIT2) that a
given connection is in. (Before fixing this, "ss -nemoi state
time-wait" would actually return sockets in state FIN_WAIT2.)

An analogous fix is in v3.13: 70315d22d3c7383f9a508d0aab21e2eb35b2303a
("inet_diag: fix inet_diag_dump_icsk() to use correct state for
timewait sockets") but that patch is quite different because 3.13 code
is very different in this area due to the unification of TCP hash
tables in 05dbc7b ("tcp/dccp: remove twchain") in v3.13-rc1.

I tested that this applies cleanly between v3.3 and v3.12, and tested
that it works in both 3.3 and 3.12. It does not apply cleanly to 3.2
and earlier (though it makes semantic sense), and semantically is not
the right fix for 3.13 and beyond (as mentioned above).

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/inet_diag.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index dba56d2..65ee65a 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -814,7 +814,7 @@ next_normal:
 			++num;
 		}
 
-		if (r->idiag_states & TCPF_TIME_WAIT) {
+		if (r->idiag_states & (TCPF_TIME_WAIT | TCPF_FIN_WAIT2)) {
 			struct inet_timewait_sock *tw;
 
 			inet_twsk_for_each(tw, node,
@@ -822,6 +822,8 @@ next_normal:
 
 				if (num < s_num)
 					goto next_dying;
+				if (!(r->idiag_states & (1 << tw->tw_substate)))
+					goto next_dying;
 				if (r->id.idiag_sport != tw->tw_sport &&
 				    r->id.idiag_sport)
 					goto next_dying;
-- 
1.7.12.2.21.g234cd45.dirty



