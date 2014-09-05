Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaIEQQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:16:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaIEQQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:16:06 -0400
Date: Fri, 5 Sep 2014 12:16:01 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Miklos Szeredi <mszeredi@suse.cz>
cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dcache: fix kmemcheck warning in switch_names
Message-ID: <alpine.LRH.2.02.1409051214450.5269@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes kmemcheck warning in switch_names. The function
switch_names swaps inline names of two dentries. It swaps full arrays
d_iname, no matter how many bytes are really used by the strings. Reading
data beyond string ends results in kmemcheck warning.

We fix the bug by marking both arrays as fully initialized.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org # v3.15

---
 fs/dcache.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2014-09-04 23:04:21.000000000 +0200
+++ linux-2.6/fs/dcache.c	2014-09-04 23:43:11.000000000 +0200
@@ -2407,6 +2407,8 @@ static void switch_names(struct dentry *
 			 */
 			unsigned int i;
 			BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
+			kmemcheck_mark_initialized(dentry->d_iname, DNAME_INLINE_LEN);
+			kmemcheck_mark_initialized(target->d_iname, DNAME_INLINE_LEN);
 			for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
 				swap(((long *) &dentry->d_iname)[i],
 				     ((long *) &target->d_iname)[i]);
