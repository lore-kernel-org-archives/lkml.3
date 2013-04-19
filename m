Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846Ab3DSV2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:28:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11591 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3DSV2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:28:35 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=xMd4g64WzYcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=pb6FowBv3goA:10 a=D19gQVrFAAAA:8 a=KKAkSRfTAAAA:8 a=cBnNOBedu-PNHW35_VsA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=WwgC8nHKvroA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366406913.9609.124.camel@gandalf.local.home>
Subject: Re: [PATCH Resend v6] sched: fix wrong rq's runnable_avg update
 with rt tasks
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, pjt@google.com,
        fweisbec@gmail.com, efault@gmx.de
Date: Fri, 19 Apr 2013 17:28:33 -0400
In-Reply-To: <1366302867-5055-1-git-send-email-vincent.guittot@linaro.org>
References: <1366302867-5055-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-18 at 18:34 +0200, Vincent Guittot wrote:
> The current update of the rq's load can be erroneous when RT tasks are
> involved
> 
> The update of the load of a rq that becomes idle, is done only if the avg_idle
> is less than sysctl_sched_migration_cost. If RT tasks and short idle duration
> alternate, the runnable_avg will not be updated correctly and the time will be
> accounted as idle time when a CFS task wakes up.
> 
> A new idle_enter function is called when the next task is the idle function
> so the elapsed time will be accounted as run time in the load of the rq,
> whatever the average idle time is. The function update_rq_runnable_avg is
> removed from idle_balance.
> 
> When a RT task is scheduled on an idle CPU, the update of the rq's load is
> not done when the rq exit idle state because CFS's functions are not
> called. Then, the idle_balance, which is called just before entering the
> idle function, updates the rq's load and makes the assumption that the
> elapsed time since the last update, was only running time.
> 
> As a consequence, the rq's load of a CPU that only runs a periodic RT task,
> is close to LOAD_AVG_MAX whatever the running duration of the RT task is.
> 
> A new idle_exit function is called when the prev task is the idle function
> so the elapsed time will be accounted as idle time in the rq's load.
> 
> Changes since V5:
> - Rename idle_enter/exit function to idle_enter/exit_fair
> 
> Changes since V4:
> - Rebase on v3.9-rc6 instead of Steven Rostedt's patches

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> - Create the post_schedule_idle function that was previously created by Steven's patches
> 
> Changes since V3:
> - Remove dependancy with CONFIG_FAIR_GROUP_SCHED
> - Add a new idle_enter function and create a post_schedule callback for
>  idle class
> - Remove the update_runnable_avg from idle_balance
> 
> Changes since V2:
> - remove useless definition for UP platform
> - rebased on top of Steven Rostedt's patches :
> https://lkml.org/lkml/2013/2/12/558
> 
> Changes since V1:
> - move code out of schedule function and create a pre_schedule callback for
>   idle class instead.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---


