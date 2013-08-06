Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3HEQqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:46:07 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34514 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3HEQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:46:05 -0400
From: Dong Fang <yp.fangdong@gmail.com>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dong Fang <yp.fangdong@gmail.com>
Subject: [PATCH] net/ipv4: fix the conditions of entering TCP_CA_Disorder state
Date: Mon,  5 Aug 2013 20:45:51 -0400
Message-Id: <1375749951-11230-1-git-send-email-yp.fangdong@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if have some packets loss by network, the kernel can't reach here, we can see
the tcp_time_to_recover() function:

static bool tcp_time_to_recover(struct sock *sk, int flag)
{
	struct tcp_sock *tp = tcp_sk(sk);
	__u32 packets_out;

	/* Trick#1: The loss is proven. */
	if (tp->lost_out)
		return true;
	//...
}

when it return true, the following condition will be failed:

//...
if (!tcp_time_to_recover(sk, flag)) {
	tcp_try_to_open(sk, flag, prior_unsacked);
	return;
}
//...


Signed-off-by: Dong Fang <yp.fangdong@gmail.com>
---
 net/ipv4/tcp_input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 28af45a..8ab31c1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2449,7 +2449,7 @@ static void tcp_try_keep_open(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	int state = TCP_CA_Open;
 
-	if (tcp_left_out(tp) || tcp_any_retrans_done(sk))
+	if (tp->sacked_out || tcp_any_retrans_done(sk))
 		state = TCP_CA_Disorder;
 
 	if (inet_csk(sk)->icsk_ca_state != state) {
-- 
1.7.1

