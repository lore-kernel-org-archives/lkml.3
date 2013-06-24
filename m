Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3FXRzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:55:46 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:36196 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3FXRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:55:43 -0400
Date: Mon, 24 Jun 2013 10:55:35 -0700
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 22/45] percpu_counter: Use get/put_online_cpus_atomic()
 to prevent CPU offline
Message-ID: <20130624175535.GA1918@mtj.dyndns.org>
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com>
 <20130623134256.19094.99231.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623134256.19094.99231.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 07:12:59PM +0530, Srivatsa S. Bhat wrote:
> Once stop_machine() is gone from the CPU offline path, we won't be able
> to depend on disabling preemption to prevent CPUs from going offline
> from under us.
> 
> Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going
> offline, while invoking from atomic context.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
...
> @@ -98,6 +98,7 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
>  	s64 ret;
>  	int cpu;
>  
> +	get_online_cpus_atomic();
>  	raw_spin_lock(&fbc->lock);
>  	ret = fbc->count;
>  	for_each_online_cpu(cpu) {
> @@ -105,6 +106,7 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
>  		ret += *pcount;
>  	}
>  	raw_spin_unlock(&fbc->lock);
> +	put_online_cpus_atomic();

I don't think this is necessary.  CPU on/offlining is explicitly
handled via the hotplug callback which synchronizes through fbc->lock.
__percpu_counter_sum() racing with actual on/offlining doesn't affect
correctness and adding superflous get_online_cpus_atomic() around it
can be misleading.

Thanks.

-- 
tejun
