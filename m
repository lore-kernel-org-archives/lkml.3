Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbaD3TAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:00:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaD3TAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:00:03 -0400
Date: Wed, 30 Apr 2014 12:00:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, sandeen@redhat.com,
        jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        fengguang.wu@intel.com, mpatlasov@parallels.com,
        Motohiro.Kosaki@us.fujitsu.com
Subject: Re: [PATCH v3] mm,writeback: fix divide by zero in
 pos_ratio_polynom
Message-Id: <20140430120001.b4b95061ac7252a976b8a179@linux-foundation.org>
In-Reply-To: <20140430104114.4bdc588e@cuia.bos.redhat.com>
References: <20140429151910.53f740ef@annuminas.surriel.com>
	<5360C9E7.6010701@jp.fujitsu.com>
	<20140430093035.7e7226f2@annuminas.surriel.com>
	<20140430134826.GH4357@dhcp22.suse.cz>
	<20140430104114.4bdc588e@cuia.bos.redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 10:41:14 -0400 Rik van Riel <riel@redhat.com> wrote:

> It is possible for "limit - setpoint + 1" to equal zero, leading to a
> divide by zero error. Blindly adding 1 to "limit - setpoint" is not
> working, so we need to actually test the divisor before calling div64.
> 
> ...
>
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -598,10 +598,15 @@ static inline long long pos_ratio_polynom(unsigned long setpoint,
>  					  unsigned long limit)
>  {
>  	long long pos_ratio;
> +	long divisor;
>  	long x;
>  
> +	divisor = limit - setpoint;
> +	if (!(s32)divisor)
> +		divisor = 1;	/* Avoid div-by-zero */
> +
>  	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
> -		    limit - setpoint + 1);
> +		    (s32)divisor);

Doesn't this just paper over the bug one time in four billion?  The
other 3999999999 times, pos_ratio_polynom() returns an incorect result?

If it is indeed the case that pos_ratio_polynom() callers are
legitimately passing a setpoint which is more than 2^32 less than limit
then it would be better to handle that input correctly.

Writing a new suite of div functions sounds overkillish.  At some loss
of precision could we do something like

	if (divisor > 2^32) {
		divisor >>= log2(divisor) - 32;
		dividend >>= log2(divisor) - 32;
	}
	x = div(dividend, divisor);

?

And let's uninline the sorry thing while we're in there ;)
