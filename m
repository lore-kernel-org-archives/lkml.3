Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334Ab3DKXQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:16:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987Ab3DKXQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:16:22 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=bL5lP_IMZyYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=kHY-xKwvBVYA:10 a=zRKbQ67AAAAA:8 a=BdSzHFd4GoWGX_EKpAYA:9 a=1Dwx9gnmAe4A:10 a=jeBq3FmKZ4MA:10 a=R9zbO9izuK7ShsZ1:21 a=l53X2zpWUUbykdel:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411231620.290887968@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 19:11:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 3/9 ] sfc: Convert firmware subtypes to native byte order in
 efx_mcdi_get_board_cfg()
References: <20130411231149.302144972@goodmis.org>
Content-Disposition: inline; filename=0003-sfc-Convert-firmware-subtypes-to-native-byte-order-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit bfeed902946a31692e7a24ed355b6d13ac37d014 ]

On big-endian systems the MTD partition names currently have mangled
subtype numbers and are not recognised by the firmware update tool
(sfupdate).

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/sfc/mcdi.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index fc5e7bb..516a437 100644
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
1.7.10.4


