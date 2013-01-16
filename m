Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab3APQYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:24:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab3APQJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:09:06 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 180/222] RDMA/nes: Fix for crash when registering zero length MR for CQ
Date: Wed, 16 Jan 2013 13:56:20 -0200
Message-Id: <1358351822-7675-181-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>

commit 7d9c199a55200c9b9fcad08e150470d02fb385be upstream.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 2359568..da84ea3 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2561,6 +2561,11 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			return ibmr;
 		case IWNES_MEMREG_TYPE_QP:
 		case IWNES_MEMREG_TYPE_CQ:
+			if (!region->length) {
+				nes_debug(NES_DBG_MR, "Unable to register zero length region for CQ\n");
+				ib_umem_release(region);
+				return ERR_PTR(-EINVAL);
+			}
 			nespbl = kzalloc(sizeof(*nespbl), GFP_KERNEL);
 			if (!nespbl) {
 				nes_debug(NES_DBG_MR, "Unable to allocate PBL\n");
-- 
1.7.9.5

