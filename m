Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966580AbaFQVuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:50:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54356 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250AbaFQVuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Karl Heiss <kheiss@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 037/212] net: sctp: Don't transition to PF state when transport has exhausted 'Path.Max.Retrans'.
Date: Tue, 17 Jun 2014 14:42:11 -0700
Message-Id: <1403041506-13646-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Heiss <kheiss@gmail.com>

[ Upstream commit 8c2eab9097dba50bcd73ed4632baccc3f34857f9 ]

Don't transition to the PF state on every strike after 'Path.Max.Retrans'.
Per draft-ietf-tsvwg-sctp-failover-03 Section 5.1.6:

   Additional (PMR - PFMR) consecutive timeouts on a PF destination
   confirm the path failure, upon which the destination transitions to the
   Inactive state.  As described in [RFC4960], the sender (i) SHOULD notify
   ULP about this state transition, and (ii) transmit heartbeats to the
   Inactive destination at a lower frequency as described in Section 8.3 of
   [RFC4960].

This also prevents sending SCTP_ADDR_UNREACHABLE to the user as the state
bounces between SCTP_INACTIVE and SCTP_PF for each subsequent strike.

Signed-off-by: Karl Heiss <kheiss@gmail.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sctp/sm_sideeffect.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 04b1398..aa4ea94 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -497,11 +497,10 @@ static void sctp_do_8_2_transport_strike(sctp_cmd_seq_t *commands,
 
 	/* If the transport error count is greater than the pf_retrans
 	 * threshold, and less than pathmaxrtx, and if the current state
-	 * is not SCTP_UNCONFIRMED, then mark this transport as Partially
-	 * Failed, see SCTP Quick Failover Draft, section 5.1
+	 * is SCTP_ACTIVE, then mark this transport as Partially Failed,
+	 * see SCTP Quick Failover Draft, section 5.1
 	 */
-	if ((transport->state != SCTP_PF) &&
-	   (transport->state != SCTP_UNCONFIRMED) &&
+	if ((transport->state == SCTP_ACTIVE) &&
 	   (asoc->pf_retrans < transport->pathmaxrxt) &&
 	   (transport->error_count > asoc->pf_retrans)) {
 
-- 
1.9.1

