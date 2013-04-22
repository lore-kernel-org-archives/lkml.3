Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab3DVUht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:37:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3DVUhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:37:48 -0400
Date: Mon, 22 Apr 2013 13:37:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] swap: redirty page if page write fails on swap file
Message-Id: <20130422133746.ffbbb70c0394fdbf1096c7ee@linux-foundation.org>
In-Reply-To: <516E918B.3050309@redhat.com>
References: <516E918B.3050309@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013 14:11:55 +0200 Jerome Marchand <jmarchan@redhat.com> wrote:

> 
> Since commit 62c230b, swap_writepage() calls direct_IO on swap files.
> However, in that case page isn't redirtied if I/O fails, and is therefore
> handled afterwards as if it has been successfully written to the swap
> file, leading to memory corruption when the page is eventually swapped
> back in.
> This patch sets the page dirty when direct_IO() fails. It fixes a memory
> corruption that happened while using swap-over-NFS.
> 
> ...
>
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -222,6 +222,8 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>  		if (ret == PAGE_SIZE) {
>  			count_vm_event(PSWPOUT);
>  			ret = 0;
> +		} else {
> +			set_page_dirty(page);
>  		}
>  		return ret;
>  	}

So what happens to the page now?  It remains dirty and the kernel later
tries to write it again?  And if that write also fails, the page is
effectively leaked until process exit?


Aside: Mel, __swap_writepage() is fairly hair-raising.  It unlocks the
page before doing the IO and doesn't set PageWriteback().  Why such an
exception from normal handling?

Also, what is protecting the page from concurrent reclaim or exit()
during the above swap_writepage()?

Seems that the code needs a bunch of fixes or a bunch of comments
explaining why it is safe and why it has to be this way.
