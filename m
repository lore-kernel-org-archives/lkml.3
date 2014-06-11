Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaFKIe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:34:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:47968 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaFKIeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,456,1400050800"; 
   d="scan'208";a="553703804"
Message-ID: <5398148B.603@intel.com>
Date: Wed, 11 Jun 2014 16:34:19 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: Wensong Zhang <wensong@linux-vs.org>, Simon Horman <horms@verge.net.au>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [net/ipvs] BUG: unable to handle kernel NULL pointer dereference
 at 00000004
References: <5397DE0E.2070501@intel.com> <alpine.LFD.2.11.1406110828460.2070@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.11.1406110828460.2070@ja.home.ssi.bg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 01:59 PM, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Wed, 11 Jun 2014, Jet Chen wrote:
> 
>> Hi Wensong,
>>
>> 0day kernel testing robot got the below dmesg.
>>
>> +-------------------------------------------------------+----+
>> | boot_successes                                        | 26 |
>> | boot_failures                                         | 4  |
>> | BUG:unable_to_handle_kernel_NULL_pointer_dereference  | 4  |
>> | Oops                                                  | 4  |
>> | EIP_is_at_ip_vs_stop_estimator                        | 4  |
>> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 4  |
>> | backtrace:cleanup_net                                 | 4  |
>> +-------------------------------------------------------+----+
>>
>>
>> [child0:2725] process_vm_readv (347) returned ENOSYS, marking as inactive.
>> [child0:2725] uid changed! Was: 0, now -788547075
>> Bailing main loop. Exit reason: UID changed.
>> [   12.182233] BUG: unable to handle kernel NULL pointer dereference at 00000004
>> [   12.183011] IP: [<4c2f6567>] ip_vs_stop_estimator+0x20/0x3e
>> [   12.183011] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 [   12.183011] Oops: 0002 [#1] DEBUG_PAGEALLOC
>> [   12.183011] Modules linked in:
>> [   12.183011] CPU: 0 PID: 57 Comm: kworker/u2:1 Not tainted 3.15.0-rc8 #1
>> [   12.183011] Workqueue: netns cleanup_net
>> [   12.183011] task: 528773f0 ti: 52878000 task.ti: 52878000
>> [   12.183011] EIP: 0060:[<4c2f6567>] EFLAGS: 00010206 CPU: 0
>> [   12.183011] EIP is at ip_vs_stop_estimator+0x20/0x3e
>> [   12.183011] EAX: 00000000 EBX: 51c39a54 ECX: 00000000 EDX: 00000000
> 
> 	ip_vs_stop_estimator fails at list_del(&est->list)
> on mov %eax,0x4(%edx) instruction and EDX is 0. It means,
> this estimator was never started (initialized with
> INIT_LIST_HEAD in ip_vs_start_estimator) or stopped
> before with the same list_del.
> 
> 	At first look, it is strange but I think the reason
> is the missing CONFIG_SYSCTL. ip_vs_control_net_cleanup
> fails at ip_vs_stop_estimator(net, &ipvs->tot_stats)
> because it is called not depending on CONFIG_SYSCTL but
> without CONFIG_SYSCTL ip_vs_start_estimator was never
> called.
> 
> 	Can you test such patch?

Julian, your patch works. Thanks.

Tested-by: Jet Chen <jet.chen@intel.com>

> 
> ipvs: stop tot_stats estimator only under CONFIG_SYSCTL
> 
> The tot_stats estimator is started only when CONFIG_SYSCTL
> is defined. But it is stopped without checking CONFIG_SYSCTL.
> Fix the crash by moving ip_vs_stop_estimator into
> ip_vs_control_net_cleanup_sysctl.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index c42e83d..581a658 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -3778,6 +3778,7 @@ static void __net_exit ip_vs_control_net_cleanup_sysctl(struct net *net)
>  	cancel_delayed_work_sync(&ipvs->defense_work);
>  	cancel_work_sync(&ipvs->defense_work.work);
>  	unregister_net_sysctl_table(ipvs->sysctl_hdr);
> +	ip_vs_stop_estimator(net, &ipvs->tot_stats);
>  }
>  
>  #else
> @@ -3840,7 +3841,6 @@ void __net_exit ip_vs_control_net_cleanup(struct net *net)
>  	struct netns_ipvs *ipvs = net_ipvs(net);
>  
>  	ip_vs_trash_cleanup(net);
> -	ip_vs_stop_estimator(net, &ipvs->tot_stats);
>  	ip_vs_control_net_cleanup_sysctl(net);
>  	remove_proc_entry("ip_vs_stats_percpu", net->proc_net);
>  	remove_proc_entry("ip_vs_stats", net->proc_net);
> 
