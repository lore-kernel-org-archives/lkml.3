Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab3BUJmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:42:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55228 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab3BUJmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:42:18 -0500
Date: Thu, 21 Feb 2013 10:42:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 11/15] sched: add power/performance balance allow flag
Message-ID: <20130221094213.GA4694@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
	mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
	akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
	namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
	gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
	viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
	morten.rasmussen@arm.com
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
 <1361164062-20111-12-git-send-email-alex.shi@intel.com>
 <20130220121256.GD16775@pd.tnic>
 <5124DBA3.20605@intel.com>
 <20130220152234.GE16775@pd.tnic>
 <51257946.1010505@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51257946.1010505@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 09:32:54AM +0800, Alex Shi wrote:
> Yes, use flags can save 2 int variable, I will change that.
>
> Just curious, consider the lb_env size and just used in stack, plus
> the big cacheline size of modern cpu, and the alignment of gcc flag on
> kernel, seems no arch needs more cache lines. Are there any platforms
> performance is impacted by this 2 int variables?

Not that I know of. But that's not the point: if we don't pay attention
and are not as economical as possible in the kernel, and especially in
heavily walked code as the scheduler, we'll become fat and bloated (if
we're not halfway there already, that is).

It might not impact processor bandwidth now because internal paths are
obviously adequate but you're not the only one adding features. What
happens if the next guy comes and adds another two integers just because
it is convenient in the code?

Btw, sizeof(lb_env) is currently something around 80 bytes AFAICT. Now
that doesn't fit in one cacheline anyway. So if you add your two ints,
they'll be trailing in the second cacheline which needs to go up to L1.

Now flags will still be at the beginning of the second cacheline but
it is still better to add two new bits there because this is exactly
what this variable is for.

And, just for the fun of it, if you push the flags variable higher in
the struct itself, it will land in the first cacheline and there's your
design with *absolutely* no overhead in that respect. I betcha if you
do this, you won't see any overhead in L1 utilization even with perf
counters because you get it practically for free.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
