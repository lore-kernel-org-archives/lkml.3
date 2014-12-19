Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaLSOv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:51:28 -0500
Received: from service87.mimecast.com ([91.220.42.44]:41242 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaLSOv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:51:27 -0500
Message-ID: <54943B6A.9050309@arm.com>
Date: Fri, 19 Dec 2014 15:51:22 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Michael Turquette <mturquette@deferred.io>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [sched] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1439
 warn_pre_alternatives()
References: <20141210232645.GD24163@wfg-t540p.sh.intel.com>
In-Reply-To: <20141210232645.GD24163@wfg-t540p.sh.intel.com>
X-OriginalArrivalTime: 19 Dec 2014 14:51:24.0268 (UTC) FILETIME=[427662C0:01D01B9B]
X-MC-Unique: 114121914512405301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

On 11/12/14 00:26, Fengguang Wu wrote:
> Hi Dietmar,
>
> FYI, here is another bisect result.

thanks for testing this on another arch then ARM!

The problem is that the weak arch_scale_cpu_capacity calls 
default_scale_cpu_capacity on a system which doesn't overwrite it and 
the default one accesses the sched_domain which is not allocated that 
early when called by scheduler_tick.

I only tested it on an ARM system which in this tree which overwrites 
arch_scale_cpu_capacity and does not access sched_domain.

Have to look into it and will test the default case from now on too.

-- Dietmar

>
> https://git.linaro.org/people/mturquette/linux.git eas-next
> commit 1fadb581b0be9420b143e43ff2f4a07ea7e45f6c
> Author:     Dietmar Eggemann <dietmar.eggemann@arm.com>
> AuthorDate: Tue Dec 2 14:06:24 2014 +0000
> Commit:     Michael Turquette <mturquette@deferred.io>
> CommitDate: Tue Dec 9 20:33:17 2014 -0800
>
>      sched: Make usage and load tracking cpu scale-invariant
>
>      Besides the existing frequency scale-invariance correction factor, apply
>      cpu scale-invariance correction factor to usage and load tracking.
>
>      Cpu scale-invariance takes cpu performance deviations due to
>      micro-architectural differences (i.e. instructions per seconds) between
>      cpus in HMP systems (e.g. big.LITTLE) and differences in the frequency
>      value of the highest OPP between cpus in SMP systems into consideration.
>
>      Each segment of the sched_avg::{running_avg_sum, runnable_avg_sum}
>      geometric series is now scaled by the cpu performance factor too so the
>      sched_avg::{utilization_avg_contrib, load_avg_contrib} of each entity will
>      be invariant from the particular cpu of the HMP/SMP system it is gathered
>      on. As a result, cfs_rq::runnable_load_avg which is the sum of
>      sched_avg::load_avg_contrib, becomes cpu scale-invariant too.
>
>      So the {usage, load} level that is returned by {get_cpu_usage,
>      weighted_cpuload} stays relative to the max cpu performance of the system.
>
>      Cc: Ingo Molnar <mingo@redhat.com>
>      Cc: Peter Zijlstra <peterz@infradead.org>
>      Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
>

[...]


