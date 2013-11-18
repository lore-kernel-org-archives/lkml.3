Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3KRVQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:16:48 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:43878 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab3KRVQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:16:47 -0500
Message-ID: <528A83BE.3020105@akamai.com>
Date: Mon, 18 Nov 2013 16:16:46 -0500
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Jason Baron <jbaron@akamai.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic: Make panic_timeout configurable
References: <20131108204307.49C6AFE076@prod-mail-relay02.akamai.com> <20131111093213.GA13550@gmail.com> <5282DF83.7020809@akamai.com> <20131113113647.GC9654@gmail.com>
In-Reply-To: <20131113113647.GC9654@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 06:36 AM, Ingo Molnar wrote:
> 
> * Jason Baron <jbaron@akamai.com> wrote:
> 
>> Ok - we could have a set function, to unexport the var from the arch 
>> init as:
>>
>> void set_panic_timeout_early(int timeout, int arch_default_timeout)
>> {
>>     if (panic_timeout == arch_default_timeout)
>>          panic_timeout = timeout;
>> }
> 
>>
>> That would work for the arch initialization, although we have a small 
>> window b/w initial boot and arch_init() where we have the wrong value in 
>> 2 cases (b/c its changing) - but that can be fixed now by manually 
>> overriding the .config setting now, if we can't consolidate to 1 setting 
>> per-arch. Maybe the arch maintainers can comment? But i think its still 
>> an improvement...
> 
> Yeah.
> 
>> We'll also need an accessor functions for usages in:
>> arch/x86/kernel/cpu/mcheck/mce.c and ./drivers/acpi/apei/ghes.c.
> 
> Correct. I was actually surprised at seeing those write accesses - with 
> global variables it's easy to slip in such usage without people being 
> fully aware of it. Accessors add a (minimal) barrier against such usage.
> 
>> Finally, kernel/sysctl.c, directly accesses panic timeout. I think the 
>> command line "panic_timeout=" and sysctl settings continue to be 
>> complete overwrites? So we can add a set function that just does an 
>> overwrite for these cases.
> 
> Yeah, whatever the user sets most recently always dominates over older 
> decisions. From the UI side the ordering is:
> 
> 	- generic kernel default
> 	- arch default
> 	- kernel build .config default
> 	- panic_timeout= setting
> 	- sysctl value
> 
> All but the first value is optional, and whichever of the optional value 
> settings comes last dominates and takes precedence over earlier ones.
> 
> Also, because the interaction between different configuration points is 
> complex it might make sense to organize it a bit. At the risk of slightly 
> overdesigning it, instead of tracking a single value default-value-based 
> decisions in set_panic_timeout_early(), we could actually track which of 
> those options were taken, by tracking the 5 values:
> 
> 	int panic_timeout_generic	=  0;
> 	int panic_timeout_arch		= -1;
> 	int panic_timeout_build		= -1;
> 	int panic_timeout_boot		= -1;
> 	int panic_timeout_sysctl	= -1;
> 
> That fits on a single cacheline. Going from last towards first taking the 
> the first one that isn't -1:
> 
> 	static int panic_timeout(void)
> 	{
> 		if (panic_timeout_sysctl != -1)
> 			return panic_timeout_sysctl;
> 		if (panic_timeout_boot != -1)
> 			return panic_timeout_boot;
> 		if (panic_timeout_build != -1)
> 			return panic_timeout_build;
> 		if (panic_timeout_arch != -1)
> 			return panic_timeout_arch;
> 
> 		return panic_timeout_generic;
> 	}
> 
> And the accessors are trivial and obvious and there's no ugly intermixing 
> between them. The priority between the different configurtion points of 
> setting these values is thus obvious and straightforward as well.
> 
> This might sound more complex than it really is - but once the scheme is 
> done in such a fashion it will IMHO behave pretty intuitively to users and 
> won't produce surprises if some default value happens to be the one that 
> the user configures.
> 
> Thanks,
> 
> 	Ingo

Hi,

I've re-posted a v2 (in a separate thread), that addresses the concerns about having
arch specific code polluting common code.

However, I didn't implement the full scheme suggested above for mainly 2 reasons:

1) Cases 1-3: generic kernel default, arch default, and kernel build .config default
cases, really could be simplified to 1 case, if mips, powerpc could agree on 1 default
value. In any case, there are only 2 exceptions here to deal with these cases.

2) The concurrency of accesses to panic_timeout doesn't exist. I initially thought there
was potentially a lot of concurrency, but I don't think that is the case. For example,
the driver uses are all in panic paths, and the sysfs vs. command-line should be well
ordered already.

So I sort of felt the above design was a bit much, but I'll re-visit it if you
still feel it provides a real benefit here. My main concern is the ability to build
in the timeout, which would be the case either way.

Thanks,

-Jason 


