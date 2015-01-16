Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbbAPNSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:18:44 -0500
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:47451 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbbAPNSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:18:43 -0500
From: =?koi8-r?B?68/O09TBztTJziDozMXCzsnLz9c=?= 
	<khlebnikov@yandex-team.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "koct9i@gmail.com" <koct9i@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20150115171551.a2e6acb5.akpm@linux-foundation.org>
References: <20150115155731.31307.4414.stgit@buzz> <20150115171551.a2e6acb5.akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] page_writeback: cleanup mess around cancel_dirty_page()
MIME-Version: 1.0
Message-Id: <219291421414310@webcorp01h.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 16 Jan 2015 16:18:30 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16.01.2015, 04:16, "Andrew Morton" <akpm@linux-foundation.org>:
> On Thu, 15 Jan 2015 18:57:31 +0300 Konstantin Khebnikov <khlebnikov@yandex-team.ru> wrote:
>> šThis patch replaces cancel_dirty_page() with helper account_page_cleared()
>> šwhich only updates counters. It's called from delete_from_page_cache()
>> šand from try_to_free_buffers() (hack for ext3). Page is locked in both cases.
>>
>> šHugetlbfs has no dirty pages accounting, ClearPageDirty() is enough here.
>>
>> šcancel_dirty_page() in nfs_wb_page_cancel() is redundant. This is helper
>> šfor nfs_invalidate_page() and it's called only in case complete invalidation.
>>
>> šOpen-coded kludge at the end of __delete_from_page_cache() is redundant too.
>>
>> šThis mess was started in v2.6.20, after commit 3e67c09 ("truncate: clear page
>> šdirtiness before running try_to_free_buffers()") reverted back in v2.6.25
>> šby commit a2b3456 ("Fix dirty page accounting leak with ext3 data=journal").
>> šCustom fixes were introduced between them. NFS in in v2.6.23 in commit
>> š1b3b4a1 ("NFS: Fix a write request leak in nfs_invalidate_page()").
>> šKludge __delete_from_page_cache() in v2.6.24, commit 3a692790 ("Do dirty
>> špage accounting when removing a page from the page cache").
>>
>> šIt seems safe to leave dirty flag set on truncated page, free_pages_check()
>> šwill clear it before returning page into buddy allocator.
>
> account_page_cleared() is not a good name - "clearing a page" means
> filling it with zeroes. šaccount_page_cleaned(), perhaps?

Ok. account_page_cleaned is better.

>
> I don't think your email cc'ed all the correct people? šlustre, nfs,
> ext3?

oops

>> š...
>>
>> š--- a/fs/buffer.c
>> š+++ b/fs/buffer.c
>> š@@ -3243,8 +3243,8 @@ int try_to_free_buffers(struct page *page)
>> ššššššššššš* to synchronise against __set_page_dirty_buffers and prevent the
>> ššššššššššš* dirty bit from being lost.
>> ššššššššššš*/
>> š- if (ret)
>> š- cancel_dirty_page(page, PAGE_CACHE_SIZE);
>> š+ if (ret && TestClearPageDirty(page))
>> š+ account_page_cleared(page, mapping);
>
> OK.
>> ššššššššššspin_unlock(&mapping->private_lock);
>> ššout:
>> ššššššššššif (buffers_to_free) {
>>
>> š...
>>
>> š--- a/fs/nfs/write.c
>> š+++ b/fs/nfs/write.c
>> š@@ -1811,11 +1811,6 @@ int nfs_wb_page_cancel(struct inode *inode, struct page *page)
>> ššššššššššššššššššš* request from the inode / page_private pointer and
>> ššššššššššššššššššš* release it */
>> ššššššššššššššššššnfs_inode_remove_request(req);
>> š- /*
>> š- * In case nfs_inode_remove_request has marked the
>> š- * page as being dirty
>> š- */
>> š- cancel_dirty_page(page, PAGE_CACHE_SIZE);
>
> hm, if you say so..

That is main reason of this patch.
I dont like these obsoleted pieces of duct tape here and there.

>> ššššššššššššššššššnfs_unlock_and_release_request(req);
>> šššššššššš}
>>
>> š...
>>
>> š--- a/mm/filemap.c
>> š+++ b/mm/filemap.c
>> š@@ -201,18 +201,6 @@ void __delete_from_page_cache(struct page *page, void *shadow)
>> ššššššššššif (PageSwapBacked(page))
>> šššššššššššššššššš__dec_zone_page_state(page, NR_SHMEM);
>> ššššššššššBUG_ON(page_mapped(page));
>> š-
>> š- /*
>> š- * Some filesystems seem to re-dirty the page even after
>> š- * the VM has canceled the dirty bit (eg ext3 journaling).
>> š- *
>> š- * Fix it up by doing a final dirty accounting check after
>> š- * having removed the page entirely.
>> š- */
>> š- if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
>> š- dec_zone_page_state(page, NR_FILE_DIRTY);
>> š- dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
>> š- }
>> šš}
>>
>> šš/**
>> š@@ -230,6 +218,9 @@ void delete_from_page_cache(struct page *page)
>>
>> ššššššššššBUG_ON(!PageLocked(page));
>>
>> š+ if (PageDirty(page))
>> š+ account_page_cleared(page, mapping);
>> š+
>
> OK, but we lost the important comment - transplant that?
>
> It's strange that we left the dirty bit set after accounting for its
> clearing. šHow does this work? šPresumably the offending fs dirtied the
> page without accounting for it? šI have a bad feeling I wrote that code :(

account_page_dirtyed() must be always called after dirtying non-truncated pages.
Here page is truncating from mapping, dirty accounting never will see it again.

This is the only place where dirty page might be truncated. All other places:
replace_page_cache_page, invalidate_complete_page2, __remove_mapping
(in memory reclaimer) forbid removing dirty pages.

As I see PageDirty means nothing for truncated pages, it's never be written anywhere.
We could clear dirty bit here, but probably it might appear again: set_page_dirty()
for some reason has branch for pages without page->mapping.

>> ššššššššššfreepage = mapping->a_ops->freepage;
>> ššššššššššspin_lock_irq(&mapping->tree_lock);
>> šššššššššš__delete_from_page_cache(page, NULL);
>> šdiff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> šindex 4da3cd5..f371522 100644
>> š--- a/mm/page-writeback.c
>> š+++ b/mm/page-writeback.c
>> š@@ -2106,6 +2106,25 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
>> ššEXPORT_SYMBOL(account_page_dirtied);
>>
>> šš/*
>> š+ * Helper function for deaccounting dirty page without doing writeback.
>> š+ * Doing this should *normally* only ever be done when a page
>> š+ * is truncated, and is not actually mapped anywhere at all. However,
>> š+ * fs/buffer.c does this when it notices that somebody has cleaned
>> š+ * out all the buffers on a page without actually doing it through
>> š+ * the VM. Can you say "ext3 is horribly ugly"? Tought you could.
>
> "Thought".

Ah, ok. That is copy-paste from cancel_dirty_page().

>> š+ */
>> š+void account_page_cleared(struct page *page, struct address_space *mapping)
>> š+{
>> š+ if (mapping_cap_account_dirty(mapping)) {
>> š+ dec_zone_page_state(page, NR_FILE_DIRTY);
>> š+ dec_bdi_stat(mapping->backing_dev_info,
>> š+ BDI_RECLAIMABLE);
>> š+ task_io_account_cancelled_write(PAGE_CACHE_SIZE);
>> š+ }
>> š+}
>> š+EXPORT_SYMBOL(account_page_cleared);
>>
>> š...
