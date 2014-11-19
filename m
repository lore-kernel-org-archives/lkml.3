Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbaKSVOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:14:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840AbaKSVOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dwight Engen <dwight.engen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 07/70] sunvdc: limit each sg segment to a page
Date: Wed, 19 Nov 2014 12:51:58 -0800
Message-Id: <20141119205211.154315647@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dwight Engen <dwight.engen@oracle.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/sunvdc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -747,6 +747,10 @@ static int probe_disk(struct vdc_port *p
 
 	port->disk = g;
 
+	/* Each segment in a request is up to an aligned page in size. */
+	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
+	blk_queue_max_segment_size(q, PAGE_SIZE);
+
 	blk_queue_max_segments(q, port->ring_cookies);
 	blk_queue_max_hw_sectors(q, port->max_xfer_size);
 	g->major = vdc_major;


