Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3A2MOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:14:07 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:59884 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3A2MOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:14:06 -0500
MIME-Version: 1.0
In-Reply-To: <1359365068-10147-7-git-send-email-kirill.shutemov@linux.intel.com>
References: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1359365068-10147-7-git-send-email-kirill.shutemov@linux.intel.com>
Date: Tue, 29 Jan 2013 20:14:04 +0800
Message-ID: <CAJd=RBA2Kr-sKEFdJNQAjgVzesn6Q2Ockci58DsNQ0fa_7qkQw@mail.gmail.com>
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
> +       page_cache_get(page);
> +       spin_lock_irq(&mapping->tree_lock);
> +       page->mapping = mapping;
> +       if (PageTransHuge(page)) {
> +               int i;
> +               for (i = 0; i < HPAGE_CACHE_NR; i++) {
> +                       page_cache_get(page + i);

Page count is raised twice for head page, why?

> +                       page[i].index = offset + i;
> +                       error = radix_tree_insert(&mapping->page_tree,
> +                                       offset + i, page + i);
> +                       if (error) {
> +                               page_cache_release(page + i);
> +                               break;
> +                       }
