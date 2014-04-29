Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbaD2Wjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:39:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbaD2Wjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:39:39 -0400
Date: Tue, 29 Apr 2014 15:39:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, sandeen@redhat.com,
        jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz,
        fengguang.wu@intel.com, mpatlasov@parallels.com
Subject: Re: [PATCH] mm,writeback: fix divide by zero in pos_ratio_polynom
Message-Id: <20140429153936.49a2710c0c2bba4d233032f2@linux-foundation.org>
In-Reply-To: <20140429151910.53f740ef@annuminas.surriel.com>
References: <20140429151910.53f740ef@annuminas.surriel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 15:19:10 -0400 Rik van Riel <riel@redhat.com> wrote:

> It is possible for "limit - setpoint + 1" to equal zero, leading to a
> divide by zero error. Blindly adding 1 to "limit - setpoint" is not
> working, so we need to actually test the divisor before calling div64.
> 
> ...
>
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -597,11 +597,16 @@ static inline long long pos_ratio_polynom(unsigned long setpoint,
>  					  unsigned long dirty,
>  					  unsigned long limit)
>  {
> +	unsigned int divisor;

I'm thinking this would be better as a ulong so I don't have to worry
my pretty head over truncation things?

>  	long long pos_ratio;
>  	long x;
>  
> +	divisor = limit - setpoint;
> +	if (!divisor)
> +		divisor = 1;
> +
>  	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
> -		    limit - setpoint + 1);
> +		    divisor);
>  	pos_ratio = x;
>  	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
>  	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;

--- a/mm/page-writeback.c~mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix
+++ a/mm/page-writeback.c
@@ -597,13 +597,13 @@ static inline long long pos_ratio_polyno
 					  unsigned long dirty,
 					  unsigned long limit)
 {
-	unsigned int divisor;
+	unsigned long divisor;
 	long long pos_ratio;
 	long x;
 
 	divisor = limit - setpoint;
 	if (!divisor)
-		divisor = 1;
+		divisor = 1;	/* Avoid div-by-zero */
 
 	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
 		    divisor);
_

