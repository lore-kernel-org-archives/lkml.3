Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbaHAVyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 17:54:35 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37070 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbaHAVyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 17:54:33 -0400
Date: Fri, 1 Aug 2014 14:54:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        stable@kernel.org
Subject: Re: [PATCH] smpboot: add missing get_online_cpus() when register
In-Reply-To: <1406777421-12830-1-git-send-email-laijs@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1408011448220.11532@chino.kir.corp.google.com>
References: <1406777421-12830-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Lai Jiangshan wrote:

> If the smpboot_register_percpu_thread() is called after smpboot_create_threads()
> but before __cpu_up(), the smpboot thread of the online-ing CPU is not created,
> and it results a bug.  So we use get_online_cpus() to prevent it.
> 

Do you have an example of the bug to include?  Maintainers are going to 
need to understand the implications of the problem before the 
stable@kernel.org annotation is warranted.

> smpboot_unregister_percpu_thread() travels all possible CPU, it doesn't need
> get_online_cpus() which is removed in the patch.
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> CC: stable@kernel.org
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/smpboot.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/smpboot.c b/kernel/smpboot.c
> index eb89e18..8adab87 100644
> --- a/kernel/smpboot.c
> +++ b/kernel/smpboot.c
> @@ -279,6 +279,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
>  	unsigned int cpu;
>  	int ret = 0;
>  
> +	get_online_cpus();
>  	mutex_lock(&smpboot_threads_lock);
>  	for_each_online_cpu(cpu) {
>  		ret = __smpboot_create_thread(plug_thread, cpu);
> @@ -291,6 +292,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
>  	list_add(&plug_thread->list, &hotplug_threads);
>  out:
>  	mutex_unlock(&smpboot_threads_lock);
> +	put_online_cpus();
>  	return ret;
>  }

I think the {get,put}_online_cpus() pair should be nested inside the 
smpboot_threads_lock for better lock ordering since not all cases 
smpboot_threads_lock will require it.

That way, you can also do put_online_cpus() before 
smpboot_destroy_threads(), which you have already proven doesn't need it:

@@ -280,14 +280,17 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
 	int ret = 0;
 
 	mutex_lock(&smpboot_threads_lock);
+	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		ret = __smpboot_create_thread(plug_thread, cpu);
 		if (ret) {
+			put_online_cpus();
 			smpboot_destroy_threads(plug_thread);
 			goto out;
 		}
 		smpboot_unpark_thread(plug_thread, cpu);
 	}
+	put_online_cpus();
 	list_add(&plug_thread->list, &hotplug_threads);
 out:
 	mutex_unlock(&smpboot_threads_lock);

>  EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
> @@ -303,11 +305,9 @@ EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
>   */
>  void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread)
>  {
> -	get_online_cpus();
>  	mutex_lock(&smpboot_threads_lock);
>  	list_del(&plug_thread->list);
>  	smpboot_destroy_threads(plug_thread);
>  	mutex_unlock(&smpboot_threads_lock);
> -	put_online_cpus();
>  }
>  EXPORT_SYMBOL_GPL(smpboot_unregister_percpu_thread);

This makes sense.
