Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946001AbaD3UN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:13:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552AbaD3UNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:13:55 -0400
Date: Wed, 30 Apr 2014 13:13:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, sandeen@redhat.com,
        jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        fengguang.wu@intel.com, mpatlasov@parallels.com,
        Motohiro.Kosaki@us.fujitsu.com
Subject: Re: [PATCH v4] mm,writeback: fix divide by zero in
 pos_ratio_polynom
Message-Id: <20140430131353.fa9f49604ea39425bc93c24a@linux-foundation.org>
In-Reply-To: <20140430160218.442863e0@cuia.bos.redhat.com>
References: <20140429151910.53f740ef@annuminas.surriel.com>
	<5360C9E7.6010701@jp.fujitsu.com>
	<20140430093035.7e7226f2@annuminas.surriel.com>
	<20140430134826.GH4357@dhcp22.suse.cz>
	<20140430104114.4bdc588e@cuia.bos.redhat.com>
	<20140430120001.b4b95061ac7252a976b8a179@linux-foundation.org>
	<53614F3C.8020009@redhat.com>
	<20140430123526.bc6a229c1ea4addad1fb483d@linux-foundation.org>
	<20140430160218.442863e0@cuia.bos.redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 16:02:18 -0400 Rik van Riel <riel@redhat.com> wrote:

> I believe this should do the trick.
> 
> ---8<---
> 
> Subject: mm,writeback: fix divide by zero in pos_ratio_polynom
> 
> It is possible for "limit - setpoint + 1" to equal zero, leading to a
> divide by zero error. Blindly adding 1 to "limit - setpoint" is not
> working, so we need to actually test the divisor before calling div64.
> 

Changelog is a bit stale.

> ---
>  mm/page-writeback.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index ef41349..37f56bb 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -593,15 +593,20 @@ unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
>   * (5) the closer to setpoint, the smaller |df/dx| (and the reverse)
>   *     => fast response on large errors; small oscillation near setpoint
>   */
> -static inline long long pos_ratio_polynom(unsigned long setpoint,
> +static long long pos_ratio_polynom(unsigned long setpoint,
>  					  unsigned long dirty,
>  					  unsigned long limit)
>  {
> +	unsigned long divisor;
>  	long long pos_ratio;
>  	long x;
>  
> -	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
> -		    limit - setpoint + 1);
> +	divisor = limit - setpoint;
> +	if (!divisor)
> +		divisor = 1;	/* Avoid div-by-zero */

This was a consequence of 64->32 truncation and it can't happen any
more, can it?


