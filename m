Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaBQVpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:45:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51517 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751100AbaBQVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:45:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre-list@ossman.eu>
Subject: Re: [PATCH 1/2] cpufreq: Return error if ->get() failed in cpufreq_update_policy()
Date: Mon, 17 Feb 2014 23:00:32 +0100
Message-ID: <1489022.1IbaesBAQQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5301CE86.9020105@linux.vnet.ibm.com>
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org> <CAKohpo=mQWxoKTduR8FrrB4Qz45qXQrJjSudq=FkCJtHBTbo2Q@mail.gmail.com> <5301CE86.9020105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 17, 2014 02:25:34 PM Srivatsa S. Bhat wrote:
> On 02/17/2014 02:09 PM, Viresh Kumar wrote:
> > On 17 February 2014 13:49, Srivatsa S. Bhat
> > <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> >> Quick question: Looking at cpufreq_update_policy() and cpufreq_out_of_sync(),
> >> I understand that if the cpufreq subsystem's notion of the current frequency
> >> does not match with the actual frequency of the CPU, it tries to adjust and
> >> notify everyone that the current frequency is so-and-so, as read from the
> >> hardware. Instead, why can't we simply set the frequency to the value that
> >> we _want_ it to be at? I mean, if cpufreq subsystem thinks it is X KHz and
> >> the actual frequency is Y KHz, we can as well fix the anomaly by setting the
> >> frequency immediately to X KHz right?
> >>
> >> The reason I ask this is that, if we follow this approach, then we can avoid
> >> ambiguities in dealing with the out-of-sync situation. That is, it becomes
> >> very straightforward to decide _what_ to do, when we detect scenarios where
> >> the frequency goes out of sync.
> > 
> > Hmm, it is just about doing all that stuff in a single line, like:
> > __cpufreq_driver_target(...) ??
> > 
> > There are few problems here:
> > - If we simply call above routine with X, then it will simply return as
> > X == policy->cur. And I don't want to hack this code in a bad way now :)
> > 
> > - So, probably the way it is implemented is right, as we do that the most
> > efficient way. We just broadcast the new freq in case there is a difference
> > otherwise nothing.
> 
> Specifically, I'm referring to the problem where there _is_ a difference,
> but the ->get() is not reporting it properly, like returning a 0 for example.
> In such a case, instead of erroring out (and thereby perhaps opening the doors
> to more problems down the line), won't it be better to simply set the CPU's
> frequency to what we want it to be?
> 
> That is, I'm concerned about this part of your patch:
> 
>  	if (cpufreq_driver->get) {
>  		new_policy.cur = cpufreq_driver->get(cpu);
> +
> +		if (!new_policy.cur) {
> +			pr_err("%s: ->get() returned 0 KHz\n", __func__);
> +			ret = -EINVAL;
> +			goto no_policy;
> +		}
> +
> 
> Why go to no_policy when we can actually set things right?
> 
> Anyway, I am not arguing against this strongly. I just wanted to share my
> thoughts, since this is the approach that made more sense to me.

And I agree with that.  In particular, since we're going to set the new
policy *anyway* at this point, we can adjust the current frequency just fine
in the process, can't we?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
