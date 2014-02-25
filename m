Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaBYW0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:26:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51992 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751344AbaBYW0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:26:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug online work is done
Date: Tue, 25 Feb 2014 23:41:18 +0100
Message-ID: <1789244.B5CzWbcp6h@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <530D06FF.201@codeaurora.org>
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org> <15001517.xLHO8lGdWr@vostro.rjw.lan> <530D06FF.201@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 25, 2014 01:11:27 PM Saravana Kannan wrote:
> On 02/25/2014 05:04 AM, Rafael J. Wysocki wrote:
> > On Tuesday, February 25, 2014 02:20:57 PM Viresh Kumar wrote:
> >> On 25 February 2014 01:53, Saravana Kannan <skannan@codeaurora.org> wrote:
> >>> I was simplifying the scenario that causes it. We change the min/max using
> >>> ADJUST notifiers for multiple reasons -- thermal being one of them.
> >>>
> >>> thermal/cpu_cooling is one example of it.
> >>
> >> Just to understand the clear picture, you are actually hitting this bug? Or
> >> is this only a theoretical bug?
> >>
> This is a real bug. But the actual caller of cpufreq_update_policy() is 
> a driver that's local to our tree. I'm just giving examples of upstream 
> code that act in a similar way.
> 
> >>> So, cpufreq_update_policy() can be called on any CPU. If that races with
> >>> someone offlining a CPU and onlining it, you'll get this crash.
> >>
> >> Then shouldn't that be fixed by locks? I think yes. That makes me agree with
> >> Srivatsa more here.
> >>
> >> Though I would say that your argument was also valid that 'policy' shouldn't be
> >> up for sale unless it is prepared to. And for that reason only I
> >> floated that question
> >> earlier: What exactly we need to make sure is initialized in policy? Because
> >> policy might keep changing in future as well and that needs locks to protect
> >> that stuff. Like min/max/governor/ etc..
> >
> > Well, that depends on what the current users expect it to look like initially.
> > It should be initialized to the point in which all of them can handle it
> > correctly.
> 
> Yes, so let's not make it available until all of it is initialized.

And is "fully initialized" actually well defined?

> I don't like the piece meal check. 6 months down the lane someone making 
> changes might not remember this. The problem also applies for drivers 
> that might not be upstreamed, etc.

Please don't bring up out-of-the-tree drivers argument in mainline discussions,
it is meaningless here.

> >> So, probably a solution here might be a mix of both. Initialize policy to this
> >> minimum level and then make sure locking is used correctly..
> >
> > Yes.
> 
> Rafael, It's not clear what you mean by the yes. Do you want to 
> initialize it partly and make it available. I think that's always wrong.

So what actually is your porposal?

> >>> The idea would exist, but we can just call cpufreq_generic_get() and pass it
> >>> policy->clk if it is not NULL. Does that work for you?
> >>
> >> No. Not all drivers implement clk interface. And so clk doesn't look to be the
> >> right parameter. I thought maybe 'policy' can be the right parameter and
> >> then people can get use policy->cpu to get cpu id out of it.
> >>
> >> But even that doesn't look to be a great idea. X86 drivers may share policy
> >> structure for CPUs that don't actually share a clock line. And so they do need
> >> right CPU number as parameter instead of policy. As they might be doing
> >> some tricky stuff there. Also, we need to make sure that ->get() returns
> >> the frequency at which CPU x is running.
> >
> > That's not going to work in at least some cases anyway, because for some types
> > of HW we simply can't retrieve the current frequency in a non-racy way.
> 
> I think there's been a misunderstanding of what I'm proposing. The 
> reference to policy->clk is only to get rid of the dependency that 
> cpufreq_generic_get() has on the per cpu policy variable being filled. 
> You can do that by just removing calls to get _IF_ clk is filled in.

I still have a little problem understanding what you mean exactly.  At least
please explain the last sentence.

> Viresh,
> 
> I'll look at the patches later today and respond. Although, I would have 
> been nice you had helped me fix any issues with my patch than coming up 
> with new ones. Kinda removes to motivation for submitting patches upstream.

Everyone is free to post patches at any time during the discussion.  Viresh is
as well as you are.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
