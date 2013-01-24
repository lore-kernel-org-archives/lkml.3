Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3AXDbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:31:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44315 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3AXDaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Rustad <mark.d.rustad@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 42/74] tcm_fc: Do not report target role when target is not defined
Date: Thu, 24 Jan 2013 01:26:54 -0200
Message-Id: <1358998046-613-43-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit edec8dfefa1f372b2dd8197da555352e76a10c03 upstream.

Clear the target role when no target is provided for
the node performing a PRLI.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Reviewed-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Acked by Robert Love <robert.w.love@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/tcm_fc/tfc_sess.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 34d7b25..9249998 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -356,11 +356,11 @@ static int ft_prli_locked(struct fc_rport_priv *rdata, u32 spp_len,
 
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
@@ -403,6 +403,12 @@ fill:
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
-- 
1.7.9.5

