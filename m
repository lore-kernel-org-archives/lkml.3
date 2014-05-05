Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaEEAP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:15:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50231 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753891AbaEEAPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:15:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Amit Kucheria <amit.kucheria@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Date: Mon, 05 May 2014 02:32:31 +0200
Message-ID: <11389655.8tCmxgKokW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <535F7E23.7020104@linaro.org>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org> <5275186.Hb1xxV4ZWO@vostro.rjw.lan> <535F7E23.7020104@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 12:25:39 PM Daniel Lezcano wrote:
> On 04/29/2014 01:11 AM, Rafael J. Wysocki wrote:
> > On Monday, April 28, 2014 01:07:31 PM Daniel Lezcano wrote:

[cut]

> > In my opinion it would be much better to have a knob representing the current
> > relative value of energy to the user (which may depend on things like whether
> > or not the system is on battery etc) and meaning how far we need to go with
> > energy saving efforts.
> >
> > So if that knob is 0, we'll do things that are known-good for performance.
> > If it is 1, we'll do some extra effort to save enery as well possibly at
> > a small expense of performance if that's necessary.  If it is 100, we'll do
> > all we can to save as much energy as possible without caring about performance
> > at all.
> >
> > And it doesn't even have to be scheduler-specific, it very well may be global.
> 
> That would be very nice but I don't see how we can quantify this energy 
> and handle that generically from the kernel for all the hardware.
> 
> I am pretty sure we will discover for some kind of hardware a specific 
> option will consume more power, argh ! energy I mean, than another 
> hardware because of the architecture.
> 
>  From my personal experience, when we are facing this kind of complexity 
> and heuristic, it is the sign the userspace has some work to do.
> 
> What I am proposing is not in contradiction with your approach, it is 
> about exporting a lot of knobs to userspace, and the userspace decide 
> how to map what is '0' <--> '100' regarding these options. Nothing 
> prevent the different platform to set a default value for these options.

Our experience so far, however, is that user space is not really likely to
change the default values of such knobs.

>  From my POV, the cgroup could be a good solution for that for different 
> reasons. Especially one good reason is we can stick the energy policy 
> per task instead of the entire system.
> 
> Let's imagine the following scenario:
> 
> An user has a laptop running a mailer looking for the email every 5 
> minutes. The system switched to 'power'. The user wants to play a video 
> game but due to the 'power' policy, the game is not playable so it 
> forces the policy to 'performance'. All the tasks will use the 
> 'performance' policy, thus consuming more energy.

This isn't all about the given task, but also about devices that are in use
while it is being run.  For example, to play a game the user would probably
like the input subsystem to be more responsive and the screen to be brighter
etc.  If that is a network game, the network adapter will probably need to
work in the "performance" mode too.

> If we do per task, the video game will use the 'performance' policy and 
> the other tasks on the system will use the 'power' policy. The userspace 
> can take the decision to freeze the application running 'performance' if 
> we reach a critical battery level.

Well, consider task packing in that context and suppose that according to the
current policy task packing should be applied to "energy efficient" tasks, but
not to "performance" tasks.  Now, suppose that there's an "energy efficient"
task to run and there's a core occupied by a "performace" task.  Should the
"energy efficient" task be run on that core or should we find another one
for it?  Who's more important in that case?

> The cgroup is a good framework to do that and gives a lot of flexibility 
> to userspace. I understood Peter does not like the cgroup but I did not 
> give up to convince him, the cgroup could be good solution :)

Will user space actually use that flexibility?

> Looking forward, if the energy policy is tied with the task, in the 
> future we can normalize the energy consumption and stick to an 'energy 
> load' per task and reuse the load tracking for energy, do per task 
> energy accounting, nice per energy, etc ...

That can be done, but some parts of the kernel that may benefit from an
"energy conservation bias" knob are not tied to any particular task.  The
block layer may be one example here.

> Going back to reality, concretely this sysctl patch did not reach a 
> consensus. So I will resend the two other patches, hoping the discussion 
> will lead to an agreement.

Well, the discussion so far has been useful to me anyway. :-)

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
