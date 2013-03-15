Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3COBah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:30:37 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58581 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3COBag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:30:36 -0400
MIME-Version: 1.0
In-Reply-To: <1363283435-7666-9-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1363283435-7666-9-git-send-email-kirill.shutemov@linux.intel.com>
Date: Fri, 15 Mar 2013 09:30:35 +0800
Message-ID: <CAJd=RBAH1+YaDvL9=ayx2j6b4jx0CzBZGrAL9LVwPMx4Y=s3Rg@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 08/30] thp, mm: rewrite add_to_page_cache_locked()
 to support huge pages
From: Hillf Danton <dhillf@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> +       page_cache_get(page);
> +       spin_lock_irq(&mapping->tree_lock);
> +       page->mapping = mapping;
> +       page->index = offset;
> +       error = radix_tree_insert(&mapping->page_tree, offset, page);
> +       if (unlikely(error))
> +               goto err;
> +       if (PageTransHuge(page)) {
> +               int i;
> +               for (i = 1; i < HPAGE_CACHE_NR; i++) {
			struct page *tail = page + i; to easy reader

> +                       page_cache_get(page + i);
s/page_cache_get/get_page_foll/ ?

> +                       page[i].index = offset + i;
> +                       error = radix_tree_insert(&mapping->page_tree,
> +                                       offset + i, page + i);
> +                       if (error) {
> +                               page_cache_release(page + i);
> +                               break;
> +                       }
>                 }
> -               radix_tree_preload_end();
> -       } else
> -               mem_cgroup_uncharge_cache_page(page);
> -out:
> +               if (error) {
> +                       error = ENOSPC; /* no space for a huge page */
s/E/-E/

> +                       for (i--; i > 0; i--) {
> +                               radix_tree_delete(&mapping->page_tree,
> +                                               offset + i);
> +                               page_cache_release(page + i);
> +                       }
> +                       radix_tree_delete(&mapping->page_tree, offset);
> +                       goto err;
> +               }
> +       }
