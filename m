Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab3CHMij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:38:39 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50231 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3CHMih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:38:37 -0500
Message-ID: <5139DB90.5090302@gmail.com>
Date: Fri, 08 Mar 2013 20:37:36 +0800
From: Shuge <shugelinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org
CC: Kevin <kevin@allwinneretch.com>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] bounce:fix bug, avoid to flush dcache on slab page from jbd2.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bounce accept slab pages from jbd2, and flush dcache on them.
When enabling VM_DEBUG, it will tigger VM_BUG_ON in page_mapping().
So, check PageSlab to avoid it in __blk_queue_bounce().

Bug URL: http://lkml.org/lkml/2013/3/7/56

Signed-off-by: shuge <shuge@allwinnertech.com>
---
  mm/bounce.c |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/bounce.c b/mm/bounce.c
index 4e9ae72..f352c03 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -214,7 +214,8 @@ static void __blk_queue_bounce(struct request_queue 
*q, struct bio **bio_orig,
  		if (rw == WRITE) {
  			char *vto, *vfrom;
  -			flush_dcache_page(from->bv_page);
+			if (unlikely(!PageSlab(from->bv_page)))
+				flush_dcache_page(from->bv_page);
  			vto = page_address(to->bv_page) + to->bv_offset;
  			vfrom = kmap(from->bv_page) + from->bv_offset;
  			memcpy(vto, vfrom, to->bv_len);
-- 
1.7.9.5

