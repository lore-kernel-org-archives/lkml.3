Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaDODz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:55:59 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37725 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaDODz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:55:58 -0400
MIME-Version: 1.0
In-Reply-To: <534C3C65.1030808@codeaurora.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
	<74d448a200afd0424fb185e2fb2ac5c31fd6b205.1397492345.git.viresh.kumar@linaro.org>
	<534C3C65.1030808@codeaurora.org>
Date: Tue, 15 Apr 2014 09:25:57 +0530
Message-ID: <CAKohpomY1Hi2j73=BZ1bRYPJH67J6h+fBJbj5vvcHu1O31rKRA@mail.gmail.com>
Subject: Re: [PATCH 22/38] tick-sched: no need to recheck cpu_online() in can_stop_idle_tick()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 01:22, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 04/14/14 09:23, Viresh Kumar wrote:
>> We have already checked if 'cpu' is online or not and so don't need to recheck
>> it.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Hm... doing some git archeology shows fa116ea35ec7 (nohz: no softirq
> pending warnings for offline cpus, 2008-12-11), where the cpu_online()
> check was added. Before that commit we already checked cpu_online()
> similar to how the code is today. Perhaps we need to add a comment here?

Okay, I didn't understood what you want completely. You want me to update
commit logs or drop this patch and update code?

But yes there is one more thing worth mentioning:

commit f7ea0fd6 (tick: Don't invoke tick_nohz_stop_sched_tick() if the cpu is
offline, May 13 2013), which did this:

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0eed1db..0121421 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -469,6 +469,7 @@ static bool can_stop_idle_tick(int cpu, struct
tick_sched *ts)
        if (unlikely(!cpu_online(cpu))) {
                if (cpu == tick_do_timer_cpu)
                        tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+               return false;
        }

        if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))


So, when the patch you mentioned was added, we didn't had this and a
recheck of cpu_online() was perhaps required. But it is surely not required
anymore.
