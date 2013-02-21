Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3BUOwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 09:52:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:45243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab3BUOww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 09:52:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,709,1355126400"; 
   d="scan'208";a="265700120"
Message-ID: <512634B1.4040101@intel.com>
Date: Thu, 21 Feb 2013 22:52:33 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com
Subject: Re: [patch v5 11/15] sched: add power/performance balance allow flag
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-12-git-send-email-alex.shi@intel.com> <20130220121256.GD16775@pd.tnic> <5124DBA3.20605@intel.com> <20130220152234.GE16775@pd.tnic> <51257946.1010505@intel.com> <20130221094213.GA4694@pd.tnic>
In-Reply-To: <20130221094213.GA4694@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 05:42 PM, Borislav Petkov wrote:
> On Thu, Feb 21, 2013 at 09:32:54AM +0800, Alex Shi wrote:
>> Yes, use flags can save 2 int variable, I will change that.
>>
>> Just curious, consider the lb_env size and just used in stack, plus
>> the big cacheline size of modern cpu, and the alignment of gcc flag on
>> kernel, seems no arch needs more cache lines. Are there any platforms
>> performance is impacted by this 2 int variables?
> 
> Not that I know of. But that's not the point: if we don't pay attention
> and are not as economical as possible in the kernel, and especially in
> heavily walked code as the scheduler, we'll become fat and bloated (if
> we're not halfway there already, that is).
> 
> It might not impact processor bandwidth now because internal paths are
> obviously adequate but you're not the only one adding features. What
> happens if the next guy comes and adds another two integers just because
> it is convenient in the code?

Thanks for the detailed nice explanation!

I know the point, as a performance sensitive guy, just curious which
platform maybe impacted. :)
> 
> Btw, sizeof(lb_env) is currently something around 80 bytes AFAICT. Now
> that doesn't fit in one cacheline anyway. So if you add your two ints,
> they'll be trailing in the second cacheline which needs to go up to L1.
> 
> Now flags will still be at the beginning of the second cacheline but
> it is still better to add two new bits there because this is exactly
> what this variable is for.
> 
> And, just for the fun of it, if you push the flags variable higher in
> the struct itself, it will land in the first cacheline and there's your
> design with *absolutely* no overhead in that respect. I betcha if you
> do this, you won't see any overhead in L1 utilization even with perf
> counters because you get it practically for free.

thanks suggestion.
looks the member's sequence was considered in lb_env. The 'flags' looks
less important and used frequent than the fields before it. :)
> 
> :-)
> 


-- 
Thanks
    Alex
