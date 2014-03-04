Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaCDRHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:07:38 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54962 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbaCDRHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:07:36 -0500
Date: Tue, 4 Mar 2014 09:07:32 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felix Rueegg <felix.rueegg@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: ff-memless: don't schedule already playing effect
 to play again
Message-ID: <20140304170731.GA30486@core.coreip.homeip.net>
References: <1393760143-5986-1-git-send-email-felix.rueegg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393760143-5986-1-git-send-email-felix.rueegg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felix,

On Sun, Mar 02, 2014 at 12:35:43PM +0100, Felix Rueegg wrote:
> When an effect with zero replay length, zero replay delay
> and zero envelope attack length is uploaded, it is played and then scheduled to play
> again one timer tick later. This triggers a warning (URB submitted while
> active) in combination with the xpad driver.
> 
> Skipping the rescheduling of this effect fixes the issue.

Won't the same issue happen if we happen to schedule a different effect
that would start at "now" time? We should not be "dropping" the new
effect, at least not in core.

It looks to me xpad.c needs [more] love.

> 
> Signed-off-by: Felix Rueegg <felix.rueegg@gmail.com>
> ---
>  drivers/input/ff-memless.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
> index 74c0d8c..2e06948 100644
> --- a/drivers/input/ff-memless.c
> +++ b/drivers/input/ff-memless.c
> @@ -139,10 +139,13 @@ static void ml_schedule_timer(struct ml_device *ml)
>  		if (!test_bit(FF_EFFECT_STARTED, &state->flags))
>  			continue;
>  
> -		if (test_bit(FF_EFFECT_PLAYING, &state->flags))
> +		if (test_bit(FF_EFFECT_PLAYING, &state->flags)) {
>  			next_at = calculate_next_time(state);
> -		else
> +			if (next_at == now)
> +				continue;
> +		} else {
>  			next_at = state->play_at;
> +		}
>  
>  		if (time_before_eq(now, next_at) &&
>  		    (++events == 1 || time_before(next_at, earliest)))
> -- 
> 1.9.0
> 

Thanks.

-- 
Dmitry
