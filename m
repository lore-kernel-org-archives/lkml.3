Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab3CZXXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:23:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab3CZWwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 16/72] sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_board_cfg()
Date: Tue, 26 Mar 2013 15:50:59 -0700
Message-Id: <20130326224921.398826426@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit bfeed902946a31692e7a24ed355b6d13ac37d014 ]

On big-endian systems the MTD partition names currently have mangled
subtype numbers and are not recognised by the firmware update tool
(sfupdate).

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/mcdi.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -641,9 +641,8 @@ int efx_mcdi_get_board_cfg(struct efx_ni
 			   u16 *fw_subtype_list, u32 *capabilities)
 {
 	uint8_t outbuf[MC_CMD_GET_BOARD_CFG_OUT_LENMIN];
-	size_t outlen;
+	size_t outlen, offset, i;
 	int port_num = efx_port_num(efx);
-	int offset;
 	int rc;
 
 	BUILD_BUG_ON(MC_CMD_GET_BOARD_CFG_IN_LEN != 0);
@@ -663,11 +662,16 @@ int efx_mcdi_get_board_cfg(struct efx_ni
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


