Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3BCPSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:18:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34227 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab3BCOzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:42 -0500
Message-Id: <20130203144647.074088437@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Mark Rustad <mark.d.rustad@intel.com>,
        Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 034/128] tcm_fc: Do not report target role when target is not defined
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit edec8dfefa1f372b2dd8197da555352e76a10c03 upstream.

Clear the target role when no target is provided for
the node performing a PRLI.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Reviewed-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Acked by Robert Love <robert.w.love@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/tcm_fc/tfc_sess.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 59f2b46..6659dd3 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -355,11 +355,11 @@ static int ft_prli_locked(struct fc_rport_priv *rdata, u32 spp_len,
 
 	tport = ft_tport_create(rdata->local_port);
 	if (!tport)
-		return 0;	/* not a target for this local port */
+		goto not_target;	/* not a target for this local port */
 
 	acl = ft_acl_get(tport->tpg, rdata);
 	if (!acl)
-		return 0;
+		goto not_target;	/* no target for this remote */
 
 	if (!rspp)
 		goto fill;
@@ -402,6 +402,12 @@ fill:
 	fcp_parm &= ~FCP_SPPF_RETRY;
 	spp->spp_params = htonl(fcp_parm | FCP_SPPF_TARG_FCN);
 	return FC_SPP_RESP_ACK;
+
+not_target:
+	fcp_parm = ntohl(spp->spp_params);
+	fcp_parm &= ~FCP_SPPF_TARG_FCN;
+	spp->spp_params = htonl(fcp_parm);
+	return 0;
 }
 
 /**


