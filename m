Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251Ab3CUQqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:46:21 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36860 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934222Ab3CUQgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:15 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org
Cc: Kent Overstreet <koverstreet@google.com>, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 08/33] aio: move private stuff out of aio.h
Date: Thu, 21 Mar 2013 09:35:29 -0700
Message-Id: <1363883754-27966-9-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/usb/gadget/inode.c |  1 +
 fs/aio.c                   | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/aio.h        | 61 ----------------------------------------------
 3 files changed, 62 insertions(+), 61 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index a1aad43..525cee4 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/mmu_context.h>
+#include <linux/aio.h>
 
 #include <linux/device.h>
 #include <linux/moduleparam.h>
diff --git a/fs/aio.c b/fs/aio.c
index d291228..b3b61d1 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -45,6 +45,67 @@
 #define dprintk(x...)	do { ; } while (0)
 #endif
 
+#define AIO_RING_MAGIC			0xa10a10a1
+#define AIO_RING_COMPAT_FEATURES	1
+#define AIO_RING_INCOMPAT_FEATURES	0
+struct aio_ring {
+	unsigned	id;	/* kernel internal index number */
+	unsigned	nr;	/* number of io_events */
+	unsigned	head;
+	unsigned	tail;
+
+	unsigned	magic;
+	unsigned	compat_features;
+	unsigned	incompat_features;
+	unsigned	header_length;	/* size of aio_ring */
+
+
+	struct io_event		io_events[0];
+}; /* 128 bytes + ring size */
+
+#define AIO_RING_PAGES	8
+struct aio_ring_info {
+	unsigned long		mmap_base;
+	unsigned long		mmap_size;
+
+	struct page		**ring_pages;
+	spinlock_t		ring_lock;
+	long			nr_pages;
+
+	unsigned		nr, tail;
+
+	struct page		*internal_pages[AIO_RING_PAGES];
+};
+
+static inline unsigned aio_ring_avail(struct aio_ring_info *info,
+					struct aio_ring *ring)
+{
+	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
+}
+
+struct kioctx {
+	atomic_t		users;
+	int			dead;
+
+	/* This needs improving */
+	unsigned long		user_id;
+	struct hlist_node	list;
+
+	wait_queue_head_t	wait;
+
+	spinlock_t		ctx_lock;
+
+	int			reqs_active;
+	struct list_head	active_reqs;	/* used for cancellation */
+
+	/* sys_io_setup currently limits this to an unsigned int */
+	unsigned		max_reqs;
+
+	struct aio_ring_info	ring_info;
+
+	struct rcu_head		rcu_head;
+};
+
 /*------ sysctl variables----*/
 static DEFINE_SPINLOCK(aio_nr_lock);
 unsigned long aio_nr;		/* current system wide number of aio requests */
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 615d55a..7b1eb23 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -103,67 +103,6 @@ static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 		};
 }
 
-#define AIO_RING_MAGIC			0xa10a10a1
-#define AIO_RING_COMPAT_FEATURES	1
-#define AIO_RING_INCOMPAT_FEATURES	0
-struct aio_ring {
-	unsigned	id;	/* kernel internal index number */
-	unsigned	nr;	/* number of io_events */
-	unsigned	head;
-	unsigned	tail;
-
-	unsigned	magic;
-	unsigned	compat_features;
-	unsigned	incompat_features;
-	unsigned	header_length;	/* size of aio_ring */
-
-
-	struct io_event		io_events[0];
-}; /* 128 bytes + ring size */
-
-#define AIO_RING_PAGES	8
-struct aio_ring_info {
-	unsigned long		mmap_base;
-	unsigned long		mmap_size;
-
-	struct page		**ring_pages;
-	spinlock_t		ring_lock;
-	long			nr_pages;
-
-	unsigned		nr, tail;
-
-	struct page		*internal_pages[AIO_RING_PAGES];
-};
-
-static inline unsigned aio_ring_avail(struct aio_ring_info *info,
-					struct aio_ring *ring)
-{
-	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
-}
-
-struct kioctx {
-	atomic_t		users;
-	int			dead;
-
-	/* This needs improving */
-	unsigned long		user_id;
-	struct hlist_node	list;
-
-	wait_queue_head_t	wait;
-
-	spinlock_t		ctx_lock;
-
-	int			reqs_active;
-	struct list_head	active_reqs;	/* used for cancellation */
-
-	/* sys_io_setup currently limits this to an unsigned int */
-	unsigned		max_reqs;
-
-	struct aio_ring_info	ring_info;
-
-	struct rcu_head		rcu_head;
-};
-
 /* prototypes */
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
-- 
1.8.1.3

