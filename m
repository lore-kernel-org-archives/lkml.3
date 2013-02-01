Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423089Ab3BANQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:16:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:45867 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422651Ab3BANQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:16:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Hargrove <phhargrove@lbl.gov>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <js1304@gmail.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 89/89] slub: assign refcount for kmalloc_caches
Date: Fri,  1 Feb 2013 14:08:44 +0100
Message-Id: <20130201130213.892451010@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: CAI Qian <caiqian@redhat.com>

This is for stable-3.7.y only and this problem has already been solved
in mainline through some slab/slub re-work which isn't suitable to
backport here. See create_kmalloc_cache() in mm/slab_common.c there.

commit cce89f4f6911286500cf7be0363f46c9b0a12ce0('Move kmem_cache
refcounting to common code') moves some refcount manipulation code to
common code. Unfortunately, it also removed refcount assignment for
kmalloc_caches. So, kmalloc_caches's refcount is initially 0.
This makes erroneous situation.

Paul Hargrove report that when he create a 8-byte kmem_cache and
destory it, he encounter below message.
'Objects remaining in kmalloc-8 on kmem_cache_close()'

8-byte kmem_cache merge with 8-byte kmalloc cache and refcount is
increased by one. So, resulting refcount is 1. When destroy it, it hit
refcount = 0, then kmem_cache_close() is executed and error message is
printed.

This patch assign initial refcount 1 to kmalloc_caches, so fix this
erroneous situation.

Reported-by: Paul Hargrove <phhargrove@lbl.gov>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3279,6 +3279,7 @@ static struct kmem_cache *__init create_
 	if (kmem_cache_open(s, flags))
 		goto panic;
 
+	s->refcount = 1;
 	list_add(&s->list, &slab_caches);
 	return s;
 


