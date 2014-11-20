Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbaKTXKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:10:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56303 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757874AbaKTXKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:10:47 -0500
From: Calvin Owens <calvinowens@fb.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>, Eric Dumazet <edumazet@google.com>
CC: <kernel-team@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Calvin Owens <calvinowens@fb.com>
Subject: [PATCH] tcp: Restore RFC5961-compliant behavior for SYN packets
Date: Thu, 20 Nov 2014 15:09:53 -0800
Message-ID: <1416524993-26228-1-git-send-email-calvinowens@fb.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-20_08:2014-11-20,2014-11-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.919135270856499 urlsuspect_oldscore=0.919135270856499
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=239233
 rbsscore=0.919135270856499 spamscore=0
 recipient_to_sender_domain_totalscore=1 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411200183
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c3ae62af8e755 ("tcp: should drop incoming frames without ACK
flag set") was created to mitigate a security vulnerability in which a
local attacker is able to inject data into locally-opened sockets by
using TCP protocol statistics in procfs to quickly find the correct
sequence number.

This broke the RFC5961 requirement to send a challenge ACK in response
to spurious RST packets, which was subsequently fixed by commit
7b514a886ba50 ("tcp: accept RST without ACK flag").

Unfortunately, the RFC5961 requirement that spurious SYN packets be
handled in a similar manner remains broken.

RFC5961 section 4 states that:

   ... the handling of the SYN in the synchronized state SHOULD be
   performed as follows:

   1) If the SYN bit is set, irrespective of the sequence number, TCP
      MUST send an ACK (also referred to as challenge ACK) to the remote
      peer:

      <SEQ=SND.NXT><ACK=RCV.NXT><CTL=ACK>

      After sending the acknowledgment, TCP MUST drop the unacceptable
      segment and stop processing further.

   By sending an ACK, the remote peer is challenged to confirm the loss
   of the previous connection and the request to start a new connection.
   A legitimate peer, after restart, would not have a TCB in the
   synchronized state.  Thus, when the ACK arrives, the peer should send
   a RST segment back with the sequence number derived from the ACK
   field that caused the RST.

   This RST will confirm that the remote peer has indeed closed the
   previous connection.  Upon receipt of a valid RST, the local TCP
   endpoint MUST terminate its connection.  The local TCP endpoint
   should then rely on SYN retransmission from the remote end to
   re-establish the connection.

This patch lets SYN packets through the discard added in c3ae62af8e755,
so that spurious SYN packets are properly dealt with as per the RFC.

The challenge ACK is sent unconditionally and is rate-limited, so the
original vulnerability is not reintroduced by this patch.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 88fa2d1..d107ee2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5231,7 +5231,7 @@ slow_path:
 	if (len < (th->doff << 2) || tcp_checksum_complete_user(sk, skb))
 		goto csum_error;
 
-	if (!th->ack && !th->rst)
+	if (!th->ack && !th->rst && !th->syn)
 		goto discard;
 
 	/*
@@ -5650,7 +5650,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 			goto discard;
 	}
 
-	if (!th->ack && !th->rst)
+	if (!th->ack && !th->rst && !th->syn)
 		goto discard;
 
 	if (!tcp_validate_incoming(sk, skb, th, 0))
-- 
2.1.1

