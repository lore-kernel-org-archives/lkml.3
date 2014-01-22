Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaAVUDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:03:12 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:37192 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbaAVUDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:03:10 -0500
Message-ID: <52E022C8.4060902@linux.vnet.ibm.com>
Date: Thu, 23 Jan 2014 01:28:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        Michel Lespinasse <walken@google.com>, ego@linux.vnet.ibm.com,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: Deadlock between cpu_hotplug_begin and cpu_add_remove_lock
References: <20140122055239.GA29418@iris.ozlabs.ibm.com> <52DF81B0.7020700@linux.vnet.ibm.com> <52DF8C59.1090702@linux.vnet.ibm.com> <20140122191820.GA32127@redhat.com>
In-Reply-To: <20140122191820.GA32127@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012220-4790-0000-0000-00000C5B8A66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 12:48 AM, Oleg Nesterov wrote:
> On 01/22, Srivatsa S. Bhat wrote:
>>
>> Wait a min, that _will_ actually work for all cases because I have provided
>> an option to invoke _any_ arbitrary function as the "setup" routine.
> 
> And probably the generic solution makes sense. I am not sure I actually
> understand the semantics of register_allcpu_notifier(), but the problem
> it tries to solve looks clear/valid.
>

Thank you. But I was wondering whether its usage is a bit unintuitive/
convoluted. So I was contemplating between going with that solution or the
below one, where the call-sites are expected to do:

cpu_maps_update_begin();
for_each_online_cpu(cpu) {
	...
}
__register_cpu_notifier(); //use the __reg() variant, which doesn't take locks
cpu_maps_update_done();

Of course, that requires exporting the functions cpu_maps_update_begin/done(),
but this latter form of callback registration might look more natural.

diff --git a/kernel/cpu.c b/kernel/cpu.c
index deff2e6..37373c1 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -166,6 +166,11 @@ int __ref register_cpu_notifier(struct notifier_block *nb)
        return ret;
 }
 
+int __ref __register_cpu_notifier(struct notifier_block *nb)
+{
+       return raw_notifier_chain_register(&cpu_chain, nb);
+}
+
 static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
                        int *nr_calls)
 {
@@ -189,6 +194,7 @@ static void cpu_notify_nofail(unsigned long val, void *v)
        BUG_ON(cpu_notify(val, v));
 }
 EXPORT_SYMBOL(register_cpu_notifier);
+EXPORT_SYMBOL(__register_cpu_notifier);
 
 void __ref unregister_cpu_notifier(struct notifier_block *nb)
 {
@@ -198,6 +204,12 @@ void __ref unregister_cpu_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_cpu_notifier);
 
+void __ref __unregister_cpu_notifier(struct notifier_block *nb)
+{
+       raw_notifier_chain_unregister(&cpu_chain, nb);
+}
+EXPORT_SYMBOL(__unregister_cpu_notifier);
+
 /**
  * clear_tasks_mm_cpumask - Safely clear tasks' mm_cpumask for a CPU
  * @cpu: a CPU id

 
> But as for a quick fix for raid5_alloc_percpu(), can't it simply call
> register_cpu_notifier() before get_online_cpus/for_each_present_cpu ?
> 
> This probably means that raid456_cpu_notify() should be modified because
> it obviously can be called before get_online_cpus(). Hmm, it already
> has safe_put_page(), so this looks really simple? Something like below,
> although of course I can miss easily something.

Yes, your solution for raid5 does look good; it is also simple and
elegant. But for some of the other call-sites, we might have to use one
of the solutions mentioned above.

Regards,
Srivatsa S. Bhat

> 
> 
> --- x/drivers/md/raid5.c
> +++ x/drivers/md/raid5.c
> @@ -5542,6 +5542,24 @@ static void free_conf(struct r5conf *con
>  	kfree(conf);
>  }
> 
> +static int alloc_xxx(struct r5conf *conf, struct raid5_percpu *percpu)
> +{
> +	if (conf->level == 6 && !percpu->spare_page)
> +		percpu->spare_page = alloc_page(GFP_KERNEL);
> +	if (!percpu->scribble)
> +		percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
> +
> +	if (!percpu->scribble || (conf->level == 6 && !percpu->spare_page)) {
> +		safe_put_page(percpu->spare_page);
> +		kfree(percpu->scribble);
> +		pr_err("%s: failed memory allocation for cpu%ld\n",
> +		       __func__, cpu);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
>  #ifdef CONFIG_HOTPLUG_CPU
>  static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
>  			      void *hcpu)
> @@ -5553,19 +5571,8 @@ static int raid456_cpu_notify(struct not
>  	switch (action) {
>  	case CPU_UP_PREPARE:
>  	case CPU_UP_PREPARE_FROZEN:
> -		if (conf->level == 6 && !percpu->spare_page)
> -			percpu->spare_page = alloc_page(GFP_KERNEL);
> -		if (!percpu->scribble)
> -			percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
> -
> -		if (!percpu->scribble ||
> -		    (conf->level == 6 && !percpu->spare_page)) {
> -			safe_put_page(percpu->spare_page);
> -			kfree(percpu->scribble);
> -			pr_err("%s: failed memory allocation for cpu%ld\n",
> -			       __func__, cpu);
> +		if (alloc_xxx(conf, percpu))
>  			return notifier_from_errno(-ENOMEM);
> -		}
>  		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> @@ -5585,39 +5592,27 @@ static int raid5_alloc_percpu(struct r5c
>  {
>  	unsigned long cpu;
>  	struct page *spare_page;
> -	struct raid5_percpu __percpu *allcpus;
>  	void *scribble;
> -	int err;
> +	int err = 0;
> 
> -	allcpus = alloc_percpu(struct raid5_percpu);
> -	if (!allcpus)
> +	conf->percpu = alloc_percpu(struct raid5_percpu);
> +	if (!conf->percpu)
>  		return -ENOMEM;
> -	conf->percpu = allcpus;
> 
> -	get_online_cpus();
> -	err = 0;
> -	for_each_present_cpu(cpu) {
> -		if (conf->level == 6) {
> -			spare_page = alloc_page(GFP_KERNEL);
> -			if (!spare_page) {
> -				err = -ENOMEM;
> -				break;
> -			}
> -			per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
> -		}
> -		scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
> -		if (!scribble) {
> -			err = -ENOMEM;
> -			break;
> -		}
> -		per_cpu_ptr(conf->percpu, cpu)->scribble = scribble;
> -	}
>  #ifdef CONFIG_HOTPLUG_CPU
>  	conf->cpu_notify.notifier_call = raid456_cpu_notify;
>  	conf->cpu_notify.priority = 0;
> -	if (err == 0)
> -		err = register_cpu_notifier(&conf->cpu_notify);
> +	err = register_cpu_notifier(&conf->cpu_notify);
> +	if (err)
> +		return err;
>  #endif
> +
> +	get_online_cpus();
> +	for_each_present_cpu(cpu) {
> +		err = alloc_xxx(conf, per_cpu_ptr(conf->percpu, cpu));
> +		if (err)
> +			break;
> +	}
>  	put_online_cpus();
> 
>  	return err;
> 

