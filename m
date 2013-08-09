Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967759Ab3HICF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:05:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967734Ab3HIB71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wang Shilong <wangsl-fnst@cn.fujitsu.com>,
        Liu Bo <bo.li.liu@oracle.com>, Josef Bacik <jbacik@fusionio.com>,
        BJ Quinn <bj@placs.net>
Subject: [ 079/102] Btrfs: fix crash regarding to ulist_add_merge
Date: Thu,  8 Aug 2013 18:57:55 -0700
Message-Id: <20130809015028.841897698@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 35f0399db6658f465b00893bdd13b992a0acfef0 upstream.

Several users reported this crash of NULL pointer or general protection,
the story is that we add a rbtree for speedup ulist iteration, and we
use krealloc() to address ulist growth, and krealloc() use memcpy to copy
old data to new memory area, so it's OK for an array as it doesn't use
pointers while it's not OK for a rbtree as it uses pointers.

So krealloc() will mess up our rbtree and it ends up with crash.

Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Cc: BJ Quinn <bj@placs.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ulist.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -205,6 +205,10 @@ int ulist_add_merge(struct ulist *ulist,
 		u64 new_alloced = ulist->nodes_alloced + 128;
 		struct ulist_node *new_nodes;
 		void *old = NULL;
+		int i;
+
+		for (i = 0; i < ulist->nnodes; i++)
+			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
 
 		/*
 		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
@@ -224,6 +228,17 @@ int ulist_add_merge(struct ulist *ulist,
 
 		ulist->nodes = new_nodes;
 		ulist->nodes_alloced = new_alloced;
+
+		/*
+		 * krealloc actually uses memcpy, which does not copy rb_node
+		 * pointers, so we have to do it ourselves.  Otherwise we may
+		 * be bitten by crashes.
+		 */
+		for (i = 0; i < ulist->nnodes; i++) {
+			ret = ulist_rbtree_insert(ulist, &ulist->nodes[i]);
+			if (ret < 0)
+				return ret;
+		}
 	}
 	ulist->nodes[ulist->nnodes].val = val;
 	ulist->nodes[ulist->nnodes].aux = aux;


