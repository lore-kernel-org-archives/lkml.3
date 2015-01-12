Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbbALXJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:09:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbbALXJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:09:36 -0500
Date: Mon, 12 Jan 2015 15:09:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, willy@linux.intel.com
Subject: Re: [PATCH v12 04/20] mm: Allow page fault handlers to perform the
 COW
Message-Id: <20150112150935.e617603089bc07e68f0e657c@linux-foundation.org>
In-Reply-To: <1414185652-28663-5-git-send-email-matthew.r.wilcox@intel.com>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
	<1414185652-28663-5-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 17:20:36 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:

> Currently COW of an XIP file is done by first bringing in a read-only
> mapping, then retrying the fault and copying the page.  It is much more
> efficient to tell the fault handler that a COW is being attempted (by
> passing in the pre-allocated page in the vm_fault structure), and allow
> the handler to perform the COW operation itself.
> 
> The handler cannot insert the page itself if there is already a read-only
> mapping at that address, so allow the handler to return VM_FAULT_LOCKED
> and set the fault_page to be NULL.  This indicates to the MM code that
> the i_mmap_mutex is held instead of the page lock.

Again, the locking gets a bit subtle.  How can we make this clearer to
readers of the core code.  I had a shot but it's a bit lame - DAX uses
i_mmap_lock for what???

If I know that, I'd know whether to have used i_mmap_lock_read() or
i_mmap_lock_write() :(


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-allow-page-fault-handlers-to-perform-the-cow-fix

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-allow-page-fault-handlers-to-perform-the-cow-fix include/linux/mm.h
diff -puN mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow-fix mm/memory.c
--- a/mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow-fix
+++ a/mm/memory.c
@@ -2961,7 +2961,11 @@ static int do_cow_fault(struct mm_struct
 			unlock_page(fault_page);
 			page_cache_release(fault_page);
 		} else {
-			mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+			/*
+			 * DAX doesn't have a page to lock, so it uses
+			 * i_mmap_lock()
+			 */
+			i_mmap_unlock_read(&vma->vm_file->f_mapping);
 		}
 		goto uncharge_out;
 	}
@@ -2973,7 +2977,11 @@ static int do_cow_fault(struct mm_struct
 		unlock_page(fault_page);
 		page_cache_release(fault_page);
 	} else {
-		mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+			/*
+			 * DAX doesn't have a page to lock, so it uses
+			 * i_mmap_lock()
+			 */
+			i_mmap_unlock_read(&vma->vm_file->f_mapping);
 	}
 	return ret;
 uncharge_out:
_

