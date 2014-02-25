Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaBYAaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:30:55 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58408 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaBYAay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:30:54 -0500
Date: Mon, 24 Feb 2014 16:30:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, Ingo Molnar <mingo@redhat.com>,
        acme@ghostprotocols.net, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: tip/master show panic while booting/rebooting
Message-ID: <20140225003048.GJ8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5302EBA3.10909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5302EBA3.10909@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022500-6688-0000-0000-000006F1D870
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 01:12:03PM +0800, Michael wang wrote:
> Hi, Folks
> 
> Got below panic while testing tip/master on x86 box, it randomly
> occur while booting or rebooting, any ideas?
> 
> Regards,
> Michael Wang
> 
> 
> 
> systemd-readahead-collect[484]: Failed to create fanotify object: Function not implemented
> INFO: rcu_sched detected stalls on CPUs/tasks: { 5} (detected by 4, t=21007 jiffies, g=1100, c=1099, q=802)
> Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 5



> CPU: 5 PID: 95 Comm: kworker/5:1 Not tainted 3.14.0-rc2+ #401
> Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
>  0000000000000000 ffff88097f2a7bd8 ffffffff8156b8ca 00000000000040d2
>  ffffffff817ecc30 ffff88097f2a7c58 ffffffff815622cd ffff88097f2a7c08
>  ffffffff00000010 ffff88097f2a7c68 ffff88097f2a7c08 ffff88097f2a7c78
> Call Trace:
>  <NMI>  [<ffffffff8156b8ca>] dump_stack+0x46/0x58
>  [<ffffffff815622cd>] panic+0xbe/0x1ce
>  [<ffffffff810e7043>] watchdog_overflow_callback+0xb3/0xc0
>  [<ffffffff8111ee68>] __perf_event_overflow+0x98/0x220
>  [<ffffffff8111f764>] perf_event_overflow+0x14/0x20
>  [<ffffffff8101eef2>] intel_pmu_handle_irq+0x1c2/0x2c0
>  [<ffffffff810895e2>] ? find_busiest_group+0x42/0x840
>  [<ffffffff810895f6>] ? find_busiest_group+0x56/0x840
>  [<ffffffff81563002>] ? printk+0x4d/0x4f
>  [<ffffffff815768f4>] perf_event_nmi_handler+0x34/0x60
>  [<ffffffff815760ae>] nmi_handle+0x7e/0x140
>  [<ffffffff8157625a>] default_do_nmi+0x5a/0x250
>  [<ffffffff815764e0>] do_nmi+0x90/0xd0
>  [<ffffffff81575727>] end_repeat_nmi+0x1e/0x2e
>  [<ffffffff8107ec08>] ? idle_cpu+0x48/0x50
>  [<ffffffff8107ec08>] ? idle_cpu+0x48/0x50
>  [<ffffffff8107ec08>] ? idle_cpu+0x48/0x50
>  <<EOE>>  [<ffffffff81089761>] ? find_busiest_group+0x1c1/0x840
>  [<ffffffff81089f5c>] load_balance+0x17c/0x5a0

I don't see an opportunity for load_balance() to loop with interrupts
disabled, but maybe I am looking at the wrong code.  The NMI handler
looks to me like it is diagnosing rather than being the problem.

							Thanx, Paul

>  [<ffffffff8108a88f>] idle_balance+0x10f/0x1c0
>  [<ffffffff8108aa5e>] pick_next_task_fair+0x11e/0x2a0
>  [<ffffffff8107bbf3>] ? dequeue_task+0x73/0x90
>  [<ffffffff815717fa>] __schedule+0x12a/0x670
>  [<ffffffff81571e19>] schedule+0x29/0x70
>  [<ffffffff81067daf>] worker_thread+0x1bf/0x370
>  [<ffffffff81067bf0>] ? manage_workers+0x160/0x160
>  [<ffffffff8106e799>] kthread+0xc9/0xe0
>  [<ffffffff8106e6d0>] ? flush_kthread_worker+0xb0/0xb0
>  [<ffffffff8157d62c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8106e6d0>] ? flush_kthread_worker+0xb0/0xb0
> Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

