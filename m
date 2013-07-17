Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3GQVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:09:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab3GQVJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:09:56 -0400
Date: Wed, 17 Jul 2013 14:09:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] thp, mm: locking tail page is a bug
Message-Id: <20130717140953.7560e88e607f8f5df1b1fdd8@linux-foundation.org>
In-Reply-To: <1373885274-25249-6-git-send-email-kirill.shutemov@linux.intel.com>
References: <1373885274-25249-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1373885274-25249-6-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013 13:47:51 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Locking head page means locking entire compound page.
> If we try to lock tail page, something went wrong.
> 
> ..
>
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -639,6 +639,7 @@ void __lock_page(struct page *page)
>  {
>  	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
>  
> +	VM_BUG_ON(PageTail(page));
>  	__wait_on_bit_lock(page_waitqueue(page), &wait, sleep_on_page,
>  							TASK_UNINTERRUPTIBLE);
>  }
> @@ -648,6 +649,7 @@ int __lock_page_killable(struct page *page)
>  {
>  	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
>  
> +	VM_BUG_ON(PageTail(page));
>  	return __wait_on_bit_lock(page_waitqueue(page), &wait,
>  					sleep_on_page_killable, TASK_KILLABLE);
>  }

lock_page() is a pretty commonly called function, and I assume quite a
lot of people run with CONFIG_DEBUG_VM=y.

Is the overhead added by this patch really worthwhile?

I'm thinking I might leave it in -mm indefinitely but not send it
upstream.

