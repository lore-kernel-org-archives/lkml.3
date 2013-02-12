Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab3BLUlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:41:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab3BLUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Amir Vadai <amirv@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 14/36] net/mlx4_core: Set number of msix vectors under SRIOV mode to firmware defaults
Date: Tue, 12 Feb 2013 12:41:08 -0800
Message-Id: <20130212203858.992468597@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203857.305594226@linuxfoundation.org>
References: <20130212203857.305594226@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1526,15 +1526,8 @@ static void mlx4_enable_msi_x(struct mlx
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


