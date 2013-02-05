Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3BEJr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:47:28 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54743 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3BEJrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:47:23 -0500
MIME-Version: 1.0
In-Reply-To: <20130205091532.GA4827@pd.tnic>
References: <20130204130403.GD13909@pd.tnic>
	<CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
	<20130204133648.GE13909@pd.tnic>
	<CAKohpo=aLnhM0Op_32ohWZK5eG5nT7iK0OktBe+8ygOQW7zUqQ@mail.gmail.com>
	<20130204140908.GC15452@pd.tnic>
	<CAKohpokowK6ybYd8aDUdfFYsnzoc5VAKsuPSkfxoDqJ3k+FwGA@mail.gmail.com>
	<20130204150511.GF13909@pd.tnic>
	<CAKohpokt0xtsj1eQDMw6JgvQVp4rgFyU-vUrtuuF+0jjOVNHRQ@mail.gmail.com>
	<20130204165057.GH13909@pd.tnic>
	<CAOh2x==fyfYwz+eXmPhBJTE+_q_fHyx2drXrM789XvCfEqPBUQ@mail.gmail.com>
	<20130205091532.GA4827@pd.tnic>
Date: Tue, 5 Feb 2013 15:17:21 +0530
Message-ID: <CAKohpo=6q+Bcgq0Re=3SXM6zwub5N=vJBO=sTeEgZZ9byFK7=g@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 February 2013 14:45, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Feb 05, 2013 at 12:50:31PM +0530, Viresh Kumar wrote:
>> > I think this is cleaner but whatever - I don't care that much. My
>> > only strong concern is that this thing should be a Kconfig option and
>> > optional for arches where it doesn't apply.
>>
>> Your concern is: we don't want to fix userspace for existing platforms
>> where we have just a single cluster and so struct policy in the system.
>
> No, as I said so many times already and you're unwilling to understand
> it:

I am willing to, but not able to :)

> multiple policies support in cpufreq should be optional and
> selectable in Kconfig so that systems which don't need that, don't
> have to see or use it. It is yet another feature which doesn't apply
> universally so we make such features optional. Like the rest of the
> gazillion things in the kernel already.

I understand what Kconfig options are for, but i am not able to understand
what's the benefit of this option here. For example: for single image solutions
we need to keep it enabled. And so, would need some sort of logic in cpufreq
core & platform driver to decide where to create the governors directory.

The code without Kconfig option would be as simple as:

platform_driver:
init(struct cpufreq_policy *policy)
{
..
    policy->have_multiple_policies = true;
..
}

cpufreq-core:

add_dev()
{
    if (policy->have_multiple_policies)
        create-folder-in-cpu/cpu*/cpufreq;
    else
        create-folder-in-cpu/cpufreq;
}

And so, platforms like Krait or big.LITTLE can set it to true from their
cpufreq-drivers. And this wouldn't break any of the current platforms.

> The existing sysfs layout cannot be changed because you're breaking
> userspace and we don't do that. It is that simple.

That's fine. I understood it already. :)

The problem i see is:
- both governor tunables, cpufreq-stats & policy tunables (P-states) have the
same requirement. They are all per policy or clock-domain, instead of per cpu.
- I want to keep all of these at the same place, as they should be
present in the
same hierarchy.
- If we move everything to cpu/cpufreq/policy-names/ then also we would break
existing userspace stuff for stats and P-states.
- If we move everything to cpu/cpu*/cpufreq/ then also we would break
existing userspace stuff for governors.

> Concerning adding new sysfs entries, I told you to make it as easy as
> possible and as sensible as possible, dictated by the use cases. If you
> can't come up with some, then talk to the people who are going to use
> your design and ask them what makes sense the most.

For me cpu/cpu*/ is the most sensible as it is an very easy/convenient interface
for users. I am the first one who is going to use it :)

@Rafael: What's your view on this discussion we are having? We probably need few
more "minds" to jump in, as we are not moving towards a conclusion. :)

--
viresh
