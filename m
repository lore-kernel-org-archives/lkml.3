Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab3G3IxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:53:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40539 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3G3IxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:53:04 -0400
Date: Tue, 30 Jul 2013 10:52:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konstantin Krivyakin <k.krivyakin@samsung.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        mingo@redhat.com, kgene.kim@samsung.com, linux-pm@vger.kernel.org,
        i.zhbanov@samsung.com, e.voevodin@samsung.com,
        kyungmin.park@samsung.com, akpm@linux-foundation.org
Subject: Re: [PATCH RFC 0/3] Per-process power consumption measurement
 facility
Message-ID: <20130730085256.GK3008@twins.programming.kicks-ass.net>
References: <1375172259-9641-1-git-send-email-k.krivyakin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375172259-9641-1-git-send-email-k.krivyakin@samsung.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 12:17:36PM +0400, Konstantin Krivyakin wrote:
> This patchset adds per-process power consumption measurement facility.
> Power consumption is very important on mobile platforms. This code
> allows to measure consumed power in Watts*Hours. The consumed power
> for process is updated on scheduler switch and depends on current
> CPU voltage and frequency.
> 
> The formula for computation is: P = C * V^2 * f, where C is a constant
> that reflects capacity of the system, V is the current voltage and
> f is the current frequency.
> (Taken from: http://en.wikipedia.org/wiki/CPU_power_dissipation).
> 
> In this patchset was added implementation for Exynos platform
> to demonstrate how it works.
> 
> To minimize scheduler impact for each CPU P-state the value of (V^2 *f)
> was precomputed at the time of platform initialization.

It seems to me the 3 multiplies that takes could be done when cpufreq
actually changes the P-state.

> And to reduce performance impact furthermore, the C constant is multiplied
> in userspace.

That seems particularly silly; how is userspace to know C and why
isn't it a much better idea to do this in the code generating the number
for userspace to consume.

Also, I intensely dislike this thing because:

 - it adds more user interface
 - it adds more accounting muck
 - it completely lacks any useful changelogs
 - it completely fails to even begin addressing the issues we already
   have with cpufreq

There's been a lot of talk about power aware scheduling in the recent
past, there's also been a lot of problems listed we must overcome/solve.
This patch set completely fails to tie into any of that.

You also completely fail to explain the user case and thus related why
you can't use any of the other facilities like perf or ftrace to measure
this.
