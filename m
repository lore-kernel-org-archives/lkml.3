Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaLCMDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:03:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaLCL1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dwight Engen <dwight.engen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 010/101] sunvdc: limit each sg segment to a page
Date: Wed,  3 Dec 2014 12:25:32 +0100
Message-Id: <d19343d672650096ab5e5966aaaa4665f9a0fdd9.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dwight Engen <dwight.engen@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 5eed69ffd248c9f68f56c710caf07db134aef28b ]

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.1.3

