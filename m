Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab3CDL3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:29:43 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:45632 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab3CDL3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:29:42 -0500
Date: Mon, 4 Mar 2013 11:29:41 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] epoll: trim epitem by one cache line on x86_64
Message-ID: <20130304112941.GA16284@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is common for epoll users to have thousands of epitems, so saving a
cache line on every allocation leads to large memory savings.

Since epitem allocations are cache-aligned, reducing sizeof(struct
epitem) from 136 bytes to 128 bytes will allow it to squeeze under a
cache line boundary on x86_64.

>From /sys/kernel/slab/eventpoll_epi, I see the following changes on my
x86_64 Core2 Duo (which has 64-byte cache alignment):

	object_size  :  192 => 128
	objs_per_slab:   21 =>  32

I have no access to other 64-bit machines, so I am limiting this to
x86_64-only with EPOLL_PACKED instead of __attribute__((packed))

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/eventpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index cfc4b16..06f3d0e 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -107,7 +107,7 @@
 struct epoll_filefd {
 	struct file *file;
 	int fd;
-};
+} EPOLL_PACKED;
 
 /*
  * Structure used to track possible nested calls, for too deep recursions
-- 
Eric Wong

