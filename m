Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924AbaFXQ2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:28:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaFXPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:54:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 20/68] tcp: fix cwnd undo on DSACK in F-RTO
Date: Tue, 24 Jun 2014 11:50:39 -0400
Message-Id: <20140624154724.819101418@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 0cfa5c07d6d1d7f8e710fc671c5ba1ce85e09fa4 ]

This bug is discovered by an recent F-RTO issue on tcpm list
https://www.ietf.org/mail-archive/web/tcpm/current/msg08794.html

The bug is that currently F-RTO does not use DSACK to undo cwnd in
certain cases: upon receiving an ACK after the RTO retransmission in
F-RTO, and the ACK has DSACK indicating the retransmission is spurious,
the sender only calls tcp_try_undo_loss() if some never retransmisted
data is sacked (FLAG_ORIG_DATA_SACKED).

The correct behavior is to unconditionally call tcp_try_undo_loss so
the DSACK information is used properly to undo the cwnd reduction.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2683,13 +2683,12 @@ static void tcp_process_loss(struct sock
 	bool recovered = !before(tp->snd_una, tp->high_seq);
 
 	if (tp->frto) { /* F-RTO RFC5682 sec 3.1 (sack enhanced version). */
-		if (flag & FLAG_ORIG_SACK_ACKED) {
-			/* Step 3.b. A timeout is spurious if not all data are
-			 * lost, i.e., never-retransmitted data are (s)acked.
-			 */
-			tcp_try_undo_loss(sk, true);
+		/* Step 3.b. A timeout is spurious if not all data are
+		 * lost, i.e., never-retransmitted data are (s)acked.
+		 */
+		if (tcp_try_undo_loss(sk, flag & FLAG_ORIG_SACK_ACKED))
 			return;
-		}
+
 		if (after(tp->snd_nxt, tp->high_seq) &&
 		    (flag & FLAG_DATA_SACKED || is_dupack)) {
 			tp->frto = 0; /* Loss was real: 2nd part of step 3.a */


