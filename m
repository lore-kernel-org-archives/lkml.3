Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbaFZLIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:08:22 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:59256 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaFZLIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:08:20 -0400
Date: Thu, 26 Jun 2014 16:38:11 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, tkhai@yandex.ru,
        Mike Galbraith <umgwanakikbuti@gmail.com>, khorenko@parallels.com,
        Ben Segall <bsegall@google.com>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v2 1/3] sched/fair: Disable runtime_enabled on dying rq
Message-ID: <20140626110811.GA20048@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140624074148.8738.57690.stgit@tkhai>
 <1403596432.3462.26.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1403596432.3462.26.camel@tkhai>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062611-8256-0000-0000-00000E0B0FA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill Tkhai <ktkhai@parallels.com> [2014-06-24 11:53:52]:

> We kill rq->rd on the CPU_DOWN_PREPARE stage:
> 
> 	cpuset_cpu_inactive -> cpuset_update_active_cpus -> partition_sched_domains ->
> 	-> cpu_attach_domain -> rq_attach_root -> set_rq_offline
> 
> This unthrottles all throttled cfs_rqs.
> 
> But the cpu is still able to call schedule() till
> 
> 	take_cpu_down->__cpu_disable()
> 
> is called from stop_machine.
> 
> This case the tasks from just unthrottled cfs_rqs are pickable
> in a standard scheduler way, and they are picked by dying cpu.
> The cfs_rqs becomes throttled again, and migrate_tasks()
> in migration_call skips their tasks (one more unthrottle
> in migrate_tasks()->CPU_DYING does not happen, because rq->rd
> is already NULL).
> 
> Patch sets runtime_enabled to zero. This guarantees, the runtime
> is not accounted, and the cfs_rqs won't exceed given
> cfs_rq->runtime_remaining = 1, and tasks will be pickable
> in migrate_tasks(). runtime_enabled is recalculated again
> when rq becomes online again.
> 
> Ben Segall also noticed, we always enable runtime in
> tg_set_cfs_bandwidth(). Actually, we should do that for online
> cpus only. To fix that, we check if a cpu is online when
> its rq is locked. This guarantees we do not have races with
> set_rq_offline(), which also requires rq->lock.
> 
> v2: Fix race with tg_set_cfs_bandwidth().
>     Move cfs_rq->runtime_enabled=0 above unthrottle_cfs_rq().
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> CC: Konstantin Khorenko <khorenko@parallels.com>
> CC: Ben Segall <bsegall@google.com>
> CC: Paul Turner <pjt@google.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Mike Galbraith <umgwanakikbuti@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>

looks good to me.

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

