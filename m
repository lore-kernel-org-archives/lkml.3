Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaDSNHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 09:07:33 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63085 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDSNHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 09:07:30 -0400
Date: Sat, 19 Apr 2014 09:07:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 5/9 V2] idr: covert BUG_ON() to WARN_ON_ONCE() if the
 argument is invalid.
Message-ID: <20140419130726.GC3277@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
 <1397907496-5993-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397907496-5993-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 07:38:12PM +0800, Lai Jiangshan wrote:
> @@ -559,7 +559,7 @@ void idr_remove(struct idr *idp, int id)
>  	struct idr_layer *p;
>  	struct idr_layer *to_free;
>  
> -	if (id < 0)
> +	if (WARN_ON_ONCE(id < 0))
>  		return;

ISTR callers which call in with error value, but yeah weeding them out
could be a good idea.  Shouldn't it be idr_remove_warning() though?

> @@ -1030,6 +1030,9 @@ void ida_remove(struct ida *ida, int id)
>  	int n;
>  	struct ida_bitmap *bitmap;
>  
> +	if (WARN_ON_ONCE(id < 0))
> +		return;

Why not jump to err?

> +
>  	if (idr_id > idr_max(ida->idr.layers))
>  		goto err;
>  
> @@ -1096,13 +1099,14 @@ int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
>  	unsigned int max;
>  	unsigned long flags;
>  
> -	BUG_ON((int)start < 0);
> -	BUG_ON((int)end < 0);
> +	if (WARN_ON_ONCE(((int)start < 0) || ((int)end < 0)))
> +		return -EINVAL;
>  
>  	if (end == 0)
>  		max = 0x80000000;
>  	else {
> -		BUG_ON(end < start);
> +		if (WARN_ON_ONCE(end < start))
> +			return -ENOSPC;

-EINVAL

Thanks.

-- 
tejun
