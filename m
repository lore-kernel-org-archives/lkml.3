Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbaDLKrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 06:47:00 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:59416 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753910AbaDLKq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:46:59 -0400
X-IronPort-AV: E=Sophos;i="4.97,847,1389715200"; 
   d="scan'208";a="29177032"
Message-ID: <53491A85.70004@cn.fujitsu.com>
Date: Sat, 12 Apr 2014 18:50:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] workqueue: simpler&better workers management synchronization
References: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry,
the cover letter was forgotten to send to LKML.

On 04/12/2014 06:45 PM, Lai Jiangshan wrote:
> Each patches remove codes!
> 
> Patch1&2 are the basic patches. They add a *united* mechanism for managing
> percpu pools' workers' & unbound pools' workers' & rescuers' CPUMASK.
> 
> Patch1&4 make workers-concurrency-enabling atomically when cpu_online()
> and create_worker(). after this, workers-concurrency-enabling-disabling
> are all atomically.
> 
> Old manager_mutex protects:
> 1) workers creation&destruction
> 2) workers cpumask managing when cpu_online()/workers-creation
> 3) workers concurrency enabling&disabling.
> 
> Now, the above three things' synchronization are separated.
> 1) We don't need manager_mutex protects workers creation&destruction
>    1.1) creation is only happened when the cpu is first online, the unbound pool
> 	is just created, and manage_workers(). they have their one synchronization.
>    1.2) destruction only happens on idle-timeout handler, protected by pool->lock.
>    1.3) put_unbound_pool() uses manager_arb&workers_leave(new) to synchronize
> 	with workers creation&destruction.
> 
> 2) bind_mutex and bind_list handle all the workers'(percpu,unbound,
>    normal,rescuer) cpumask when cpu_online()/workers-creation/worker-destrution.
>    we don't need manager_mutex.
> 
> 3) pool->lock and worker_idr handle workers concurrency enabling&disabling.
> 
> Note, bind_list is always a super set of worker_idr, and when cpu-online or
> workers-creation, cpumask is set at first and then concurrency-enabling.
> concurrency-management depends on local-wakeup which depends on cpumask
> is properly set for all the workers.
> 
> This patchset depends on previous patch:
> "workqueue: fix possible race condition when rescuer VS pwq-release"
> 
> Thanks,
> Lai
> 
> 
> Lai Jiangshan (6):
>   workqueue: generic routine to restore percpu/unbound pools' workers'
>     cpumask
>   workqueue: generic framework to manage normal&rescuer workers'
>     cpumask
>   workqueue: make destroy_worker() atomically
>   workqueue: commit worker to pool's concurrency setting atomically.
>   workqueue: remove manager_mutex
>   workqueue: destroy worker directly in idle timeout handler
> 
>  kernel/workqueue.c          |  366 ++++++++++++------------------------------
>  kernel/workqueue_internal.h |    1 +
>  2 files changed, 106 insertions(+), 261 deletions(-)
> 

