Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaC1SLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:11:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaC1RaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.4 03/13] iwlwifi: Complete backport of "iwlwifi: always copy first 16 bytes of commands"
Date: Fri, 28 Mar 2014 10:31:53 -0700
Message-Id: <20140328173053.522583654@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173053.049244535@linuxfoundation.org>
References: <20140328173053.049244535@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Linux 3.4.83 included an incomplete backport of commit
8a964f44e01ad3bbc208c3e80d931ba91b9ea786 ('iwlwifi: always copy first
16 bytes of commands') which causes a regression for this driver.
This is the missing piece.

Reported-by: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Andres Bertens <abertensu@yahoo.com>
Tested-by: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -825,14 +825,15 @@ static int iwl_enqueue_hcmd(struct iwl_t
 	trace_idx = 1;
 #endif
 
+	/* map the remaining (adjusted) nocopy/dup fragments */
 	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
-		if (!cmd->len[i])
+		if (!cmdlen[i])
 			continue;
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
 		phys_addr = dma_map_single(trans->dev,
-					   (void *)cmd->data[i],
-					   cmd->len[i], DMA_BIDIRECTIONAL);
+					   (void *)cmddata[i],
+					   cmdlen[i], DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
 			iwlagn_unmap_tfd(trans, out_meta,
 					 &txq->tfds[q->write_ptr],


