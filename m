Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3A2MLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:11:05 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36124 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3A2MLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:11:03 -0500
MIME-Version: 1.0
In-Reply-To: <1359365068-10147-7-git-send-email-kirill.shutemov@linux.intel.com>
References: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1359365068-10147-7-git-send-email-kirill.shutemov@linux.intel.com>
Date: Tue, 29 Jan 2013 20:11:01 +0800
Message-ID: <CAJd=RBAAdYef6+sHnD9kS=7mygSrgAD3cDW1wk8YsT2OK0sfZQ@mail.gmail.com>
Subject: Re: [PATCH, RFC 06/16] thp, mm: rewrite add_to_page_cache_locked() to
 support huge pages
From: Hillf Danton <dhillf@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 5:24 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> @@ -443,6 +443,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
>                 pgoff_t offset, gfp_t gfp_mask)
>  {
>         int error;
> +       int nr = 1;
>
>         VM_BUG_ON(!PageLocked(page));
>         VM_BUG_ON(PageSwapBacked(page));
> @@ -450,31 +451,61 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
>         error = mem_cgroup_cache_charge(page, current->mm,
>                                         gfp_mask & GFP_RECLAIM_MASK);
>         if (error)
> -               goto out;
> +               return error;

Due to PageCompound check, thp could not be charged effectively.
Any change added for charging it?
