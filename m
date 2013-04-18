Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935712Ab3DRANe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 20:13:34 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56313 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934827Ab3DRANd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 20:13:33 -0400
Message-ID: <516F3AA7.1000908@gmail.com>
Date: Thu, 18 Apr 2013 08:13:27 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] swap: redirty page if page write fails on swap file
References: <516E918B.3050309@redhat.com>
In-Reply-To: <516E918B.3050309@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jerome,
On 04/17/2013 08:11 PM, Jerome Marchand wrote:
> Since commit 62c230b, swap_writepage() calls direct_IO on swap files.
> However, in that case page isn't redirtied if I/O fails, and is therefore
> handled afterwards as if it has been successfully written to the swap
> file, leading to memory corruption when the page is eventually swapped
> back in.
> This patch sets the page dirty when direct_IO() fails. It fixes a memory

If swapfile has related page cache which cached swapfile in memory? It 
is not necessary, correct?

> corruption that happened while using swap-over-NFS.
>
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>   mm/page_io.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 78eee32..04ca00d 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -222,6 +222,8 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>   		if (ret == PAGE_SIZE) {
>   			count_vm_event(PSWPOUT);
>   			ret = 0;
> +		} else {
> +			set_page_dirty(page);
>   		}
>   		return ret;
>   	}
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

