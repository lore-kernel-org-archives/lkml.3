Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbaDVTyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:54:31 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:58450 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbaDVTyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:54:25 -0400
Date: Tue, 22 Apr 2014 15:54:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 1/4] idr: proper invalid argument handling
Message-ID: <20140422195421.GA2314@mtj.dyndns.org>
References: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
 <1398161781-12105-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398161781-12105-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 22, 2014 at 06:16:18PM +0800, Lai Jiangshan wrote:
> @@ -457,8 +457,10 @@ int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask)
>  	/* sanity checks */
>  	if (WARN_ON_ONCE(start < 0))
>  		return -EINVAL;
> -	if (unlikely(max < start))
> +	if (unlikely(end > 0 && start == end))
>  		return -ENOSPC;
> +	if (WARN_ON_ONCE(max < start))
> +		return -EINVAL;

Why is this change necessary?  Now the code is inconsistent with the
comment?  This change looks very gratuituous.

> @@ -1078,14 +1077,17 @@ int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
>  	unsigned int max;
>  	unsigned long flags;
>  
> -	BUG_ON((int)start < 0);
> -	BUG_ON((int)end < 0);
> +	if (WARN_ON_ONCE((int)start < 0))
> +		return -EINVAL;
>  
> -	if (end == 0)
> -		max = 0x80000000;
> +	if ((int)end <= 0)
> +		max = INT_MAX;

Again, why are you changing this?  What problem are you trying to fix?

>  	else {
> -		BUG_ON(end < start);
>  		max = end - 1;
> +		if (unlikely(start == end))
> +			return -ENOSPC;
> +		if (WARN_ON_ONCE(max < start))
> +			return -EINVAL;

Please juts convert BUG_ON()s to WARNs.  If you want to change how the
paramters behave.  Do those in a separate patch with proper
rationales.

Thanks.

-- 
tejun
