Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007Ab3DHKI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:08:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42876 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935082Ab3DHJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yuchung Cheng <ycheng@google.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 061/102] tcp: undo spurious timeout after SACK reneging
Date: Mon,  8 Apr 2013 10:50:16 +0100
Message-Id: <1365414657-29191-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

commit 7ebe183c6d444ef5587d803b64a1f4734b18c564 upstream.

On SACK reneging the sender immediately retransmits and forces a
timeout but disables Eifel (undo). If the (buggy) receiver does not
drop any packet this can trigger a false slow-start retransmit storm
driven by the ACKs of the original packets. This can be detected with
undo and TCP timestamps.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_input.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 410b7c4..e75e4fb 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2267,11 +2267,8 @@ void tcp_enter_loss(struct sock *sk, int how)
 	if (tcp_is_reno(tp))
 		tcp_reset_reno_sack(tp);
 
-	if (!how) {
-		/* Push undo marker, if it was plain RTO and nothing
-		 * was retransmitted. */
-		tp->undo_marker = tp->snd_una;
-	} else {
+	tp->undo_marker = tp->snd_una;
+	if (how) {
 		tp->sacked_out = 0;
 		tp->fackets_out = 0;
 	}
-- 
1.8.1.2

