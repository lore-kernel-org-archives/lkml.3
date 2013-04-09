Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937175Ab3DIQov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:44:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13577 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763192Ab3DIQot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:44:49 -0400
X-AuditID: cbfee61a-b7fa86d0000045ae-0b-5164457f5653
Date: Tue, 09 Apr 2013 18:44:40 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC PATCH 0/2] cpufreq: Introduce LAB cpufreq governor.
Message-id: <20130409184440.4cd87c1b@amdc308.digital.local>
In-reply-to: <CAKohpomL-mdx6DdFiGwJzDSeWr6Gw-_F4T-D-Jz9TNH5MSgjbw@mail.gmail.com>
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAOh2x=nPJa0GReiN=OHLG=m4Gq51F=4VppdaQL20xi-aUa8x2Q@mail.gmail.com>
 <20130409123719.7399d5ad@amdc308.digital.local>
 <CAKohpomL-mdx6DdFiGwJzDSeWr6Gw-_F4T-D-Jz9TNH5MSgjbw@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9jAd1615RAg62b1CyeNv1gt7j+5Tmr
	RefZJ8wWZ5vesFtc3jWHzeJz7xFGi7VH7rJb3G5cwWbRv7CXyWLG5JdsFh1HvjFbbPzq4cDj
	cefaHjaPvi2rGD0eLW5h9Pi8SS6AJYrLJiU1J7MstUjfLoEr4/H0c+wFH0Uqrja+Z2xg3CzQ
	xcjJISFgInF5TzsbhC0mceHeeiCbi0NIYBGjxKGeE+wgCSGBdiaJrRf5QGwWAVWJnv0XWEBs
	NgE9ic93nzKB2CICURJTLzcxgzQzC+xgluhceA9sqrCAq0Tf/iuMIDavgLVE79b7zCA2p0Cw
	RMePT4wQ2zqYJG79eAo2lV9AUqL93w9miJPsJM592sAO0Swo8WPyPbAaZgEtic3bmlghbHmJ
	zWveMk9gFJyFpGwWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOk2dSOxhX
	NlgcYhTgYFTi4fXQTwkUYk0sK67MPcQowcGsJMKrZAkU4k1JrKxKLcqPLyrNSS0+xCjNwaIk
	znug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwGh9fHv/pYzgotNmdhbTHi4tYPiZEXvRiGteaZXX
	+idPHGYtWf+yI/Bdg/zRpUwTrnueZqsPXe/090ydbLWnhFbTgvy6/ce225mqBp/RmPRX9W7D
	wRPMXV+WntW609w0pdaoX2z9GvWnBy8eOuYVK2VWeH7xZkdm2+yFp3zZbd4HiYp29tTqKCmx
	FGckGmoxFxUnAgB/WRnMjwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh and Vincent,

> On 9 April 2013 16:07, Lukasz Majewski <l.majewski@samsung.com> wrote:
> >> On Mon, Apr 1, 2013 at 1:54 PM, Jonghwa Lee
> > Our approach is a bit different than cpufreq_ondemand one. Ondemand
> > takes the per CPU idle time, then on that basis calculates per cpu
> > load. The next step is to choose the highest load and then use this
> > value to properly scale frequency.
> >
> > On the other hand LAB tries to model different behavior:
> >
> > As a first step we applied Vincent Guittot's "pack small tasks" [*]
> > patch to improve "race to idle" behavior:
> > http://article.gmane.org/gmane.linux.kernel/1371435/match=sched+pack+small+tasks
> 
> Luckily he is part of my team :)
> 
> http://www.linaro.org/linux-on-arm/meet-the-team/power-management
> 
> BTW, he is using ondemand governor for all his work.
> 
> > Afterwards, we decided to investigate different approach for power
> > governing:
> >
> > Use the number of sleeping CPUs (not the maximal per-CPU load) to
> > change frequency. We thereof depend on [*] to "pack" as many tasks
> > to CPU as possible and allow other to sleep.
> 
> He packs only small tasks. 

What's about packing not only small tasks? I will investigate the
possibility to aggressively pack (even with a cost of performance
degradation) as many tasks as possible to a single CPU. 

It seems a good idea for a power consumption reduction. 

> And if there are many small tasks we are
> packing, then load must be high and so ondemand gov will increase
> freq.

This is of course true for "packing" all tasks to a single CPU. If we
stay at the power consumption envelope, we can even overclock the
frequency.

But what if other - lets say 3 CPUs - are under heavy workload? 
Ondemand will switch frequency to maximum, and as Jonghwa pointed out
this can cause dangerous temperature increase.

> 
> > Contrary, when all cores are heavily loaded, we decided to reduce
> > frequency by around 30%. With this approach user experience
> > recution is still acceptable (with much less power consumption).
> 
> Don't know.. running many cpus at lower freq for long duration will
> probably take more power than running them at high freq for short
> duration and making system idle again.
> 
> > We have posted this "RFC" patch mainly for discussion, and I think
> > it fits its purpose :-).
> 
> Yes, no issues with your RFC idea.. its perfect..
> 
> @Vincent: Can you please follow this thread a bit and tell us what
> your views are?
> 
> --
> viresh



-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
