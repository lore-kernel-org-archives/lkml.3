Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbaBCIT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:19:28 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:49328 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaBCIT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:19:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAM4v1pPnHuSKX9UAjnqzappThKS0a6_6-PEqpiiCPpjQ_3anQQ@mail.gmail.com>
References: <CALZhoSQZQcM0yKTw1=ZkYz3Z_3X2QxLk0vCw6gKXW55HSrVEdw@mail.gmail.com>
	<alpine.DEB.2.02.1401221459590.4260@ionos.tec.linutronix.de>
	<CALZhoSSSOZKwDok2ZHumeZAs0R88SC6bU2BaL54U3TU6jgoaZA@mail.gmail.com>
	<CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
	<CAM4v1pPnHuSKX9UAjnqzappThKS0a6_6-PEqpiiCPpjQ_3anQQ@mail.gmail.com>
Date: Mon, 3 Feb 2014 13:49:26 +0530
Message-ID: <CAKohpo=qQJwgDpzJMtk-PN6PBB_1KsSXZ_tYrVLOz_9Qzs=gsA@mail.gmail.com>
Subject: Re: Is it ok for deferrable timer wakeup the idle cpu?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Lei Wen <adrian.wenl@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 January 2014 10:57, Preeti Murthy <preeti.lkml@gmail.com> wrote:
> How about simplifying this design by doing the below?
>
> 1. Since anyway cpufreq governors monitor load on the cpu once every
> 5ms, *tie it with tick_sched_timer*, which also gets deferred when the cpu
> enters nohz_idle.

Its configurable. We can change sampling time to whatever we want. Some
might be selecting it as 30 ms.

> 2. To overcome the problem of running this job of monitoring the load
> on every cpu, have the *time keeping* cpu do it for you.
>
> The time keeping cpu has the property that if it has to go to idle, it will do
> so and let the next cpu that runs the periodic timer become the time keeper.
> Hence no cpu is prevented from entering nohz_idle and the cpu that is busy
> and first executes periodic timer will take over as the time keeper.
>
> The result would be:
>
> 1. One cpu at any point in time will be monitoring cpu load, at every sched tick
> as long as its busy. If it goes to sleep, then it gives up this duty
> and enters idle.
> The next cpu that runs the periodic timer becomes the cpu to monitor the load
> and will continue to do so as long as its busy. Hence we do not miss monitoring
> the cpu load.
>
> 2. This will avoid an additional timer for cpufreq.
>
> 3. It avoids sending IPIs each time this timer gets modified since there is just
> one CPU doing the monitoring.
>
> 4. The downside to this could be that we are stretching the functions of the
>  periodic timer into the power management domain which does not seem like
> the right thing to do.

Looks good, but AFAIK timerkeeper is still to be implemented? Also the best
solution is to get rid of this timer completely by getting inputs from
scheduler.
Probably some ARM/Linaro folks are working on it.
