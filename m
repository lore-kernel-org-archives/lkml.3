Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaHLSLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:11:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:40601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaHLSLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:11:05 -0400
Message-ID: <53EA58B4.8050307@infradead.org>
Date: Tue, 12 Aug 2014 11:11:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, peterz@infradead.org
CC: luca.abeni@unitn.it, mingo@redhat.com, henrik@austad.us, raistlin@linux.it,
        juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Documentation/scheduler/sched-deadline.txt: improve
 and clarify AC bits
References: <1407858555-14371-1-git-send-email-juri.lelli@arm.com> <1407858555-14371-4-git-send-email-juri.lelli@arm.com>
In-Reply-To: <1407858555-14371-4-git-send-email-juri.lelli@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 08:49, Juri Lelli wrote:
> From: Luca Abeni <luca.abeni@unitn.it>
> 
> Admission control is of key importance for SCHED_DEADLINE, since it guarantees
> system schedulability (or tells us something about the degree of guarantees
> we can provide to the user).
> 
> This patch improves and clarifies bits and pieces regarding AC, both for UP
> and SMP systems.
> 
> Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
> Signed-off-by: Juri Lelli <juri.lelli@arm.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Henrik Austad <henrik@austad.us>
> Cc: Dario Faggioli <raistlin@linux.it>
> Cc: Juri Lelli <juri.lelli@gmail.com>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/scheduler/sched-deadline.txt |   87 +++++++++++++++++++++++-----
>  1 file changed, 73 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
> index 4acba51..d056034 100644
> --- a/Documentation/scheduler/sched-deadline.txt
> +++ b/Documentation/scheduler/sched-deadline.txt

> @@ -134,6 +135,48 @@ CONTENTS
>   A real-time task can be periodic with period P if r_{j+1} = r_j + P, or
>   sporadic with minimum inter-arrival time P is r_{j+1} >= r_j + P. Finally,
>   d_j = r_j + D, where D is the task's relative deadline.
> + The utilisation of a real-time task is defined as the ratio between its
> + wcet and its period (or minimum inter-arrival time), and represents

   "wcet" seems to be used here without any explanation of what it means.

> + the fraction of CPU time needed to execute the task.
> +
> + If the total utilisation sum_i(WCET_i/P_i) (sum of the utilisations
> + WCET_i/P_i of all the tasks in the system - notice that when considering
> + multiple tasks, the parameters of the i-th one are indicated with the "_i"
> + suffix) is larger than M (with M equal to the number of CPUs), then the
> + system will surely not be able to respect all of the deadlines, and no
> + execution time is guaranteed for non real-time tasks, which risk to be
> + starved by real-time tasks.
> + If, instead, the total utilisation is smaller than M, then non real-time
> + tasks will not be starved and the system might be able to respect all the
> + deadlines.
> + As a matter of fact, in this case it is possible to provide an upper bound
> + for the tardiness (defined as the maximum between 0 and the difference
> + between the finishing time of a job and its absolute deadline).
> + More precisely, it can be proved that using a global EDF scheduler the
> + maximum tardiness of each task is smaller or equal than
> +	((M − 1) · WCET_max − WCET_min)/(M − (M − 2) · U_max) + WCET_max
> + where WCET_max = max_i{WCET_i} is the maximum WCET, WCET_min=min_i{WCET_i}
> + is the minimum WCET, and U_max = max_i{WCET_i/P_i} is the maximum utilisation.
> +
> + If M=1 (uniprocessor system), or in case of partitioned scheduling (each
> + real-time task is statically assigned to one and only one CPU), then it is
> + possible to formally check if all the deadlines are respected.
> + If D_i = P_i for all tasks, then EDF is able to respect all the deadlines
> + of all the tasks executing on a CPU if and only if the total utilisation
> + of the tasks running on such a CPU is smaller or equal than 1.
> + If D_i != P_i for some task, then it is possible to define the density of
> + a task as C_i/min{D_i,T_i}, and EDF is able to respect all of the deadlines
> + of all the tasks running on a CPU if the sum sum_i C_i/min{D_i,T_i} of the
> + densities of the tasks running on such a CPU is smaller or equal than 1
> + (notice that this condition is only sufficient, and not necessary).
> +
> + On multiprocessor systems with global EDF scheduling (non partitioned
> + systems), a sufficient test for schedulability can not be based on the

                                                   cannot

> + utilisations (it can be shown that task sets with utilisations slightly
> + larger than 1 can miss deadlines regardless of the number of CPUs M).
> + However, as previously stated enforcing that the total utilisation is smaller
> + than M is enough to guarantee that non real-time tasks are not starved and
> + the real-time tasks tardiness has an upper bound.
>  
>   SCHED_DEADLINE can be used to schedule real-time tasks guaranteeing that
>   the jobs' deadlines of a task are respected. In order to do this, a task



-- 
~Randy
