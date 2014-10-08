Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaJHIh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:37:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:60008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbaJHIhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:37:24 -0400
Date: Wed, 8 Oct 2014 10:37:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@redhat.com,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        tuukka.tikkanen@linaro.org
Subject: Re: [PATCH RFC 1/2] sched: cfs: introduce capacity_ops
Message-ID: <20141008083721.GE10832@worktop.programming.kicks-ass.net>
References: <20141008060712.4379.42509@quantum>
 <1412749572-29449-1-git-send-email-mturquette@linaro.org>
 <1412749572-29449-2-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412749572-29449-2-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 11:26:11PM -0700, Mike Turquette wrote:
> +struct capacity_ops {
> +	unsigned long (*get_capacity)(int cpu);
> +	spinlock_t lock;
> +};

Yeah, fail there. Ops vectors should not contain serialization, that
simply doesn't work. It means you cannot switch the entire vector out.

Secondly, I dislike this because indirect function calls are more
expensive than direct calls.

> +static unsigned long cfs_get_capacity(int cpu)
>  {
> -	return default_scale_load_capacity(cpu);
> +	unsigned long ret;
> +
> +	rcu_read_lock();
> +	ret = cfs_capacity_ops.get_capacity(cpu);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}

So ideally we'd never change these things, so rcu or whatnot should not
be required.

> +/**
> + * set_default_capacity_ops - reset capacity ops to their default
> + * @eops - capacity_ops we are reseting
> + *
> + * Useful for loadable modules that supply custom capacity_ops callbacks.  When
> + * unloading these modules need to restore the originals before the custom
> + * callbacks disappear.

Yeah, like hell no. We do not want modules to affect scheduler
behaviour.

