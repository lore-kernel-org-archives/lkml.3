Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3AMRwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:52:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35036 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755452Ab3AMRpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:36 -0500
Message-Id: <20130113174305.416443207@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:41 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 46/49] RDMA/nes: Fix for crash when registering zero length MR for CQ
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>

commit 7d9c199a55200c9b9fcad08e150470d02fb385be upstream.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index c47ec25..07e4fba 100644
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


