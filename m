Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaE1XJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:09:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaE1XJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:09:49 -0400
Date: Wed, 28 May 2014 16:09:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: dont call mmu_notifier_invalidate_page during
 munlock
Message-Id: <20140528160948.489fde6e0285885d13f7c656@linux-foundation.org>
In-Reply-To: <20140528075955.20300.22758.stgit@zurg>
References: <20140528075955.20300.22758.stgit@zurg>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 11:59:55 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:

> try_to_munlock() searches other mlocked vmas, it never unmaps pages.
> There is no reason for invalidation because ptes are left unchanged.
> 
> ...
>
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1225,7 +1225,7 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>  
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
> -	if (ret != SWAP_FAIL)
> +	if (ret != SWAP_FAIL && TTU_ACTION(flags) != TTU_MUNLOCK)
>  		mmu_notifier_invalidate_page(mm, address);
>  out:
>  	return ret;

The patch itself looks reasonable but there is no such thing as
try_to_munlock().  I rewrote the changelog thusly:

: In its munmap mode, try_to_unmap_one() searches other mlocked vmas, it
: never unmaps pages.  There is no reason for invalidation because ptes are
: left unchanged.

Also, the name try_to_unmap_one() is now pretty inaccurate/incomplete. 
Perhaps if someone is feeling enthusiastic they might think up a better
name for the various try_to_unmap functions and see if we can
appropriately document try_to_unmap_one().
