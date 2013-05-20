Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3ETLB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:01:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56339 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab3ETKxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 086/115] sfc: Fix naming of MTD partitions for FPGA bitfiles
Date: Mon, 20 May 2013 11:51:26 +0100
Message-Id: <1369047116-9378-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit 89cc80a44b7c320e08599cb86f6aef0ead8986a1 upstream.

efx_mcdi_get_board_cfg() uses a buffer for the firmware response that
is only large enough to hold subtypes for the originally defined set
of NVRAM partitions.  Longer responses are truncated, and we may read
off the end of the buffer when copying out subtypes for additional
partitions.  In particular, this can result in the MTD partition for
an FPGA bitfile being named e.g. 'eth5 sfc_fpga:00' when it should be
'eth5 sfc_fpga:01'.  This means the firmware update tool (sfupdate)
can't tell which bitfile should be written to the partition.

Correct the response buffer size.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/mcdi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index eb85217..192026f 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -640,7 +640,7 @@ fail:
 int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
 			   u16 *fw_subtype_list, u32 *capabilities)
 {
-	uint8_t outbuf[MC_CMD_GET_BOARD_CFG_OUT_LENMIN];
+	uint8_t outbuf[MC_CMD_GET_BOARD_CFG_OUT_LENMAX];
 	size_t outlen, offset, i;
 	int port_num = efx_port_num(efx);
 	int rc;
-- 
1.8.1.2

