Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbaJ2Oim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:38:42 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:59456 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbaJ2Oil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:38:41 -0400
Date: Wed, 29 Oct 2014 10:38:38 -0400
From: Tejun Heo <tj@kernel.org>
To: pang.xunlei@zte.com.cn
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] idr: optimize ida_init() to avoid an extra memset
Message-ID: <20141029143838.GC25226@htj.dyndns.org>
References: <OF73B80F6F.959BED11-ON48257D80.00327936-48257D80.00341CEF@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF73B80F6F.959BED11-ON48257D80.00327936-48257D80.00341CEF@zte.com.cn>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 05:26:34PM +0800, pang.xunlei@zte.com.cn wrote:
> The memset in ida_init() already handles idr, so there's some
> redundancy in the following idr_init().
> 
> This patch removes the memset, and clears ida->free_bitmap instead.
> 
> Signed-off-by: pang.xunlei <pang.xunlei@zte.com.cn>
> ---
>  lib/idr.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/lib/idr.c b/lib/idr.c
> index e654aeb..bbe5779 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -1141,8 +1141,7 @@ EXPORT_SYMBOL(ida_simple_remove);
>   */
>  void ida_init(struct ida *ida)
>  {
> -   memset(ida, 0, sizeof(struct ida));
>     idr_init(&ida->idr);
> -
> +   ida->free_bitmap = NULL;

I don't know.  Does this matter?  If this *really* matters, I'd much
rather have memset(&ida->FIRST_FIELD, 0, sizeof(struct ida) - offset
of FIRST_FIELD) to ensure that all fields get reset or implement an
internal function like __idr_init_without_zeroing(); however, given
the size of an idr and the low frequency of the operation, I'd prefer
to just leave it as-is.

Thanks.

-- 
tejun
