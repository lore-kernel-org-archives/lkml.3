Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934326AbaBDVJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:09:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934234AbaBDVJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 116/133] inet_diag: fix inet_diag_dump_icsk() timewait socket state logic
Date: Tue,  4 Feb 2014 13:08:37 -0800
Message-Id: <20140204210740.311056583@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_diag.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -961,7 +961,7 @@ next_normal:
 			++num;
 		}
 
-		if (r->idiag_states & TCPF_TIME_WAIT) {
+		if (r->idiag_states & (TCPF_TIME_WAIT | TCPF_FIN_WAIT2)) {
 			struct inet_timewait_sock *tw;
 
 			inet_twsk_for_each(tw, node,
@@ -971,6 +971,8 @@ next_normal:
 
 				if (num < s_num)
 					goto next_dying;
+				if (!(r->idiag_states & (1 << tw->tw_substate)))
+					goto next_dying;
 				if (r->sdiag_family != AF_UNSPEC &&
 						tw->tw_family != r->sdiag_family)
 					goto next_dying;


