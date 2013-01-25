Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab3AYRc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:32:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39947 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab3AYRcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:32:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] xen/blkback: Don't trust the handle from the frontend.
Date: Fri, 25 Jan 2013 12:32:30 -0500
Message-Id: <1359135152-30688-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'handle' is the device that the request is from. For the life-time
of the ring we copy it from a request to a response so that the frontend
is not surprised by it. But we do not need it - when we start processing
I/Os we have our own 'struct phys_req' which has only most essential
information about the request. In fact the 'vbd_translate' ends up
over-writing the preq.dev with a value from the backend.

This assignment of preq.dev with the 'handle' value is superfluous
so lets not do it.

Cc: stable@vger.kernel.org
Acked-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 742871d..2de3da9 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -890,7 +890,6 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		goto fail_response;
 	}
 
-	preq.dev           = req->u.rw.handle;
 	preq.sector_number = req->u.rw.sector_number;
 	preq.nr_sects      = 0;
 
-- 
1.8.0.2

