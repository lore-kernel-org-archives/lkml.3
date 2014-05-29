Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbaE2Efo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601AbaE2Efd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Karl Heiss <kheiss@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 101/140] net: sctp: Dont transition to PF state when transport has exhausted Path.Max.Retrans.
Date: Wed, 28 May 2014 21:34:00 -0700
Message-Id: <20140529043102.549604892@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_sideeffect.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -496,11 +496,10 @@ static void sctp_do_8_2_transport_strike
 
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
 


