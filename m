Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965434AbaLLIqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:46:49 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:39337 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351AbaLLIqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:46:47 -0500
Date: Fri, 12 Dec 2014 09:46:36 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v4] CPU hotplug: active_writer not woken up in some
 cases - deadlock
Message-ID: <20141212094636.754ab1f8@thinkpad-w530>
In-Reply-To: <20141210175055.GA11802@redhat.com>
References: <1418217721-42919-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141210175055.GA11802@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121208-0009-0000-0000-0000025A682A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This is subjective, but how about
> 
> 	static bool xxx(void)
> 	{
> 		mutex_lock(&cpu_hotplug.lock);
> 		if (atomic_read(&cpu_hotplug.refcount) == 0)
> 			return true;
> 		mutex_unlock(&cpu_hotplug.lock);
> 		return false;
> 	}
> 
> 	void cpu_hotplug_begin(void)
> 	{
> 		cpu_hotplug.active_writer = current;
> 
> 		cpuhp_lock_acquire();
> 		wait_event(&cpu_hotplug.wq, xxx());
> 	}
> 
> instead?
> 
> Oleg.
> 

[   50.662459] do not call blocking ops when !TASK_RUNNING; state=2 set at [<000000000017340e>] prepare_to_wait_event+0x7a/0x124
[   50.662472] ------------[ cut here ]------------
[   50.662475] WARNING: at kernel/sched/core.c:7301
[   50.662477] Modules linked in:
[   50.662482] CPU: 5 PID: 225 Comm: cpu_start_stop. Not tainted 3.18.0+ #59
[   50.662485] task: 0000000001f94b20 ti: 0000000001ffc000 task.ti: 0000000001ffc000
...

Looks like your suggestion won't work. We can only set the task to
TASK_UNINTERRUPTIBLE after taking the lock.

David

