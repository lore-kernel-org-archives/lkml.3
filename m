Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaJVOpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:45:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaJVOpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:45:51 -0400
Date: Wed, 22 Oct 2014 16:45:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141022144543.GV12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 04:45:40PM +0300, Alexander Shishkin wrote:
> +static int pt_config(struct perf_event *event)
> +{
> +	u64 reg;
> +
> +	reg = RTIT_CTL_TOPA | RTIT_CTL_BRANCH_EN;
> +
> +	if (!event->attr.exclude_kernel)
> +		reg |= RTIT_CTL_OS;
> +	if (!event->attr.exclude_user)
> +		reg |= RTIT_CTL_USR;
> +
> +	reg |= (event->attr.config & PT_CONFIG_MASK);
> +
> +	/*
> +	 * User can try to set bits in RTIT_CTL through PT_BYPASS_MASK,
> +	 * that aren't supported by the hardware. Weather or not a
> +	 * particular bitmask is supported by a cpu can't be determined
> +	 * via cpuid or otherwise, so we have to rely on #GP handling
> +	 * to catch these cases.
> +	 */
> +	return wrmsrl_safe(MSR_IA32_RTIT_CTL, reg);
> +}

Whether the weather is nice or not :-)

But no, this cannot be, once we've accepted the event is must be
programmable. Failing at the time of programming is vile; pmu::start()
is a void return, failure is not an option there.

The fact that the hardware cannot even tell you the supported mask is
further fail.

IIRC I think Andi once suggested probing each of the 64 bits in that MSR
to determine the supported mask at device init time.

BTW, what's that RTIT thing? Did someone forget to propagate the latest
name change of the thing or so?
