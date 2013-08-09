Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967728Ab3HICKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:10:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967667Ab3HIB7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Minchan Kim <minchan@kernel.org>
Subject: [ 063/102] zram: avoid double free in function zram_bvec_write()
Date: Thu,  8 Aug 2013 18:57:39 -0700
Message-Id: <20130809015025.045035629@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

commit 65c484609a3b25c35e4edcd5f2c38f98f5226093 upstream.

When doing a patial write and the whole page is filled with zero,
zram_bvec_write() will free uncmem twice.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -272,8 +272,6 @@ static int zram_bvec_write(struct zram *
 
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem);
-		if (is_partial_io(bvec))
-			kfree(uncmem);
 		zram->stats.pages_zero++;
 		zram_set_flag(meta, index, ZRAM_ZERO);
 		ret = 0;


