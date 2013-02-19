Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934488Ab3BSTDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:03:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934306Ab3BSSxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amir Vadai <amirv@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 50/81] net/mlx4_core: Set number of msix vectors under SRIOV mode to firmware defaults
Date: Tue, 19 Feb 2013 15:49:13 -0300
Message-Id: <1361299784-8830-51-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

commit ca4c7b35f75492de7fbf5ee95be07481c348caee upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index a0313de..c749b82 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1545,15 +1545,8 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
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
1.7.9.5

