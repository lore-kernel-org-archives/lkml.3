Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbaH2ViP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 17:38:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaH2ViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 17:38:12 -0400
Date: Fri, 29 Aug 2014 14:38:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-mm@kvack.org, Rafael Aquini <aquini@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] mm/balloon_compaction: general cleanup
Message-Id: <20140829143811.90bfab2a46ccade0f586b369@linux-foundation.org>
In-Reply-To: <20140820150509.4194.24336.stgit@buzz>
References: <20140820150435.4194.28003.stgit@buzz>
	<20140820150509.4194.24336.stgit@buzz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014 19:05:09 +0400 Konstantin Khlebnikov <k.khlebnikov@samsung.com> wrote:

> * move special branch for balloon migraion into migrate_pages
> * remove special mapping for balloon and its flag AS_BALLOON_MAP
> * embed struct balloon_dev_info into struct virtio_balloon
> * cleanup balloon_page_dequeue, kill balloon_page_free

Another testing failure.  Guys, allnoconfig is really fast.

> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon_compaction.h
> @@ -54,58 +54,27 @@
>   * balloon driver as a page book-keeper for its registered balloon devices.
>   */
>  struct balloon_dev_info {
> -	void *balloon_device;		/* balloon device descriptor */
> -	struct address_space *mapping;	/* balloon special page->mapping */
>  	unsigned long isolated_pages;	/* # of isolated pages for migration */
>  	spinlock_t pages_lock;		/* Protection to pages list */
>  	struct list_head pages;		/* Pages enqueued & handled to Host */
> +	int (* migrate_page)(struct balloon_dev_info *, struct page *newpage,
> +			struct page *page, enum migrate_mode mode);
>  };

If CONFIG_MIGRATION=n this gets turned into "NULL" and chaos ensues.  I
think I'll just nuke that #define:

--- a/include/linux/migrate.h~include-linux-migrateh-remove-migratepage-define
+++ a/include/linux/migrate.h
@@ -82,9 +82,6 @@ static inline int migrate_huge_page_move
 	return -ENOSYS;
 }
 
-/* Possible settings for the migrate_page() method in address_operations */
-#define migrate_page NULL
-
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
--- a/mm/swap_state.c~include-linux-migrateh-remove-migratepage-define
+++ a/mm/swap_state.c
@@ -28,7 +28,9 @@
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
 	.set_page_dirty	= swap_set_page_dirty,
+#ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
+#endif
 };
 
 static struct backing_dev_info swap_backing_dev_info = {
--- a/mm/shmem.c~include-linux-migrateh-remove-migratepage-define
+++ a/mm/shmem.c
@@ -3075,7 +3075,9 @@ static const struct address_space_operat
 	.write_begin	= shmem_write_begin,
 	.write_end	= shmem_write_end,
 #endif
+#ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
+#endif
 	.error_remove_page = generic_error_remove_page,
 };
 

Our mixture of "migratepage" and "migrate_page" is maddening.

