Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3BDQmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:42:47 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:54874 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab3BDQmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:42:44 -0500
Date: Mon, 4 Feb 2013 08:42:38 -0800
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Vlad Yasevich <vyasevich@gmail.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org
Subject: [PATCH v2 60/62] sctp: convert to idr_alloc()
Message-ID: <20130204164238.GC27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-61-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-61-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

v2: Don't preload if @gfp doesn't contain __GFP_WAIT as the function
    may be being called from non-process ocntext.  Also, add a comment
    explaining @idr_low never becomes zero.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Cc: linux-sctp@vger.kernel.org
---
 net/sctp/associola.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1592,32 +1592,31 @@ int sctp_assoc_lookup_laddr(struct sctp_
 /* Set an association id for a given association */
 int sctp_assoc_set_id(struct sctp_association *asoc, gfp_t gfp)
 {
-	int assoc_id;
-	int error = 0;
+	bool preload = gfp & __GFP_WAIT;
+	int ret;
 
 	/* If the id is already assigned, keep it. */
 	if (asoc->assoc_id)
-		return error;
-retry:
-	if (unlikely(!idr_pre_get(&sctp_assocs_id, gfp)))
-		return -ENOMEM;
+		return 0;
 
+	if (preload)
+		idr_preload(gfp);
 	spin_lock_bh(&sctp_assocs_id_lock);
-	error = idr_get_new_above(&sctp_assocs_id, (void *)asoc,
-				    idr_low, &assoc_id);
-	if (!error) {
-		idr_low = assoc_id + 1;
+	/* 0 is not a valid id, idr_low is always >= 1 */
+	ret = idr_alloc(&sctp_assocs_id, asoc, idr_low, 0, GFP_NOWAIT);
+	if (ret >= 0) {
+		idr_low = ret + 1;
 		if (idr_low == INT_MAX)
 			idr_low = 1;
 	}
 	spin_unlock_bh(&sctp_assocs_id_lock);
-	if (error == -EAGAIN)
-		goto retry;
-	else if (error)
-		return error;
+	if (preload)
+		idr_preload_end();
+	if (ret < 0)
+		return ret;
 
-	asoc->assoc_id = (sctp_assoc_t) assoc_id;
-	return error;
+	asoc->assoc_id = (sctp_assoc_t)ret;
+	return 0;
 }
 
 /* Free the ASCONF queue */
