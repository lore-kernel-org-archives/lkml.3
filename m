Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbaJCWF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:05:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaJCWEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:04:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xishi Qiu <qiuxishi@huawei.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 123/238] memblock, memhotplug: fix wrong type in memblock_find_in_range_node().
Date: Fri,  3 Oct 2014 14:30:38 -0700
Message-Id: <20141003212917.615672620@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tang Chen <tangchen@cn.fujitsu.com>

commit 0cfb8f0c3e21e36d4a6e472e4c419d58ba848698 upstream.

In memblock_find_in_range_node(), we defined ret as int.  But it should
be phys_addr_t because it is used to store the return value from
__memblock_find_range_bottom_up().

The bug has not been triggered because when allocating low memory near
the kernel end, the "int ret" won't turn out to be negative.  When we
started to allocate memory on other nodes, and the "int ret" could be
minus.  Then the kernel will panic.

A simple way to reproduce this: comment out the following code in
numa_init(),

        memblock_set_bottom_up(false);

and the kernel won't boot.

Reported-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memblock.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -183,8 +183,7 @@ phys_addr_t __init_memblock memblock_fin
 					phys_addr_t align, phys_addr_t start,
 					phys_addr_t end, int nid)
 {
-	int ret;
-	phys_addr_t kernel_end;
+	phys_addr_t kernel_end, ret;
 
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)


