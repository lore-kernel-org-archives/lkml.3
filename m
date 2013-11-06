Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3KFBMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:12:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:30185 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab3KFBMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:12:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="430413207"
Message-ID: <52799891.7070300@linux.intel.com>
Date: Tue, 05 Nov 2013 17:17:05 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Olav Haugan <ohaugan@codeaurora.org>
CC: gregkh@linuxfoundation.org, ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
References: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org>
In-Reply-To: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olav,

On 11/05/2013 04:54 PM, Olav Haugan wrote:
> zsmalloc encodes a handle using the page pfn and an object
> index. On some hardware platforms the pfn could be 0 and this
> causes the encoded handle to be 0 which is interpreted as an
> allocation failure.
>
> To prevent this false error we ensure that the encoded handle
> will not be 0 when allocation succeeds.
>
> Change-Id: Ifff930dcf254915b497aec5cb36f152a5e5365d6
> Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
> ---
>   drivers/staging/zsmalloc/zsmalloc-main.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 523b937..0e32c0f 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -441,7 +441,7 @@ static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
>   	}
>
>   	handle = page_to_pfn(page) << OBJ_INDEX_BITS;
> -	handle |= (obj_idx & OBJ_INDEX_MASK);
> +	handle |= ((obj_idx + 1) & OBJ_INDEX_MASK);

As suggestion you could use a macro instead of hardcoded 1.

I am not familiar with this code, but if it's a valid test to verify if
the resulting address is page aligned, you might want to set this
offset macro to a page aligned value as well.

>
>   	return (void *)handle;
>   }
> @@ -451,7 +451,7 @@ static void obj_handle_to_location(unsigned long handle, struct page **page,
>   				unsigned long *obj_idx)
>   {
>   	*page = pfn_to_page(handle >> OBJ_INDEX_BITS);
> -	*obj_idx = handle & OBJ_INDEX_MASK;
> +	*obj_idx = (handle & OBJ_INDEX_MASK) - 1;

Ditto.

Br, David Cohen
