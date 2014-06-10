Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbaFJAWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:22:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaFJAWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 49/88] virtio: 9p: correctly pass physical address to userspace for high pages
Date: Mon,  9 Jun 2014 17:24:59 -0700
Message-Id: <20140610002426.158546523@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 30d395b124c51db66d9f3ba0611cd62021afc392 upstream.

commit b9cdc88df8e63e81c723b82c286fc97f5d0dc325 upstream.

When using a virtio transport, the 9p net device may pass the physical
address of a kernel buffer to userspace via a scatterlist inside a
virtqueue. If the kernel buffer is mapped outside of the linear mapping
(e.g. highmem), then virt_to_page will return a bogus value and we will
populate the scatterlist with junk.

This patch uses kmap_to_page when populating the page array for a kernel
buffer.

Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/9p/trans_virtio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -39,6 +39,7 @@
 #include <linux/inet.h>
 #include <linux/idr.h>
 #include <linux/file.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <linux/parser.h>
@@ -325,7 +326,7 @@ static int p9_get_mapped_pages(struct vi
 		int count = nr_pages;
 		while (nr_pages) {
 			s = rest_of_page(data);
-			pages[index++] = virt_to_page(data);
+			pages[index++] = kmap_to_page(data);
 			data += s;
 			nr_pages--;
 		}


