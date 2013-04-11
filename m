Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470Ab3DKXQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:16:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32844 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229Ab3DKXQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:16:22 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=IHwBNUiHl2QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=CjaTJXmGyS0A:10 a=zRKbQ67AAAAA:8 a=f813_1m-eiNqfMHDDVEA:9 a=1Dwx9gnmAe4A:10 a=jeBq3FmKZ4MA:10 a=vKy7n8QGiYgZRhPZ:21 a=JZg6JGPxgYCnxEs3:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411231620.794246947@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 19:11:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 6/9 ] sfc: Avoid generating over-length MC_CMD_FLUSH_RX_QUEUES request
References: <20130411231149.302144972@goodmis.org>
Content-Disposition: inline; filename=0006-sfc-Avoid-generating-over-length-MC_CMD_FLUSH_RX_QUE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 450783747f42dfa3883920acfad4acdd93ce69af ]

MCDI supports requests up to 252 bytes long, which is only enough to
pass 63 RX queue IDs to MC_CMD_FLUSH_RX_QUEUES.  However a VF may have
up to 64 RX queues, and if we try to flush them all we will generate
an over-length request and BUG() in efx_mcdi_copyin().  Currently
all VF drivers limit themselves to 32 RX queues, so reducing the
limit to 63 does no harm.

Also add a BUILD_BUG_ON in efx_mcdi_flush_rxqs() so we remember to
deal with the same problem there if EFX_MAX_CHANNELS is increased.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/sfc/mcdi.c        |    3 +++
 drivers/net/ethernet/sfc/siena_sriov.c |    7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 516a437..319a73e 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -1173,6 +1173,9 @@ int efx_mcdi_flush_rxqs(struct efx_nic *efx)
 	__le32 *qid;
 	int rc, count;
 
+	BUILD_BUG_ON(EFX_MAX_CHANNELS >
+		     MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_MAXNUM);
+
 	qid = kmalloc(EFX_MAX_CHANNELS * sizeof(*qid), GFP_KERNEL);
 	if (qid == NULL)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/sfc/siena_sriov.c b/drivers/net/ethernet/sfc/siena_sriov.c
index 78f5408..4ad8082 100644
--- a/drivers/net/ethernet/sfc/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena_sriov.c
@@ -21,6 +21,9 @@
 /* Number of longs required to track all the VIs in a VF */
 #define VI_MASK_LENGTH BITS_TO_LONGS(1 << EFX_VI_SCALE_MAX)
 
+/* Maximum number of RX queues supported */
+#define VF_MAX_RX_QUEUES 63
+
 /**
  * enum efx_vf_tx_filter_mode - TX MAC filtering behaviour
  * @VF_TX_FILTER_OFF: Disabled
@@ -578,6 +581,7 @@ static int efx_vfdi_init_rxq(struct efx_vf *vf)
 	efx_oword_t reg;
 
 	if (bad_vf_index(efx, vf_evq) || bad_vf_index(efx, vf_rxq) ||
+	    vf_rxq >= VF_MAX_RX_QUEUES ||
 	    bad_buf_count(buf_count, EFX_MAX_DMAQ_SIZE)) {
 		if (net_ratelimit())
 			netif_err(efx, hw, efx->net_dev,
@@ -683,6 +687,9 @@ static int efx_vfdi_fini_all_queues(struct efx_vf *vf)
 	__le32 *rxqs;
 	int rc;
 
+	BUILD_BUG_ON(VF_MAX_RX_QUEUES >
+		     MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_MAXNUM);
+
 	rxqs = kmalloc(count * sizeof(*rxqs), GFP_KERNEL);
 	if (rxqs == NULL)
 		return VFDI_RC_ENOMEM;
-- 
1.7.10.4


