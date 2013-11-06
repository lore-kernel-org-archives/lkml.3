Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab3KFCdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 21:33:46 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62667 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3KFCdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 21:33:45 -0500
Date: Tue, 5 Nov 2013 17:56:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Olav Haugan <ohaugan@codeaurora.org>
Cc: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
Message-ID: <20131106015645.GA28769@kroah.com>
References: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 04:54:12PM -0800, Olav Haugan wrote:
> zsmalloc encodes a handle using the page pfn and an object
> index. On some hardware platforms the pfn could be 0 and this
> causes the encoded handle to be 0 which is interpreted as an
> allocation failure.

What platforms specifically have this issue?

> 
> To prevent this false error we ensure that the encoded handle
> will not be 0 when allocation succeeds.
> 
> Change-Id: Ifff930dcf254915b497aec5cb36f152a5e5365d6

What is this?  What can anyone do with it?

> Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
> ---
>  drivers/staging/zsmalloc/zsmalloc-main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 523b937..0e32c0f 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -441,7 +441,7 @@ static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
>  	}
>  
>  	handle = page_to_pfn(page) << OBJ_INDEX_BITS;
> -	handle |= (obj_idx & OBJ_INDEX_MASK);
> +	handle |= ((obj_idx + 1) & OBJ_INDEX_MASK);
>  
>  	return (void *)handle;
>  }
> @@ -451,7 +451,7 @@ static void obj_handle_to_location(unsigned long handle, struct page **page,
>  				unsigned long *obj_idx)
>  {
>  	*page = pfn_to_page(handle >> OBJ_INDEX_BITS);
> -	*obj_idx = handle & OBJ_INDEX_MASK;
> +	*obj_idx = (handle & OBJ_INDEX_MASK) - 1;
>  }

I need someone who knows how to test this code to ack it before I can
take it...

And I thought we were deleting zsmalloc anyway, why are you using this
code?  Isn't it no longer needed anymore?

greg k-h
