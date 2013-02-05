Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3BEK11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:27:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52812 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab3BEK1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:27:24 -0500
Date: Tue, 5 Feb 2013 11:27:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Message-ID: <20130205102721.GB4827@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
	Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
	Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
References: <20130204133648.GE13909@pd.tnic>
 <CAKohpo=aLnhM0Op_32ohWZK5eG5nT7iK0OktBe+8ygOQW7zUqQ@mail.gmail.com>
 <20130204140908.GC15452@pd.tnic>
 <CAKohpokowK6ybYd8aDUdfFYsnzoc5VAKsuPSkfxoDqJ3k+FwGA@mail.gmail.com>
 <20130204150511.GF13909@pd.tnic>
 <CAKohpokt0xtsj1eQDMw6JgvQVp4rgFyU-vUrtuuF+0jjOVNHRQ@mail.gmail.com>
 <20130204165057.GH13909@pd.tnic>
 <CAOh2x==fyfYwz+eXmPhBJTE+_q_fHyx2drXrM789XvCfEqPBUQ@mail.gmail.com>
 <20130205091532.GA4827@pd.tnic>
 <CAKohpo=6q+Bcgq0Re=3SXM6zwub5N=vJBO=sTeEgZZ9byFK7=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpo=6q+Bcgq0Re=3SXM6zwub5N=vJBO=sTeEgZZ9byFK7=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 03:17:21PM +0530, Viresh Kumar wrote:
> > multiple policies support in cpufreq should be optional and
> > selectable in Kconfig so that systems which don't need that, don't
> > have to see or use it. It is yet another feature which doesn't apply
> > universally so we make such features optional. Like the rest of the
> > gazillion things in the kernel already.
> 
> I understand what Kconfig options are for, but i am not able to understand
> what's the benefit of this option here.

Are you kidding me? You're simply not reading what I'm saying to you:
"... should be optional and selectable in Kconfig so that systems which
don't need that, don't have to see or use it." Because on those systems
it doesn't apply.

How about we add an x86-specific extension which is a big wad of code
and is needlessly run on ARM just because it is easier?

That's why we do config options, so that code which doesn't apply on a
specific system, doesn't run on it.

Goddammit, how hard is to understand that??!

> For example: for single image solutions we need to keep it enabled.

So keep it enabled!

> And so, would need some sort of logic in cpufreq core & platform
> driver to decide where to create the governors directory.
>
> The code without Kconfig option would be as simple as:

> 
> platform_driver:
> init(struct cpufreq_policy *policy)
> {
> ..
>     policy->have_multiple_policies = true;
> ..
> }
> 
> cpufreq-core:
> 
> add_dev()
> {
>     if (policy->have_multiple_policies)
>         create-folder-in-cpu/cpu*/cpufreq;
>     else
>         create-folder-in-cpu/cpufreq;

Yes, this is how it could be done.

And this is what I mean by making it optional:

You go and abstract away the "create-folder-in-cpu/cpu*/cpufreq"
functionality. If this is a function called
add_additional_sysfs_entries(), for example, it should do nothing when
CONFIG_CPUFREQ_MULTIPLE_POLICIES is disabled. Otherwise, it will do your
dance:

#ifdef CONFIG_CPUFREQ_MULTIPLE_POLICIES
static int add_additional_sysfs_entries(...)
{

	do all stuff required for multiple policies

}
#else /* CONFIG_CPUFREQ_MULTIPLE_POLICIES */
static int add_additional_sysfs_entries(...)
{
	return 0;
}
#endif /* CONFIG_CPUFREQ_MULTIPLE_POLICIES */

and all the rest of the stuff which is needed for multiple system
policies, should be abstracted that way, more functions added, whatever.
If it is starting to become more, you can create your own compilation
unit. And so on and so on... the kernel is full of examples how to do
stuff like that.

> And so, platforms like Krait or big.LITTLE can set it to true from their
> cpufreq-drivers. And this wouldn't break any of the current platforms.
> 
> > The existing sysfs layout cannot be changed because you're breaking
> > userspace and we don't do that. It is that simple.
> 
> That's fine. I understood it already. :)

Not really, you obviously didn't.

> The problem i see is:
> - both governor tunables, cpufreq-stats & policy tunables (P-states) have the
> same requirement. They are all per policy or clock-domain, instead of per cpu.
> - I want to keep all of these at the same place, as they should be
> present in the
> same hierarchy.
> - If we move everything to cpu/cpufreq/policy-names/ then also we would break
> existing userspace stuff for stats and P-states.
> - If we move everything to cpu/cpu*/cpufreq/ then also we would break
> existing userspace stuff for governors.

No, you're not allowed to change existing sysfs layout. FULLSTOP.

Simply add the new stuff to cpu/cpu*/cpufreq/ with code which
is enabled when CONFIG_CPUFREQ_MULTIPLE_POLICIES is set. If
CONFIG_CPUFREQ_MULTIPLE_POLICIES is not enabled, nothing changes.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
