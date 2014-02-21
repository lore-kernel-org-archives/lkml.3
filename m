Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbaBUNnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:43:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbaBUMuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 054/121] iwlwifi: mvm: don't allow A band if SKU forbids it
Date: Fri, 21 Feb 2014 12:47:58 +0000
Message-Id: <1392986945-9693-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit c512865446e6dd5b6e91e81187e75b734ad7cfc7 upstream.

The driver wasn't reading the NVM properly. While this
didn't lead to any issue until now, it seems that there
is an old version of the NVM in the wild.
In this version, the A band channels appear to be valid
but the SKU capabilities (another field of the NVM) says
that A band isn't supported at all.
With this specific version of the NVM, the driver would
think that A band is supported while the HW / firmware
don't. This leads to asserts.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index acd2665..de3c827 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -181,6 +181,11 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 
 	for (ch_idx = 0; ch_idx < IWL_NUM_CHANNELS; ch_idx++) {
 		ch_flags = __le16_to_cpup(nvm_ch_flags + ch_idx);
+
+		if (ch_idx >= NUM_2GHZ_CHANNELS &&
+		    !data->sku_cap_band_52GHz_enable)
+			ch_flags &= ~NVM_CHANNEL_VALID;
+
 		if (!(ch_flags & NVM_CHANNEL_VALID)) {
 			IWL_DEBUG_EEPROM(dev,
 					 "Ch. %d Flags %x [%sGHz] - No traffic\n",
-- 
1.9.0

