Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbaBUAls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:41:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaBTXv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.12 20/82] iwlwifi: mvm: dont allow A band if SKU forbids it
Date: Thu, 20 Feb 2014 15:52:03 -0800
Message-Id: <20140220235020.085729537@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -182,6 +182,11 @@ static int iwl_init_channel_map(struct d
 
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


