Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaFKGGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 02:06:44 -0400
Received: from ja.ssi.bg ([178.16.129.10]:33106 "EHLO ja.home.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750821AbaFKGGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 02:06:42 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2014 02:06:38 EDT
Date: Wed, 11 Jun 2014 08:59:57 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@ja.home.ssi.bg
To: Jet Chen <jet.chen@intel.com>
cc: Wensong Zhang <wensong@linux-vs.org>, Simon Horman <horms@verge.net.au>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [net/ipvs] BUG: unable to handle kernel NULL pointer dereference
 at 00000004
In-Reply-To: <5397DE0E.2070501@intel.com>
Message-ID: <alpine.LFD.2.11.1406110828460.2070@ja.home.ssi.bg>
References: <5397DE0E.2070501@intel.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Wed, 11 Jun 2014, Jet Chen wrote:

> Hi Wensong,
> 
> 0day kernel testing robot got the below dmesg.
> 
> +-------------------------------------------------------+----+
> | boot_successes                                        | 26 |
> | boot_failures                                         | 4  |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference  | 4  |
> | Oops                                                  | 4  |
> | EIP_is_at_ip_vs_stop_estimator                        | 4  |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 4  |
> | backtrace:cleanup_net                                 | 4  |
> +-------------------------------------------------------+----+
> 
> 
> [child0:2725] process_vm_readv (347) returned ENOSYS, marking as inactive.
> [child0:2725] uid changed! Was: 0, now -788547075
> Bailing main loop. Exit reason: UID changed.
> [   12.182233] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [   12.183011] IP: [<4c2f6567>] ip_vs_stop_estimator+0x20/0x3e
> [   12.183011] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 [   12.183011] Oops: 0002 [#1] DEBUG_PAGEALLOC
> [   12.183011] Modules linked in:
> [   12.183011] CPU: 0 PID: 57 Comm: kworker/u2:1 Not tainted 3.15.0-rc8 #1
> [   12.183011] Workqueue: netns cleanup_net
> [   12.183011] task: 528773f0 ti: 52878000 task.ti: 52878000
> [   12.183011] EIP: 0060:[<4c2f6567>] EFLAGS: 00010206 CPU: 0
> [   12.183011] EIP is at ip_vs_stop_estimator+0x20/0x3e
> [   12.183011] EAX: 00000000 EBX: 51c39a54 ECX: 00000000 EDX: 00000000

	ip_vs_stop_estimator fails at list_del(&est->list)
on mov %eax,0x4(%edx) instruction and EDX is 0. It means,
this estimator was never started (initialized with
INIT_LIST_HEAD in ip_vs_start_estimator) or stopped
before with the same list_del.

	At first look, it is strange but I think the reason
is the missing CONFIG_SYSCTL. ip_vs_control_net_cleanup
fails at ip_vs_stop_estimator(net, &ipvs->tot_stats)
because it is called not depending on CONFIG_SYSCTL but
without CONFIG_SYSCTL ip_vs_start_estimator was never
called.

	Can you test such patch?

ipvs: stop tot_stats estimator only under CONFIG_SYSCTL

The tot_stats estimator is started only when CONFIG_SYSCTL
is defined. But it is stopped without checking CONFIG_SYSCTL.
Fix the crash by moving ip_vs_stop_estimator into
ip_vs_control_net_cleanup_sysctl.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c42e83d..581a658 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3778,6 +3778,7 @@ static void __net_exit ip_vs_control_net_cleanup_sysctl(struct net *net)
 	cancel_delayed_work_sync(&ipvs->defense_work);
 	cancel_work_sync(&ipvs->defense_work.work);
 	unregister_net_sysctl_table(ipvs->sysctl_hdr);
+	ip_vs_stop_estimator(net, &ipvs->tot_stats);
 }
 
 #else
@@ -3840,7 +3841,6 @@ void __net_exit ip_vs_control_net_cleanup(struct net *net)
 	struct netns_ipvs *ipvs = net_ipvs(net);
 
 	ip_vs_trash_cleanup(net);
-	ip_vs_stop_estimator(net, &ipvs->tot_stats);
 	ip_vs_control_net_cleanup_sysctl(net);
 	remove_proc_entry("ip_vs_stats_percpu", net->proc_net);
 	remove_proc_entry("ip_vs_stats", net->proc_net);
-- 
1.9.0

> [   12.183011] ESI: 51c39bf0 EDI: 51c399cc EBP: 52879e70 ESP: 52879e68
> [   12.183011]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [   12.183011] CR0: 8005003b CR2: 00000004 CR3: 12fbe000 CR4: 000006b0
> [   12.183011] DR0: 080cb000 DR1: c0100220 DR2: 00000000 DR3: 00000000
> [   12.183011] DR6: ffff0ff0 DR7: 00000600
> [   12.183011] Stack:
> [   12.183011]  51c39800 51c3d340 52879e88 4c2f3400 51c39b14 51c3d340 4c7630bc 52879eb8
> [   12.183011]  52879e94 4c2ef3b2 51c3d340 52879ea8 4c2b7509 4c7630bc 52879eb8 00000000
> [   12.183011]  52879ecc 4c2b7c5b 51c3d370 51c3d370 51c3d378 51c3d378 52817b80 00000000
> [   12.183011] Call Trace:
> [   12.183011]  [<4c2f3400>] ip_vs_control_net_cleanup+0x8b/0x9c
> [   12.183011]  [<4c2ef3b2>] __ip_vs_cleanup+0x27/0x3b
> [   12.183011]  [<4c2b7509>] ops_exit_list+0x2e/0x3b
> [   12.183011]  [<4c2b7c5b>] cleanup_net+0xbf/0x138
> [   12.183011]  [<4be33e6a>] process_one_work+0x1c5/0x2dc
> [   12.183011]  [<4be33de7>] ? process_one_work+0x142/0x2dc
> [   12.183011]  [<4be348cc>] worker_thread+0x126/0x1c3
> [   12.183011]  [<4be347a6>] ? rescuer_thread+0x203/0x203
> [   12.183011]  [<4be37e01>] kthread+0x86/0x8b
> [   12.183011]  [<4c41b380>] ret_from_kernel_thread+0x20/0x30
> [   12.183011]  [<4be37d7b>] ? init_completion+0x1e/0x1e
> [   12.183011] Code: e8 0b 40 12 00 5b 5b 5e 5f 5d c3 55 89 e5 56 53 8b b0 38 09 00 00 89 d3 81 c6 f0 03 00 00 89 f0 e8 f2 3d 12 00 8b 43 34 8b 53 30 <89> 42 04 89 10 89 f0 c7 43 30 00 01 10 00 c7 43 34 00 02 20 00
> [   12.183011] EIP: [<4c2f6567>] ip_vs_stop_estimator+0x20/0x3e SS:ESP 0068:52879e68
> [   12.183011] CR2: 0000000000000004
> [   12.183011] ---[ end trace ac697d9f45d2a83f ]---
> [   12.183011] Kernel panic - not syncing: Fatal exception in interrupt

Regards

--
Julian Anastasov <ja@ssi.bg>
