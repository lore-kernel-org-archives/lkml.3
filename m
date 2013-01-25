Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3AYASG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:18:06 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:36927 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3AYAR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:17:56 -0500
MIME-Version: 1.0
In-Reply-To: <1357590280-31535-5-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<1357590280-31535-5-git-send-email-sjenning@linux.vnet.ibm.com>
Date: Thu, 24 Jan 2013 16:17:55 -0800
Message-ID: <CAPkvG_c48ZfwBRKCXSZrnVo=GgoLpqsRrF=8DEAwfFFVhb=1ZA@mail.gmail.com>
Subject: Re: [PATCHv2 4/9] staging: zsmalloc: make CLASS_DELTA relative to PAGE_SIZE
From: Nitin Gupta <ngupta@vflare.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 12:24 PM, Seth Jennings
<sjenning@linux.vnet.ibm.com> wrote:
> Right now ZS_SIZE_CLASS_DELTA is hardcoded to be 16.  This
> creates 254 classes for systems with 4k pages. However, on
> PPC64 with 64k pages, it creates 4095 classes which is far
> too many.
>
> This patch makes ZS_SIZE_CLASS_DELTA relative to PAGE_SIZE
> so that regardless of the page size, there will be the same
> number of classes.
>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  drivers/staging/zsmalloc/zsmalloc-main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 825e124..3543047 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -141,7 +141,7 @@
>   *  ZS_MIN_ALLOC_SIZE and ZS_SIZE_CLASS_DELTA must be multiple of ZS_ALIGN
>   *  (reason above)
>   */
> -#define ZS_SIZE_CLASS_DELTA    16
> +#define ZS_SIZE_CLASS_DELTA    (PAGE_SIZE >> 8)
>  #define ZS_SIZE_CLASSES                ((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / \
>                                         ZS_SIZE_CLASS_DELTA + 1)
>

Actually, there is no point creating size classes beyond [M/(M+1)] * PAGE_SIZE
where M is the maximum number of system pages in a zspage. All size classes
beyond this size can be collapsed with PAGE_SIZE size class.  This can
significantly reduce number of size classes created but I think changes needed
to do this would be more involved, so perhaps, should be done in another
patch.


Can you please resend part of this series  (patch 1  to patch 4) which deals
just with zsmalloc separately?  I haven't yet looked into zswap itself so would
help with zsmalloc bits are separated out.

Acked-by: Nitin Gupta <ngupta@vflare.org>
