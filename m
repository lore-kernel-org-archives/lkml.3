Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbaKSWJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:09:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350AbaKSVEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weijie Yang <weijie.yang@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Weijie Yang <weijie.yang.kh@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 018/122] zram: avoid kunmap_atomic() of a NULL pointer
Date: Wed, 19 Nov 2014 12:51:08 -0800
Message-Id: <20141119205209.410628702@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weijie Yang <weijie.yang@samsung.com>

commit c406515239376fc93a30d5d03192182160cbd3fb upstream.

zram could kunmap_atomic() a NULL pointer in a rare situation: a zram
page becomes a full-zeroed page after a partial write io.  The current
code doesn't handle this case and performs kunmap_atomic() on a NULL
pointer, which panics the kernel.

This patch fixes this issue.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Weijie Yang <weijie.yang.kh@gmail.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -447,7 +447,8 @@ static int zram_bvec_write(struct zram *
 	}
 
 	if (page_zero_filled(uncmem)) {
-		kunmap_atomic(user_mem);
+		if (user_mem)
+			kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
 		write_lock(&zram->meta->tb_lock);
 		zram_free_page(zram, index);


