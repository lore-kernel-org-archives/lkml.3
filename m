Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab3EQWEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:04:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3EQVrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 26/50] sfc: Fix naming of MTD partitions for FPGA bitfiles
Date: Fri, 17 May 2013 14:47:01 -0700
Message-Id: <20130517213845.461216268@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 89cc80a44b7c320e08599cb86f6aef0ead8986a1 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/mcdi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


