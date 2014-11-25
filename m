Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaKYKno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59162 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaKYKnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dwight Engen <dwight.engen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 228/254] sunvdc: limit each sg segment to a page
Date: Tue, 25 Nov 2014 10:39:38 +0000
Message-Id: <1416912004-5928-229-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dwight Engen <dwight.engen@oracle.com>

commit 5eed69ffd248c9f68f56c710caf07db134aef28b upstream.

ldc_map_sg() could fail its check that the number of pages referred to
by the sg scatterlist was <= the number of cookies.

This fixes the issue by doing a similar thing to the xen-blkfront driver,
ensuring that the scatterlist will only ever contain a segment count <=
port->ring_cookies, and each segment will be page aligned, and <= page
size. This ensures that the scatterlist is always mappable.

Orabug: 19347817
OraBZ: 15945

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/sunvdc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 1616ad091a5e..1a9360da1f54 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -747,6 +747,10 @@ static int probe_disk(struct vdc_port *port)
 
 	port->disk = g;
 
+	/* Each segment in a request is up to an aligned page in size. */
+	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
+	blk_queue_max_segment_size(q, PAGE_SIZE);
+
 	blk_queue_max_segments(q, port->ring_cookies);
 	blk_queue_max_hw_sectors(q, port->max_xfer_size);
 	g->major = vdc_major;
-- 
2.1.0

