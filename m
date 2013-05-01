Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3EAHEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 03:04:52 -0400
Received: from mail-gg0-f169.google.com ([209.85.161.169]:34613 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3EAHEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 03:04:44 -0400
Message-ID: <5180BCFB.6090707@gmail.com>
Date: Wed, 01 May 2013 14:58:03 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: swap: Mark swap pages writeback before queueing for
 direct IO
References: <516E918B.3050309@redhat.com> <20130422133746.ffbbb70c0394fdbf1096c7ee@linux-foundation.org> <20130424185744.GB2144@suse.de>
In-Reply-To: <20130424185744.GB2144@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,
On 04/25/2013 02:57 AM, Mel Gorman wrote:
> As pointed out by Andrew Morton, the swap-over-NFS writeback is not setting
> PageWriteback before it is queued for direct IO. While swap pages do not

Before commit commit 62c230bc1 (mm: add support for a filesystem to 
activate swap files and use direct_IO for writing swap pages), swap 
pages will write to page cache firstly and then writeback?

> participate in BDI or process dirty accounting and the IO is synchronous,
> the writeback bit is still required and not setting it in this case was
> an oversight.  swapoff depends on the page writeback to synchronoise all
> pending writes on a swap page before it is reused. Swapcache freeing and
> reuse depend on checking the PageWriteback under lock to ensure the page
> is safe to reuse.
>
> Direct IO handlers and the direct IO handler for NFS do not deal with
> PageWriteback as they are synchronous writes. In the case of NFS, it
> schedules pages (or a page in the case of swap) for IO and then waits
> synchronously for IO to complete in nfs_direct_write(). It is recognised
> that this is a slowdown from normal swap handling which is asynchronous
> and uses a completion handler. Shoving PageWriteback handling down into
> direct IO handlers looks like a bad fit to handle the swap case although
> it may have to be dealt with some day if swap is converted to use direct
> IO in general and bmap is finally done away with. At that point it will
> be necessary to refit asynchronous direct IO with completion handlers onto
> the swap subsystem.
>
> As swapcache currently depends on PageWriteback to protect against races,
> this patch sets PageWriteback under the page lock before queueing it for
> direct IO. It is cleared when the direct IO handler returns. IO errors
> are treated similarly to the direct-to-bio case except PageError is not
> set as in the case of swap-over-NFS, it is likely to be a transient error.
>
> It was asked what prevents such a page being reclaimed in parallel.
> With this patch applied, such a page will now be skipped (most of the time)
> or blocked until the writeback completes.  Reclaim checks PageWriteback
> under the page lock before calling try_to_free_swap and the page lock
> should prevent the page being requeued for IO before it is freed.
>
> This and Jerome's related patch should considered for -stable as far
> back as 3.6 when swap-over-NFS was introduced.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>   mm/page_io.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 04ca00d..ec04247 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -214,6 +214,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>   		kiocb.ki_left = PAGE_SIZE;
>   		kiocb.ki_nbytes = PAGE_SIZE;
>   
> +		set_page_writeback(page);
>   		unlock_page(page);
>   		ret = mapping->a_ops->direct_IO(KERNEL_WRITE,
>   						&kiocb, &iov,
> @@ -223,8 +224,24 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>   			count_vm_event(PSWPOUT);
>   			ret = 0;
>   		} else {
> +			/*
> +			 * In the case of swap-over-nfs, this can be a
> +			 * temporary failure if the system has limited
> +			 * memory for allocating transmit buffers.
> +			 * Mark the page dirty and avoid
> +			 * rotate_reclaimable_page but rate-limit the
> +			 * messages but do not flag PageError like
> +			 * the normal direct-to-bio case as it could
> +			 * be temporary.
> +			 */
>   			set_page_dirty(page);
> +			ClearPageReclaim(page);
> +			if (printk_ratelimit()) {
> +				pr_err("Write-error on dio swapfile (%Lu)\n",
> +					(unsigned long long)page_file_offset(page));
> +			}
>   		}
> +		end_page_writeback(page);
>   		return ret;
>   	}
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

