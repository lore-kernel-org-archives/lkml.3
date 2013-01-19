Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3ASBZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:25:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:57184 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672Ab3ASBWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:22:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Rustad <mark.d.rustad@intel.com>,
        Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 03/16] tcm_fc: Do not report target role when target is not defined
Date: Fri, 18 Jan 2013 17:21:41 -0800
Message-Id: <20130119012139.111316918@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119012138.680057206@linuxfoundation.org>
References: <20130119012138.680057206@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit edec8dfefa1f372b2dd8197da555352e76a10c03 upstream.

Clear the target role when no target is provided for
the node performing a PRLI.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Reviewed-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Acked by Robert Love <robert.w.love@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/tcm_fc/tfc_sess.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -393,11 +393,11 @@ static int ft_prli_locked(struct fc_rpor
 
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
@@ -440,6 +440,12 @@ fill:
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


