Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3CATph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:45:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3CATpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 36/77] xen-blkback: use balloon pages for persistent grants
Date: Fri,  1 Mar 2013 11:44:21 -0800
Message-Id: <20130301194355.776286409@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

commit 087ffecdaa1875cc683a7a5bc0695b3ebfce3bad upstream.

With current persistent grants implementation we are not freeing the
persistent grants after we disconnect the device. Since grant map
operations change the mfn of the allocated page, and we can no longer
pass it to __free_page without setting the mfn to a sane value, use
balloon grant pages instead, as the gntdev device does.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/blkback.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -46,6 +46,7 @@
 #include <xen/xen.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
+#include <xen/balloon.h>
 #include "common.h"
 
 /*
@@ -239,6 +240,7 @@ static void free_persistent_gnts(struct
 			ret = gnttab_unmap_refs(unmap, NULL, pages,
 				segs_to_unmap);
 			BUG_ON(ret);
+			free_xenballooned_pages(segs_to_unmap, pages);
 			segs_to_unmap = 0;
 		}
 
@@ -527,8 +529,8 @@ static int xen_blkbk_map(struct blkif_re
 				GFP_KERNEL);
 			if (!persistent_gnt)
 				return -ENOMEM;
-			persistent_gnt->page = alloc_page(GFP_KERNEL);
-			if (!persistent_gnt->page) {
+			if (alloc_xenballooned_pages(1, &persistent_gnt->page,
+			    false)) {
 				kfree(persistent_gnt);
 				return -ENOMEM;
 			}


