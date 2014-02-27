Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaB0VD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:03:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaB0VDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:03:24 -0500
Date: Thu, 27 Feb 2014 13:03:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/pagewalk.c: fix end address calculation in
 walk_page_range()
Message-Id: <20140227130323.0d4f0a27b4327100805bab02@linux-foundation.org>
In-Reply-To: <1393475977-3381-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1393475977-3381-2-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 23:39:35 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> When we try to walk over inside a vma, walk_page_range() tries to walk
> until vma->vm_end even if a given end is before that point.
> So this patch takes the smaller one as an end address.
> 
> ...
>
> --- next-20140220.orig/mm/pagewalk.c
> +++ next-20140220/mm/pagewalk.c
> @@ -321,8 +321,9 @@ int walk_page_range(unsigned long start, unsigned long end,
>  			next = vma->vm_start;
>  		} else { /* inside the found vma */
>  			walk->vma = vma;
> -			next = vma->vm_end;
> -			err = walk_page_test(start, end, walk);
> +			next = min_t(unsigned long, end, vma->vm_end);

min_t is unneeded, isn't it?  Everything here has type unsigned long.

> +			err = walk_page_test(start, next, walk);
>  			if (skip_lower_level_walking(walk))
>  				continue;
>  			if (err)

I'm assuming this is a fix against
pagewalk-update-page-table-walker-core.patch and shall eventually be
folded into that patch.  
