Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBYMxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:53:32 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55106 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752680AbaBYMx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:53:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug online work is done
Date: Tue, 25 Feb 2014 14:04:16 +0100
Message-ID: <15001517.xLHO8lGdWr@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpo=0CgzjCgKnDxUMcN6-CgbQ2ML=Tx-K8fS7=VJJYOD0eg@mail.gmail.com>
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org> <530BAA31.4050701@codeaurora.org> <CAKohpo=0CgzjCgKnDxUMcN6-CgbQ2ML=Tx-K8fS7=VJJYOD0eg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 25, 2014 02:20:57 PM Viresh Kumar wrote:
> On 25 February 2014 01:53, Saravana Kannan <skannan@codeaurora.org> wrote:
> > I was simplifying the scenario that causes it. We change the min/max using
> > ADJUST notifiers for multiple reasons -- thermal being one of them.
> >
> > thermal/cpu_cooling is one example of it.
> 
> Just to understand the clear picture, you are actually hitting this bug? Or
> is this only a theoretical bug?
> 
> > So, cpufreq_update_policy() can be called on any CPU. If that races with
> > someone offlining a CPU and onlining it, you'll get this crash.
> 
> Then shouldn't that be fixed by locks? I think yes. That makes me agree with
> Srivatsa more here.
> 
> Though I would say that your argument was also valid that 'policy' shouldn't be
> up for sale unless it is prepared to. And for that reason only I
> floated that question
> earlier: What exactly we need to make sure is initialized in policy? Because
> policy might keep changing in future as well and that needs locks to protect
> that stuff. Like min/max/governor/ etc..

Well, that depends on what the current users expect it to look like initially.
It should be initialized to the point in which all of them can handle it
correctly.

> So, probably a solution here might be a mix of both. Initialize policy to this
> minimum level and then make sure locking is used correctly..

Yes.

> > The idea would exist, but we can just call cpufreq_generic_get() and pass it
> > policy->clk if it is not NULL. Does that work for you?
> 
> No. Not all drivers implement clk interface. And so clk doesn't look to be the
> right parameter. I thought maybe 'policy' can be the right parameter and
> then people can get use policy->cpu to get cpu id out of it.
> 
> But even that doesn't look to be a great idea. X86 drivers may share policy
> structure for CPUs that don't actually share a clock line. And so they do need
> right CPU number as parameter instead of policy. As they might be doing
> some tricky stuff there. Also, we need to make sure that ->get() returns
> the frequency at which CPU x is running.

That's not going to work in at least some cases anyway, because for some types
of HW we simply can't retrieve the current frequency in a non-racy way.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
