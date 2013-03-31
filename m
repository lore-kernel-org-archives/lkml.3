Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3CaSTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 14:19:39 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49790 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab3CaSTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 14:19:38 -0400
Date: Sun, 31 Mar 2013 11:19:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 3/4] block: queue work on unbound wq
Message-ID: <20130331181931.GA7533@htj.dyndns.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
 <91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Viresh.

On Sun, Mar 31, 2013 at 08:01:46PM +0530, Viresh Kumar wrote:
> Block layer uses workqueues for multiple purposes. There is no real dependency
> of scheduling these on the cpu which scheduled them.
> 
> On a idle system, it is observed that and idle cpu wakes up many times just to
> service this work. It would be better if we can schedule it on a cpu which the
> scheduler believes to be the most appropriate one.
> 
> This patch replaces normal workqueues with UNBOUND versions.

Hmm.... so, we really don't want to unconditionally convert workqueues
to unbound.  Especially not kblockd.  On configurations with multiple
high iops devices with IRQ routing, having request completion runinng
on the same CPU has significant performance advantages.  We can't
simply switch it to an unbound wokrqueue because it saves power on
small arm configuration.

Plus, I'd much prefer to be clearly marking the workqueues which would
contribute to powersaving when converted to unbound at least until we
can come up with a no-compromise solution which doesn't need to trade
off between cache locality and powersaving.

So, let's please introduce a new flag to mark these workqueues, say,
WQ_UNBOUND_FOR_POWER_SAVE or whatever (please come up with a better
name) and provide a compile time switch with boot time override.

Thanks.

-- 
tejun
