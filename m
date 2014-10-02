Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaJBQ6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:58:10 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40700 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaJBQ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:58:07 -0400
Date: Thu, 2 Oct 2014 17:57:45 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Subject: Re: [PATCH v6 5/6] sched: replace capacity_factor by usage
Message-ID: <20141002165745.GA28662@e103034-lin>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 05:08:04PM +0100, Vincent Guittot wrote:
> Below are two examples to illustrate the problem that this patch solves:
> 
> 1 - capacity_factor makes the assumption that max capacity of a CPU is
> SCHED_CAPACITY_SCALE and the load of a thread is always is
> SCHED_LOAD_SCALE. It compares the output of these figures with the sum
> of nr_running to decide if a group is overloaded or not.
> 
> But if the default capacity of a CPU is less than SCHED_CAPACITY_SCALE
> (640 as an example), a group of 3 CPUS will have a max capacity_factor
> of 2 ( div_round_closest(3x640/1024) = 2) which means that it will be
> seen as overloaded if we have only one task per CPU.

I did some testing on TC2 which has the setup you describe above on the
A7 cluster when the clock-frequency property is set in DT. The two A15s
have max capacities above 1024. When using sysbench with five threads I
still get three tasks on the two A15s and two tasks on the three A7
leaving one cpu idle (on average).

Using cpu utilization (usage) does correctly identify the A15 cluster as
overloaded and it even gets as far as selecting the A15 running two
tasks as the source cpu in load_balance(). However, load_balance() bails
out without pulling the task due to calculate_imbalance() returning a
zero imbalance. calculate_imbalance() bails out just before the hunk you
changed due to comparison of the sched_group avg_loads. sgs->avg_load is
basically the sum of load in the group divided by its capacity. Since
load isn't scaled the avg_load of the overloaded A15 group is slightly
_lower_ than the partially idle A7 group. Hence calculate_imbalance()
bails out, which isn't what we want.

I think we need to have a closer look at the imbalance calculation code
and any other users of sgs->avg_load to get rid of all code making
assumptions about cpu capacity.

Morten
