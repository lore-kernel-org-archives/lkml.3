Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaG0RAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 13:00:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbaG0RAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 13:00:45 -0400
Date: Sun, 27 Jul 2014 13:00:41 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Alexander Viro <viro@zeniv.linux.org.uk>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: make cont_expand_zero interruptible
Message-ID: <alpine.LRH.2.02.1407271255170.22290@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it possible to kill a process looping in
cont_expand_zero. A process may spend a lot of time in this function, so
it is desirable to be able to kill it.

It happened to me that I wanted to copy a piece data from the disk to a 
file. By mistake, I used the "seek" parameter to dd instead of "skip". Due 
to the "seek" parameter, dd attempted to extend the file and became stuck 
doing so - the only possibility was to reset the machine or wait many 
hours until the filesystem runs out of space and cont_expand_zero fails. 
We need this patch to be able to terminate the process.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 fs/buffer.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-3.14.12/fs/buffer.c
===================================================================
--- linux-3.14.12.orig/fs/buffer.c	2014-04-08 00:21:59.998849390 +0200
+++ linux-3.14.12/fs/buffer.c	2014-07-27 18:31:54.839750955 +0200
@@ -2311,6 +2311,11 @@ static int cont_expand_zero(struct file
 		err = 0;
 
 		balance_dirty_pages_ratelimited(mapping);
+
+		if (unlikely(fatal_signal_pending(current))) {
+			err = -EINTR;
+			goto out;
+		}
 	}
 
 	/* page covers the boundary, find the boundary offset */
