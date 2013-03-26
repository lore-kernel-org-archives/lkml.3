Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965397Ab3CZPdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:33:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54112 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965354Ab3CZPXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 125/150] sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_board_cfg()
Date: Tue, 26 Mar 2013 15:20:24 +0000
Message-Id: <1364311249-14454-126-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit bfeed902946a31692e7a24ed355b6d13ac37d014 upstream.

On big-endian systems the MTD partition names currently have mangled
subtype numbers and are not recognised by the firmware update tool
(sfupdate).

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/mcdi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 17b6463..b49012d 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -641,9 +641,8 @@ int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
 			   u16 *fw_subtype_list, u32 *capabilities)
 {
 	uint8_t outbuf[MC_CMD_GET_BOARD_CFG_OUT_LENMIN];
-	size_t outlen;
+	size_t outlen, offset, i;
 	int port_num = efx_port_num(efx);
-	int offset;
 	int rc;
 
 	BUILD_BUG_ON(MC_CMD_GET_BOARD_CFG_IN_LEN != 0);
@@ -663,11 +662,16 @@ int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
 		: MC_CMD_GET_BOARD_CFG_OUT_MAC_ADDR_BASE_PORT0_OFST;
 	if (mac_address)
 		memcpy(mac_address, outbuf + offset, ETH_ALEN);
-	if (fw_subtype_list)
-		memcpy(fw_subtype_list,
-		       outbuf + MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_OFST,
-		       MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_MINNUM *
-		       sizeof(fw_subtype_list[0]));
+	if (fw_subtype_list) {
+		offset = MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_OFST;
+		for (i = 0;
+		     i < MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_MINNUM;
+		     i++) {
+			fw_subtype_list[i] =
+				le16_to_cpup((__le16 *)(outbuf + offset));
+			offset += 2;
+		}
+	}
 	if (capabilities) {
 		if (port_num)
 			*capabilities = MCDI_DWORD(outbuf,
-- 
1.8.1.2

