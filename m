Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbaAFW7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:59:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245AbaAFWmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Elder <elder@inktank.com>, Josh Durgin <josh.durgin@inktank.com>
Subject: [PATCH 3.10 094/129] rbd: flush dcache after zeroing page data
Date: Mon,  6 Jan 2014 14:38:43 -0800
Message-Id: <20140106223902.292912045@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit e215605417b87732c6debf65da6d953016a1e5bc upstream.

Neither zero_bio_chain() nor zero_pages() contains a call to flush
caches after zeroing a portion of a page.  This can cause problems
on architectures that have caches that allow virtual address
aliasing.

This resolves:
    http://tracker.ceph.com/issues/4777

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1126,6 +1126,7 @@ static void zero_bio_chain(struct bio *c
 				buf = bvec_kmap_irq(bv, &flags);
 				memset(buf + remainder, 0,
 				       bv->bv_len - remainder);
+				flush_dcache_page(bv->bv_page);
 				bvec_kunmap_irq(buf, &flags);
 			}
 			pos += bv->bv_len;
@@ -1158,6 +1159,7 @@ static void zero_pages(struct page **pag
 		local_irq_save(flags);
 		kaddr = kmap_atomic(*page);
 		memset(kaddr + page_offset, 0, length);
+		flush_dcache_page(*page);
 		kunmap_atomic(kaddr);
 		local_irq_restore(flags);
 


