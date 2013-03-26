Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab3CZSAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:00:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab3CZRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:07 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9iTNIdmRCsIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=MBO-3L79N98A:10 a=CbDCq_QkAAAA:8 a=J1Y8HTJGAAAA:8 a=kWDgOHFhbxVf0gkMJRgA:9 a=E3yz0KKPV6YA:10 a=4N9Db7Z2_RYA:10 a=rMZeJswTUlgqZbQ9:21 a=H81vxywYgBQfzU1U:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173602.065594178@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Amir Vadai <amirv@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 14/86] net/mlx4_core: Set number of msix vectors under SRIOV mode to
 firmware defaults
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0014-net-mlx4_core-Set-number-of-msix-vectors-under-SRIOV.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

[ Upstream commit ca4c7b35f75492de7fbf5ee95be07481c348caee ]

The lines

	if (mlx4_is_mfunc(dev)) {
		nreq = 2;
	} else {

which hard code the number of requested msi-x vectors under multi-function
mode to two can be removed completely, since the firmware sets num_eqs and
reserved_eqs appropriately Thus, the code line:

	nreq = min_t(int, dev->caps.num_eqs - dev->caps.reserved_eqs, nreq);

is by itself sufficient and correct for all cases. Currently, for mfunc
mode num_eqs = 32 and reserved_eqs = 28, hence four vectors will be enabled.

This triples (one vector is used for the async events and commands EQ) the
horse power provided for processing of incoming packets on netdev RSS scheme,
IO initiators/targets commands processing flows, etc.

Reviewed-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Amir Vadai <amirv@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 2f816c6..8ca1ed8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1630,15 +1630,8 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
 	int i;
 
 	if (msi_x) {
-		/* In multifunction mode each function gets 2 msi-X vectors
-		 * one for data path completions anf the other for asynch events
-		 * or command completions */
-		if (mlx4_is_mfunc(dev)) {
-			nreq = 2;
-		} else {
-			nreq = min_t(int, dev->caps.num_eqs -
-				     dev->caps.reserved_eqs, nreq);
-		}
+		nreq = min_t(int, dev->caps.num_eqs - dev->caps.reserved_eqs,
+			     nreq);
 
 		entries = kcalloc(nreq, sizeof *entries, GFP_KERNEL);
 		if (!entries)
-- 
1.7.10.4


