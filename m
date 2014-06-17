Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967606AbaFQW0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:26:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54300 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965384AbaFQVuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 036/212] net: sctp: Potentially-Failed state should not be reached from unconfirmed state
Date: Tue, 17 Jun 2014 14:42:10 -0700
Message-Id: <1403041506-13646-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>

commit 7cce3b75682ff898c935c17d186983cbf3ed393e upstream.

In current implementation it is possible to reach PF state from unconfirmed.
We can interpret sctp-failover-02 in a way that PF state is meant to be reached
only from active state, in the end, this is when entering PF state makes sense.
Here are few quotes from sctp-failover-02, but regardless of these, same
understanding can be reached from whole section 5:

Section 5.1, quickfailover guide:
    "The PF state is an intermediate state between Active and Failed states."

    "Each time the T3-rtx timer expires on an active or idle
    destination, the error counter of that destination address will
    be incremented.  When the value in the error counter exceeds
    PFMR, the endpoint should mark the destination transport address as PF."

There are several concrete reasons for such interpretation. For start, rfc4960
does not take into concern quickfailover algorithm. Therefore, quickfailover
must comply to 4960. Point where this compliance can be argued is following
behavior:
When PF is entered, association overall error counter is incremented for each
missed HB. This is contradictory to rfc4960, as address, while in unconfirmed
state, is subjected to probing, and while it is probed, it should not increment
association overall error counter. This has as a consequence that we might end
up in situation in which we drop association due path failure on unconfirmed
address, in case we have wrong configuration in a way:
Association.Max.Retrans == Path.Max.Retrans.

Another reason is that entering PF from unconfirmed will cause a loss of address
confirmed event when address is once (if) confirmed. This is fine from failover
guide point of view, but it is not consistent with behavior preceding failover
implementation and recommendation from 4960:

5.4.  Path Verification
   Whenever a path is confirmed, an indication MAY be given to the upper
   layer.

Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sctp/sm_sideeffect.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 1a6eef3..04b1398 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -496,11 +496,12 @@ static void sctp_do_8_2_transport_strike(sctp_cmd_seq_t *commands,
 	}
 
 	/* If the transport error count is greater than the pf_retrans
-	 * threshold, and less than pathmaxrtx, then mark this transport
-	 * as Partially Failed, ee SCTP Quick Failover Draft, secon 5.1,
-	 * point 1
+	 * threshold, and less than pathmaxrtx, and if the current state
+	 * is not SCTP_UNCONFIRMED, then mark this transport as Partially
+	 * Failed, see SCTP Quick Failover Draft, section 5.1
 	 */
 	if ((transport->state != SCTP_PF) &&
+	   (transport->state != SCTP_UNCONFIRMED) &&
 	   (asoc->pf_retrans < transport->pathmaxrxt) &&
 	   (transport->error_count > asoc->pf_retrans)) {
 
-- 
1.9.1

