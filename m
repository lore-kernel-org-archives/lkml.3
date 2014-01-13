Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaAMQc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:32:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaAMQDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Durgin <josh.durgin@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 124/208] rbd: fix null dereference in dout
Date: Mon, 13 Jan 2014 15:59:25 +0000
Message-Id: <1389628849-1614-125-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit c35455791c1131e7ccbf56ea6fbdd562401c2ce2 upstream.

The order parameter is sometimes NULL in _rbd_dev_v2_snap_size(), but
the dout() always derefences it. Move this to another dout() protected
by a check that order is non-NULL.

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <alex.elder@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 0ab2829..853e622 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3702,12 +3702,14 @@ static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
 	if (ret < sizeof (size_buf))
 		return -ERANGE;
 
-	if (order)
+	if (order) {
 		*order = size_buf.order;
+		dout("  order %u", (unsigned int)*order);
+	}
 	*snap_size = le64_to_cpu(size_buf.size);
 
-	dout("  snap_id 0x%016llx order = %u, snap_size = %llu\n",
-		(unsigned long long)snap_id, (unsigned int)*order,
+	dout("  snap_id 0x%016llx snap_size = %llu\n",
+		(unsigned long long)snap_id,
 		(unsigned long long)*snap_size);
 
 	return 0;
-- 
1.8.3.2

