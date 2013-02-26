Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab3BZUdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 15:33:50 -0500
Received: from [84.200.39.61] ([84.200.39.61]:42904 "EHLO smtp.eikelenboom.it"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758085Ab3BZUdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 15:33:49 -0500
Date: Tue, 26 Feb 2013 21:33:41 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <114314748.20130226213341@eikelenboom.it>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Regression introduced with 14e568e78f6f80ca1e27256641ddf524c7dbdc51 (stop_machine: Use smpboot threads)
In-Reply-To: <alpine.LFD.2.02.1302261843240.22263@ionos>
References: <20130223011800.GA2465@phenom.dumpdata.com> <alpine.LFD.2.02.1302261320120.22263@ionos> <894977724.20130226140702@eikelenboom.it> <alpine.LFD.2.02.1302261843240.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tuesday, February 26, 2013, 6:44:33 PM, you wrote:

> On Tue, 26 Feb 2013, Sander Eikelenboom wrote:
>> Tuesday, February 26, 2013, 1:36:36 PM, you wrote:
>> > On Fri, 22 Feb 2013, Konrad Rzeszutek Wilk wrote:
>> >> 
>> >> I don't know if this is b/c the Xen code is missing something or
>> >> expects something that never happend. I hadn't looked at your
>> >> patch in any detail (was going to do that on Monday).
>> >> 
>> >> Either way, if I boot a HVM guest with PV extensions (aka PVHVM)
>> 
>> Hmm i'm seeing this booting on baremetal as well.
>> (see http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00836.html)

> Ok. I decoded it with the help of Konrad. Does the patch below work
> for you as well?

Did a few reboots and yes it seems to work here as well !
Thx

--
Sander

> Thanks,

>         tglx

> Index: linux-2.6/include/linux/smpboot.h
> ===================================================================
> --- linux-2.6.orig/include/linux/smpboot.h
> +++ linux-2.6/include/linux/smpboot.h
> @@ -24,6 +24,9 @@ struct smpboot_thread_data;
>   *                     parked (cpu offline)
>   * @unpark:            Optional unpark function, called when the thread is
>   *                     unparked (cpu online)
> + * @pre_unpark:                Optional unpark function, called before the thread is
> + *                     unparked (cpu online). This is not guaranteed to be
> + *                     called on the target cpu of the thread. Careful!
>   * @selfparking:       Thread is not parked by the park function.
>   * @thread_comm:       The base name of the thread
>   */
> @@ -37,6 +40,7 @@ struct smp_hotplug_thread {
>         void                            (*cleanup)(unsigned int cpu, bool online);
>         void                            (*park)(unsigned int cpu);
>         void                            (*unpark)(unsigned int cpu);
> +       void                            (*pre_unpark)(unsigned int cpu);
>         bool                            selfparking;
>         const char                      *thread_comm;
>  };
> Index: linux-2.6/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.orig/kernel/smpboot.c
> +++ linux-2.6/kernel/smpboot.c
> @@ -209,6 +209,8 @@ static void smpboot_unpark_thread(struct
>  {
>         struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
>  
+       if (ht->>pre_unpark)
+               ht->>pre_unpark(cpu);
>         kthread_unpark(tsk);
>  }
>  
> Index: linux-2.6/kernel/stop_machine.c
> ===================================================================
> --- linux-2.6.orig/kernel/stop_machine.c
> +++ linux-2.6/kernel/stop_machine.c
> @@ -336,7 +336,7 @@ static struct smp_hotplug_thread cpu_sto
>         .create                 = cpu_stop_create,
>         .setup                  = cpu_stop_unpark,
>         .park                   = cpu_stop_park,
> -       .unpark                 = cpu_stop_unpark,
> +       .pre_unpark             = cpu_stop_unpark,
>         .selfparking            = true,
>  };
>  


