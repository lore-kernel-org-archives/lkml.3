Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaAGOLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:11:48 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61181 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAGOLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:11:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140107132220.GZ31570@twins.programming.kicks-ass.net>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
 <52B87149.4010801@arm.com> <CAKfTPtDmb1fa8PUcrqEGaoQLxoPBddu-Yn_oS8KwsCJJWJzQug@mail.gmail.com>
 <20140106163123.GN31570@twins.programming.kicks-ass.net> <CAKfTPtDind8HGJwu0odSnNdRpaxp3VB3JWw3eADAp4bL4Ex-Mw@mail.gmail.com>
 <20140107132220.GZ31570@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 7 Jan 2014 15:11:22 +0100
Message-ID: <CAKfTPtCE3gy_656EfcrfjZ-15CTxAqk91O6qR1Jz3BCABvDNCg@mail.gmail.com>
Subject: Re: [RFC] sched: CPU topology try
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 January 2014 14:22, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jan 07, 2014 at 09:32:04AM +0100, Vincent Guittot wrote:
>> On 6 January 2014 17:31, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, Jan 06, 2014 at 02:41:31PM +0100, Vincent Guittot wrote:
>> >> IMHO, these settings will disappear sooner or later, as an example the
>> >> idle/busy _idx are going to be removed by Alex's patch.
>> >
>> > Well I'm still entirely unconvinced by them..
>> >
>> > removing the cpu_load array makes sense, but I'm starting to doubt the
>> > removal of the _idx things.. I think we want to retain them in some
>> > form, it simply makes sense to look at longer term averages when looking
>> > at larger CPU groups.
>> >
>> > So maybe we can express the things in log_2(group-span) or so, but we
>> > need a working replacement for the cpu_load array. Ideally some
>> > expression involving the blocked load.
>>
>> Using the blocked load can surely give benefit in the load balance
>> because it gives a view of potential load on a core but it still decay
>> with the same speed than runnable load average so it doesn't solve the
>> issue for longer term average. One way is to have a runnable average
>> load with longer time window
>
> Ah, another way of looking at it is that the avg without blocked
> component is a 'now' picture. It is the load we are concerned with right
> now.
>
> The more blocked we add the further out we look; with the obvious limit
> of the entire averaging period.
>
> So the avg that is runnable is right now, t_0; the avg that is runnable +
> blocked is t_0 + p, where p is the avg period over which we expect the
> blocked contribution to appear.
>
> So something like:
>
>   avg = runnable + p(i) * blocked; where p(i) \e [0,1]
>
> could maybe be used to replace the cpu_load array and still represent
> the concept of looking at a bigger picture for larger sets. Leaving open
> the details of the map p.

That needs to be studied more deeply but that could be a way to have a
larger picture

Another point is that we are using runnable and blocked load average
which are the sum of load_avg_contrib of tasks but we are not using
the runnable_avg_sum of the cpus which is not the now picture but a
average of the past running time (without taking into account task
weight)

Vincent
