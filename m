Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaBQOuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:50:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29752 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaBQOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:50:52 -0500
Message-ID: <530221C9.60103@oracle.com>
Date: Mon, 17 Feb 2014 09:50:49 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org
Subject: Re: [UPDATED][PATCH v2 46/52] xen, balloon: Fix CPU hotplug callback
 registration
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com> <20140214075935.22701.71000.stgit@srivatsabhat.in.ibm.com> <52FE490B.8000908@oracle.com> <52FE493A.2030206@linux.vnet.ibm.com> <52FF9B14.8000308@linux.vnet.ibm.com>
In-Reply-To: <52FF9B14.8000308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2014 11:51 AM, Srivatsa S. Bhat wrote:
> On 02/14/2014 10:20 PM, Srivatsa S. Bhat wrote:
>> On 02/14/2014 10:19 PM, Boris Ostrovsky wrote:
>>> On 02/14/2014 02:59 AM, Srivatsa S. Bhat wrote:
>>>> Subsystems that want to register CPU hotplug callbacks, as well as
>>>> perform
>>>> initialization for the CPUs that are already online, often do it as shown
>>>> below:
>>>>
> [...]
>>> This looks exactly like the earlier version (i.e the notifier is still
>>> kept registered on allocation failure and commit message doesn't exactly
>>> reflect the change).
>>>
>> Sorry, your earlier reply (for some unknown reason) missed the email-threading
>> and landed elsewhere in my inbox, and hence unfortunately I forgot to take
>> your suggestions into account while sending out the v2.
>>
>> I'll send out an updated version of just this patch, as a reply.
> Here is the updated patch. Please let me know what you think!

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

-boris


>
> ----------------------------------------------------------------------------
>
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] xen, balloon: Fix CPU hotplug callback registration
>
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:
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
> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
> with CPU hotplug operations).
>
> The xen balloon driver doesn't take get/put_online_cpus() around this code,
> but that is also buggy, since it can miss CPU hotplug events in between the
> initialization and callback registration:
>
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 		   ^
> 		   |  Race window; Can miss CPU hotplug events here.
> 		   v
> 	register_cpu_notifier(&foobar_cpu_notifier);
>
> Interestingly, the balloon code in xen can simply be reorganized as shown
> below, to have a race-free method to register hotplug callbacks, without even
> taking get/put_online_cpus(). This is because the initialization performed for
> already online CPUs is exactly the same as that performed for CPUs that come
> online later. Moreover, the code has checks in place to avoid double
> initialization.
>
> 	register_cpu_notifier(&foobar_cpu_notifier);
>
> 	get_online_cpus();
>
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
>
> 	put_online_cpus();
>
> A hotplug operation that occurs between registering the notifier and calling
> get_online_cpus(), won't disrupt anything, because the code takes care to
> perform the memory allocations only once.
>
> So reorganize the balloon code in xen this way to fix the issues with CPU
> hotplug callback registration.
>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: xen-devel@lists.xenproject.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>   drivers/xen/balloon.c |   36 ++++++++++++++++++++++++------------
>   1 file changed, 24 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index 37d06ea..dd79549 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -592,19 +592,29 @@ static void __init balloon_add_region(unsigned long start_pfn,
>   	}
>   }
>   
> +static int alloc_balloon_scratch_page(int cpu)
> +{
> +	if (per_cpu(balloon_scratch_page, cpu) != NULL)
> +		return 0;
> +
> +	per_cpu(balloon_scratch_page, cpu) = alloc_page(GFP_KERNEL);
> +	if (per_cpu(balloon_scratch_page, cpu) == NULL) {
> +		pr_warn("Failed to allocate balloon_scratch_page for cpu %d\n", cpu);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +
>   static int balloon_cpu_notify(struct notifier_block *self,
>   				    unsigned long action, void *hcpu)
>   {
>   	int cpu = (long)hcpu;
>   	switch (action) {
>   	case CPU_UP_PREPARE:
> -		if (per_cpu(balloon_scratch_page, cpu) != NULL)
> -			break;
> -		per_cpu(balloon_scratch_page, cpu) = alloc_page(GFP_KERNEL);
> -		if (per_cpu(balloon_scratch_page, cpu) == NULL) {
> -			pr_warn("Failed to allocate balloon_scratch_page for cpu %d\n", cpu);
> +		if (alloc_balloon_scratch_page(cpu))
>   			return NOTIFY_BAD;
> -		}
>   		break;
>   	default:
>   		break;
> @@ -624,15 +634,17 @@ static int __init balloon_init(void)
>   		return -ENODEV;
>   
>   	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> -		for_each_online_cpu(cpu)
> -		{
> -			per_cpu(balloon_scratch_page, cpu) = alloc_page(GFP_KERNEL);
> -			if (per_cpu(balloon_scratch_page, cpu) == NULL) {
> -				pr_warn("Failed to allocate balloon_scratch_page for cpu %d\n", cpu);
> +		register_cpu_notifier(&balloon_cpu_notifier);
> +
> +		get_online_cpus();
> +		for_each_online_cpu(cpu) {
> +			if (alloc_balloon_scratch_page(cpu)) {
> +				put_online_cpus();
> +				unregister_cpu_notifier(&balloon_cpu_notifier);
>   				return -ENOMEM;
>   			}
>   		}
> -		register_cpu_notifier(&balloon_cpu_notifier);
> +		put_online_cpus();
>   	}
>   
>   	pr_info("Initialising balloon driver\n");
>
>
>

