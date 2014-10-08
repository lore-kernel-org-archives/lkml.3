Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbaJHPs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:48:56 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42560 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbaJHPsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:48:54 -0400
Date: Wed, 8 Oct 2014 16:48:51 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tuukka.tikkanen@linaro.org" <tuukka.tikkanen@linaro.org>
Subject: Re: [PATCH RFC 2/2] cpufreq: arm_big_little: provide cpu capacity
Message-ID: <20141008154851.GF1788@e105550-lin.cambridge.arm.com>
References: <20141008060712.4379.42509@quantum>
 <1412749572-29449-1-git-send-email-mturquette@linaro.org>
 <1412749572-29449-3-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412749572-29449-3-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 07:26:12AM +0100, Mike Turquette wrote:
> Move the cpu capacity bits out of arch/arm/ and into the CPUfreq driver.
> Not all ARM devices will use CPUfreq and it is unsafe to assume as such
> in topology.c.
> 
> Instead, use the new capacity_ops introduced into CFS. If this code is
> generic enough then it could be factored and shared via a header to make
> it easier for other CPUfreq drivers to take advantage of it.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
> This approach simply builds on top of Morten's series. I am not sure
> that the per-cpu method is the best way to go in the future. And if so I
> imagine that the CPUfreq core could provide everything except for the
> cpu_eff part.
> 
> In general I think that the overlap between CPUfreq drivers and
> arch/arm/kernel/topology.c is something that needs to addresssed soon,
> as both pieces of code are re-inventing parts of each other.

I think it would be easier to deal with the capacity scaling if we split
it into two scaling factors (like Vincent proposed by using the existing
arch_scale_{cpu,freq}_capacity() functions). Then whatever handles
frequency scaling doesn't have to coordinate with uarch scaling. Both
would be factors in the range 0..1024. We would just multiply the two
scaling factors in fair.c when needed (and shift as necessary).

Wouldn't that make it simple enough that we can implement it in a
generic way in arch/*/topology.c with a bit of help from the cpufreq
framework without involving any drivers directly? Or is that just
wishful thinking? :)
