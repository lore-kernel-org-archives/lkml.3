Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3EKQcK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 12:32:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29209 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3EKQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 12:32:08 -0400
Date: Sat, 11 May 2013 19:31:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Keith Busch <keith.busch@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] NVMe: check for integer overflow in nvme_map_user_pages()
Message-ID: <20130511163155.GA21427@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You need to have CAP_SYS_ADMIN to trigger this overflow but it makes the
static checkers complain so we should fix it.  The worry is that
"length" comes from copy_from_user() so we need to check that "length +
offset" can't overflow.

I also changed the min_t() cast to be unsigned instead of signed.  Now
that we cap "length" to INT_MAX it doesn't make a difference, but it's a
little easier for reviewers to know that large values aren't cast to
negative.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 8efdfaa..4376375 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1206,7 +1206,7 @@ struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
 
 	if (addr & 3)
 		return ERR_PTR(-EINVAL);
-	if (!length)
+	if (!length || length > INT_MAX - PAGE_SIZE)
 		return ERR_PTR(-EINVAL);
 
 	offset = offset_in_page(addr);
@@ -1227,7 +1227,8 @@ struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
 	sg_init_table(sg, count);
 	for (i = 0; i < count; i++) {
 		sg_set_page(&sg[i], pages[i],
-				min_t(int, length, PAGE_SIZE - offset), offset);
+			    min_t(unsigned, length, PAGE_SIZE - offset),
+			    offset);
 		length -= (PAGE_SIZE - offset);
 		offset = 0;
 	}
