Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936082Ab3DICKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:10:02 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5599 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3DICKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:10:00 -0400
Message-ID: <51637830.1010309@huawei.com>
Date: Tue, 9 Apr 2013 10:08:48 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        WANG Chao <chaowang@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 3/3] ftrace: Do not call stub functions in control loop
References: <20130408204937.649895945@goodmis.org> <20130408210518.551272592@goodmis.org>
In-Reply-To: <20130408210518.551272592@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/9 4:49, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The function tracing control loop used by perf spits out a warning
> if the called function is not a control function. This is because
> the control function references a per cpu allocated data structure
> on struct ftrace_ops that is not allocated for other types of
> functions.
> 
> commit 0a016409e42 "ftrace: Optimize the function tracer list loop"
> 
> Had an optimization done to all function tracing loops to optimize
> for a single registered ops. Unfortunately, this allows for a slight
> race when tracing starts or ends, where the stub function might be
> called after the current registered ops is removed. In this case we
> get the following dump:
> 
> root# perf stat -e ftrace:function sleep 1
> [   74.339105] WARNING: at include/linux/ftrace.h:209 ftrace_ops_control_func+0xde/0xf0()
> [   74.349522] Hardware name: PRIMERGY RX200 S6
> [   74.357149] Modules linked in: sg igb iTCO_wdt ptp pps_core iTCO_vendor_support i7core_edac dca lpc_ich i2c_i801 coretemp edac_core crc32c_intel mfd_core ghash_clmulni_intel dm_multipath acpi_power_meter pcspk
> r microcode vhost_net tun macvtap macvlan nfsd kvm_intel kvm auth_rpcgss nfs_acl lockd sunrpc uinput xfs libcrc32c sd_mod crc_t10dif sr_mod cdrom mgag200 i2c_algo_bit drm_kms_helper ttm qla2xxx mptsas ahci drm li
> bahci scsi_transport_sas mptscsih libata scsi_transport_fc i2c_core mptbase scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
> [   74.446233] Pid: 1377, comm: perf Tainted: G        W    3.9.0-rc1 #1
> [   74.453458] Call Trace:
> [   74.456233]  [<ffffffff81062e3f>] warn_slowpath_common+0x7f/0xc0
> [   74.462997]  [<ffffffff810fbc60>] ? rcu_note_context_switch+0xa0/0xa0
> [   74.470272]  [<ffffffff811041a2>] ? __unregister_ftrace_function+0xa2/0x1a0
> [   74.478117]  [<ffffffff81062e9a>] warn_slowpath_null+0x1a/0x20
> [   74.484681]  [<ffffffff81102ede>] ftrace_ops_control_func+0xde/0xf0
> [   74.491760]  [<ffffffff8162f400>] ftrace_call+0x5/0x2f
> [   74.497511]  [<ffffffff8162f400>] ? ftrace_call+0x5/0x2f
> [   74.503486]  [<ffffffff8162f400>] ? ftrace_call+0x5/0x2f
> [   74.509500]  [<ffffffff810fbc65>] ? synchronize_sched+0x5/0x50
> [   74.516088]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
> [   74.522268]  [<ffffffff810fbc65>] ? synchronize_sched+0x5/0x50
> [   74.528837]  [<ffffffff811041a2>] ? __unregister_ftrace_function+0xa2/0x1a0
> [   74.536696]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
> [   74.542878]  [<ffffffff8162402d>] ? mutex_lock+0x1d/0x50
> [   74.548869]  [<ffffffff81105c67>] unregister_ftrace_function+0x27/0x50
> [   74.556243]  [<ffffffff8111eadf>] perf_ftrace_event_register+0x9f/0x140
> [   74.563709]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
> [   74.569887]  [<ffffffff8162402d>] ? mutex_lock+0x1d/0x50
> [   74.575898]  [<ffffffff8111e94e>] perf_trace_destroy+0x2e/0x50
> [   74.582505]  [<ffffffff81127ba9>] tp_perf_event_destroy+0x9/0x10
> [   74.589298]  [<ffffffff811295d0>] free_event+0x70/0x1a0
> [   74.595208]  [<ffffffff8112a579>] perf_event_release_kernel+0x69/0xa0
> [   74.602460]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
> [   74.608667]  [<ffffffff8112a640>] put_event+0x90/0xc0
> [   74.614373]  [<ffffffff8112a740>] perf_release+0x10/0x20
> [   74.620367]  [<ffffffff811a3044>] __fput+0xf4/0x280
> [   74.625894]  [<ffffffff811a31de>] ____fput+0xe/0x10
> [   74.631387]  [<ffffffff81083697>] task_work_run+0xa7/0xe0
> [   74.637452]  [<ffffffff81014981>] do_notify_resume+0x71/0xb0
> [   74.643843]  [<ffffffff8162fa92>] int_signal+0x12/0x17
> 
> To fix this a new ftrace_ops flag is added that denotes the ftrace_list_end
> ftrace_ops stub as just that, a stub. This flag is now checked in the
> control loop and the function is not called if the flag is set.
> 
> Thanks to Jovi for not just reporting the bug, but also pointing out
> where the bug was in the code.
> 
> Link: http://lkml.kernel.org/r/514A8855.7090402@redhat.com
> Link: http://lkml.kernel.org/r/1364377499-1900-15-git-send-email-jovi.zhangwei@huawei.com
> 
> Tested-by: WANG Chao <chaowang@redhat.com>
> Reported-by: WANG Chao <chaowang@redhat.com>
> Reported-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Involve stable? 3.8 kernel user would need this fix.

> ---
>  include/linux/ftrace.h |    2 ++
>  kernel/trace/ftrace.c  |    5 +++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index e5ca8ef..167abf9 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -89,6 +89,7 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
>   *            that the call back has its own recursion protection. If it does
>   *            not set this, then the ftrace infrastructure will add recursion
>   *            protection for the caller.
> + * STUB   - The ftrace_ops is just a place holder.
>   */
>  enum {
>  	FTRACE_OPS_FL_ENABLED			= 1 << 0,
> @@ -98,6 +99,7 @@ enum {
>  	FTRACE_OPS_FL_SAVE_REGS			= 1 << 4,
>  	FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED	= 1 << 5,
>  	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 6,
> +	FTRACE_OPS_FL_STUB			= 1 << 7,
>  };
>  
>  struct ftrace_ops {
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index cc4943c..7e89710 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -66,7 +66,7 @@
>  
>  static struct ftrace_ops ftrace_list_end __read_mostly = {
>  	.func		= ftrace_stub,
> -	.flags		= FTRACE_OPS_FL_RECURSION_SAFE,
> +	.flags		= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_STUB,
>  };
>  
>  /* ftrace_enabled is a method to turn ftrace on or off */
> @@ -4131,7 +4131,8 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
>  	preempt_disable_notrace();
>  	trace_recursion_set(TRACE_CONTROL_BIT);
>  	do_for_each_ftrace_op(op, ftrace_control_list) {
> -		if (!ftrace_function_local_disabled(op) &&
> +		if (!(op->flags & FTRACE_OPS_FL_STUB) &&
> +		    !ftrace_function_local_disabled(op) &&
>  		    ftrace_ops_test(op, ip))
>  			op->func(ip, parent_ip, op, regs);
>  	} while_for_each_ftrace_op(op);
> 


