Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaBYMB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:01:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39601 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBYMB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:01:56 -0500
Date: Tue, 25 Feb 2014 13:01:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Alexey Perevalov <a.perevalov@samsung.com>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com
Subject: Re: [RFC patch 2/5] hrtimer: Make use of the active bases bitfield
Message-ID: <20140225120149.GR9987@twins.programming.kicks-ass.net>
References: <20140221173936.583477951@linutronix.de>
 <20140221174639.557494772@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221174639.557494772@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 05:56:16PM -0000, Thomas Gleixner wrote:
> -	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
> +	while (bases) {
>  		struct hrtimer_clock_base *base;
>  		struct timerqueue_node *node;
>  		ktime_t basenow;
> +		int idx;
>  
> -		if (!(cpu_base->active_bases & (1 << i)))
> -			continue;
> +		idx = __ffs(bases);
> +		bases &= ~(1 << idx);
>  
> -		base = cpu_base->clock_base + i;
> +		base = cpu_base->clock_base + idx;
>  		basenow = ktime_add(now, base->offset);
>  
>  		while ((node = timerqueue_getnext(&base->active))) {

That's crappy for archs that end up using the generic __ffs().

The simply loop we had isn't too bad, why change this?
