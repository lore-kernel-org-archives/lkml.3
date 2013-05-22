Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab3EVC4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:56:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47443 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3EVCz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:55:57 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v7 4/8] vmalloc: make find_vm_area check in range
To: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org
Cc: cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Date: Wed, 22 May 2013 11:55:55 +0900
Message-ID: <20130522025554.12215.93860.stgit@localhost6.localdomain6>
In-Reply-To: <20130522025410.12215.16793.stgit@localhost6.localdomain6>
References: <20130522025410.12215.16793.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, __find_vmap_area searches for the kernel VM area starting
at a given address. This patch changes this behavior so that it
searches for the kernel VM area to which the address belongs. This
change is needed by remap_vmalloc_range_partial to be introduced in
later patch that receives any position of kernel VM area as target
address.

This patch changes the condition (addr > va->va_start) to the
equivalent (addr >= va->va_end) by taking advantage of the fact that
each kernel VM area is non-overlapping.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---

 mm/vmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d365724..3875fa2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -292,7 +292,7 @@ static struct vmap_area *__find_vmap_area(unsigned long addr)
 		va = rb_entry(n, struct vmap_area, rb_node);
 		if (addr < va->va_start)
 			n = n->rb_left;
-		else if (addr > va->va_start)
+		else if (addr >= va->va_end)
 			n = n->rb_right;
 		else
 			return va;

