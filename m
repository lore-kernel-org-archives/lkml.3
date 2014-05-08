Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaEHKRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:17:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33181 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaEHKRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:17:53 -0400
Message-ID: <536B59A1.3000602@jp.fujitsu.com>
Date: Thu, 8 May 2014 19:17:05 +0900
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <sandeen@redhat.com>, <jweiner@redhat.com>,
        <kosaki.motohiro@jp.fujitsu.com>, <fengguang.wu@intel.com>,
        <mpatlasov@parallels.com>, <Motohiro.Kosaki@us.fujitsu.com>
Subject: Re: [PATCH v5] mm,writeback: fix divide by zero in pos_ratio_polynom
References: <20140429151910.53f740ef@annuminas.surriel.com>	<5360C9E7.6010701@jp.fujitsu.com>	<20140430093035.7e7226f2@annuminas.surriel.com>	<20140430134826.GH4357@dhcp22.suse.cz>	<20140430104114.4bdc588e@cuia.bos.redhat.com>	<20140430120001.b4b95061ac7252a976b8a179@linux-foundation.org>	<53614F3C.8020009@redhat.com>	<20140430123526.bc6a229c1ea4addad1fb483d@linux-foundation.org>	<20140430160218.442863e0@cuia.bos.redhat.com>	<20140430131353.fa9f49604ea39425bc93c24a@linux-foundation.org> <20140430164255.7a753a8e@cuia.bos.redhat.com>
In-Reply-To: <20140430164255.7a753a8e@cuia.bos.redhat.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.101.151]
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik, 

On Wed, 30 Apr 2014 16:42:55 -0400 Rik van Riel wrote:
> On Wed, 30 Apr 2014 13:13:53 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> This was a consequence of 64->32 truncation and it can't happen any
>> more, can it?
> 
> Andrew, this is cleaner indeed :)
> 
> Masayoshi-san, does the bug still happen with this version, or does
> this fix the problem?

I applied the v5 patch and the divide error did not happen when I ran the test.
Thank you for fixing it!

Thanks,
Masayoshi Mizuma

> 
> ---8<---
> 
> Subject: mm,writeback: fix divide by zero in pos_ratio_polynom
> 
> It is possible for "limit - setpoint + 1" to equal zero, after
> getting truncated to a 32 bit variable, and resulting in a divide
> by zero error.
> 
> Using the fully 64 bit divide functions avoids this problem.
> 
> Also uninline pos_ratio_polynom, at Andrew's request.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>   mm/page-writeback.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index ef41349..a4317da 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -593,14 +593,14 @@ unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
>    * (5) the closer to setpoint, the smaller |df/dx| (and the reverse)
>    *     => fast response on large errors; small oscillation near setpoint
>    */
> -static inline long long pos_ratio_polynom(unsigned long setpoint,
> +static long long pos_ratio_polynom(unsigned long setpoint,
>   					  unsigned long dirty,
>   					  unsigned long limit)
>   {
>   	long long pos_ratio;
>   	long x;
>   
> -	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
> +	x = div64_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
>   		    limit - setpoint + 1);
>   	pos_ratio = x;
>   	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
> @@ -842,7 +842,7 @@ static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
>   	x_intercept = bdi_setpoint + span;
>   
>   	if (bdi_dirty < x_intercept - span / 4) {
> -		pos_ratio = div_u64(pos_ratio * (x_intercept - bdi_dirty),
> +		pos_ratio = div64_u64(pos_ratio * (x_intercept - bdi_dirty),
>   				    x_intercept - bdi_setpoint + 1);
>   	} else
>   		pos_ratio /= 4;
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
