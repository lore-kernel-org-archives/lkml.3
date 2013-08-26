Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab3HZSSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:18:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3HZSSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:18:16 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=4YNYSHFQjk8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jyE81Idm5WYA:10 a=20KFwNOVAAAA:8 a=qB-pRJpMqUdgftLOsbYA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 26 Aug 2013 14:18:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suspicious RCU usage (perf)
Message-ID: <20130826141814.54dcaa89@gandalf.local.home>
In-Reply-To: <20130826175012.GA25202@redhat.com>
References: <20130826145838.GA8377@redhat.com>
	<20130826162928.GQ3871@linux.vnet.ibm.com>
	<20130826133041.3d750b1b@gandalf.local.home>
	<20130826175012.GA25202@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 13:50:12 -0400
Dave Jones <davej@redhat.com> wrote:
> 
> This was triggered as a regular user fwiw.
> I had not been running perf, or any other tracing. It was just left
> fuzzing over the weekend with no interaction at all.

So you are telling me that ftrace was enabled by a regular user? If so,
that's a huge issue.

> [260431.875883]  [<ffffffff816f9c6f>] dump_stack+0x54/0x74
> [260431.876869]  [<ffffffff810be6a7>] lockdep_rcu_suspicious+0xe7/0x120
> [260431.877852]  [<ffffffff81146ef4>] __perf_event_overflow+0x2a4/0x320
> [260431.878834]  [<ffffffff81146d50>] ? __perf_event_overflow+0x100/0x320
> [260431.879811]  [<ffffffff81146e0c>] ? __perf_event_overflow+0x1bc/0x320
> [260431.880784]  [<ffffffff8170ce00>] ? ftrace_call+0x5/0x2f
> [260431.881758]  [<ffffffff81147101>] perf_swevent_overflow+0x51/0xe0
> [260431.882728]  [<ffffffff811471ef>] perf_swevent_event+0x5f/0x90
> [260431.883685]  [<ffffffff81147329>] perf_tp_event+0x109/0x4f0
> [260431.884637]  [<ffffffff81147542>] ? perf_tp_event+0x322/0x4f0
> [260431.885586]  [<ffffffff811079fb>] ? rcu_eqs_enter_common+0x5b/0x420
> [260431.886539]  [<ffffffff8107a320>] ? task_work_run+0xe0/0xe0
> [260431.887486]  [<ffffffff81135910>] perf_ftrace_function_call+0xc0/0xd0

This is the perf function tracing call.

> [260431.888417]  [<ffffffff81114d37>] ? ftrace_ops_control_func+0xe7/0x110
> [260431.889353]  [<ffffffff8107a320>] ? task_work_run+0xe0/0xe0
> [260431.890281]  [<ffffffff811079fb>] ? rcu_eqs_enter_common+0x5b/0x420
> [260431.891191]  [<ffffffff81114d37>] ftrace_ops_control_func+0xe7/0x110
> [260431.892088]  [<ffffffff8170ce00>] ftrace_call+0x5/0x2f

ftrace_call is the mcount trampoline. The only way to get there is via
function tracing, and function tracing should only be enabled by root.

> [260431.892975]  [<ffffffff81114cbb>] ? ftrace_ops_control_func+0x6b/0x110
> [260431.893862]  [<ffffffff8170ce00>] ? ftrace_call+0x5/0x2f
> [260431.894745]  [<ffffffff81097def>] ? local_clock+0x3f/0x50
> [260431.895631]  [<ffffffff8107a325>] ? debug_lockdep_rcu_enabled+0x5/0x40
> [260431.896516]  [<ffffffff8107a325>] ? debug_lockdep_rcu_enabled+0x5/0x40
> [260431.897387]  [<ffffffff811079fb>] ? rcu_eqs_enter_common+0x5b/0x420
> [260431.898264]  [<ffffffff81107e24>] rcu_eqs_enter+0x64/0xa0
> [260431.899133]  [<ffffffff8110c673>] rcu_user_enter+0x13/0x20
> [260431.899999]  [<ffffffff8114e67a>] user_enter+0x6a/0xd0
> [260431.900859]  [<ffffffff81010208>] syscall_trace_leave+0x78/0x150
> [260431.901712]  [<ffffffff8170d4af>] int_check_syscall_exit_work+0x34/0x3d

So my question to you. If you were not running perf or any other
tracing, and this is all just non-root user. How the hell did perf
function tracing get started on your box????

-- Steve
