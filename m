Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaCLW2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:28:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:3759 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbaCLW2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:28:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,641,1389772800"; 
   d="scan'208";a="471236520"
Date: Wed, 12 Mar 2014 15:27:39 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: Re: [PATCH v3 32/52] powercap, intel-rapl: Fix CPU hotplug callback
 registration
Message-ID: <20140312152739.12311e48@ultegra>
In-Reply-To: <20140310203926.10746.11524.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
	<20140310203926.10746.11524.stgit@srivatsabhat.in.ibm.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 02:09:26 +0530
"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> Subsystems that want to register CPU hotplug callbacks, as well as
> perform initialization for the CPUs that are already online, often do
> it as shown below:
> 
> 	get_online_cpus();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	put_online_cpus();
> 
> This is wrong, since it is prone to ABBA deadlocks involving the
> cpu_add_remove_lock and the cpu_hotplug.lock (when running
> concurrently with CPU hotplug operations).
> 
> Instead, the correct and race-free way of performing the callback
> registration is:
> 
> 	cpu_notifier_register_begin();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	/* Note the use of the double underscored version of the API
> */ __register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	cpu_notifier_register_done();
> 
> 
> Fix the intel-rapl code in the powercap driver by using this latter
> form of callback registration. But retain the calls to
> get/put_online_cpus(), since they also protect the function
> rapl_cleanup_data(). By nesting get/put_online_cpus() *inside*
> cpu_notifier_register_begin/done(), we avoid the ABBA deadlock
> possibility mentioned above.
> 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 

Tested-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

>  drivers/powercap/intel_rapl.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/powercap/intel_rapl.c
> b/drivers/powercap/intel_rapl.c index 3c67683..d6c74c1 100644
> --- a/drivers/powercap/intel_rapl.c
> +++ b/drivers/powercap/intel_rapl.c
> @@ -1369,6 +1369,9 @@ static int __init rapl_init(void)
>  
>  		return -ENODEV;
>  	}
> +
> +	cpu_notifier_register_begin();
> +
>  	/* prevent CPU hotplug during detection */
>  	get_online_cpus();
>  	ret = rapl_detect_topology();
> @@ -1380,20 +1383,23 @@ static int __init rapl_init(void)
>  		ret = -ENODEV;
>  		goto done;
>  	}
> -	register_hotcpu_notifier(&rapl_cpu_notifier);
> +	__register_hotcpu_notifier(&rapl_cpu_notifier);
>  done:
>  	put_online_cpus();
> +	cpu_notifier_register_done();
>  
>  	return ret;
>  }
>  
>  static void __exit rapl_exit(void)
>  {
> +	cpu_notifier_register_begin();
>  	get_online_cpus();
> -	unregister_hotcpu_notifier(&rapl_cpu_notifier);
> +	__unregister_hotcpu_notifier(&rapl_cpu_notifier);
>  	rapl_unregister_powercap();
>  	rapl_cleanup_data();
>  	put_online_cpus();
> +	cpu_notifier_register_done();
>  }
>  
>  module_init(rapl_init);
> 

[Jacob Pan]
