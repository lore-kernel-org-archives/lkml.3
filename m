Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaJBPAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:00:10 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:57508 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbaJBPAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:00:06 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 2 Oct 2014 11:06:26 -0400 (EDT)
To: Sasha Levin <sasha.levin@oracle.com>
cc: Peter Zijlstra <peterz@infradead.org>, Cong Wang <cwang@twopensource.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <542BE27B.6040006@oracle.com>
Message-ID: <alpine.DEB.2.11.1410021106150.11281@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu> <20140910083136.GP6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu> <541059C9.1040200@oracle.com>
 <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu> <20140910143306.GD4783@worktop.ger.corp.intel.com> <alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409250052480.26664@vincent-weaver-1.umelst.maine.edu>
 <CAHA+R7Nu_2KORkf9uP1_HktRA+MLy6TS4vXCPS9Q_JzrcH2SYg@mail.gmail.com> <542789E5.7090805@oracle.com> <20140930172308.GI4241@worktop.programming.kicks-ass.net> <542BE27B.6040006@oracle.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014, Sasha Levin wrote:

> On 09/30/2014 01:23 PM, Peter Zijlstra wrote:
> > How about this then?
> > 
> > ---
> > Subject: perf: Fix unclone_ctx() vs locking
> > 
> > The idiot who did 4a1c0f262f88 forgot to pay attention and fix all
> > similar cases. Do so now.
> > 
> > In particular, unclone_ctx() must be called while holding ctx->lock,
> > therefore all such sites are broken for the same reason. Pull the
> > put_ctx() call out from under ctx->lock.
> > 
> > Reported-by: Sasha Levin <sasha.levin@oracle.com>
> > Fixes: 4a1c0f262f88 ("perf: Fix lockdep warning on process exit")
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> Looks good! The issue didn't reproduce anymore.

So I left my core2 machine fuzzing (on 3.17-rc7) overnight and in the 
morning the fuzzer was unkillable, stuck in the following.  Does this look 
like the same problem?  

It looks like this is easily reproducible (just wedged the machine again)
so let me check back after testing the patch.

Vince

[152447.120375] SysRq : Show backtrace of all active CPUs
[152447.124005] sending NMI to all CPUs:
[152447.124005] NMI backtrace for cpu 0
[152447.124005] CPU: 0 PID: 10004 Comm: perf_fuzzer Tainted: G        W      3.17.0-rc7+ #84
[152447.124005] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[152447.124005] task: ffff88009d1b9000 ti: ffff88009c2ec000 task.ti: ffff88009c2ec000
[152447.124005] RIP: 0010:[<ffffffff8129a837>]  [<ffffffff8129a837>] delay_tsc+0x1b/0x4e
[152447.124005] RSP: 0018:ffff88011fc03d78  EFLAGS: 00000046
[152447.124005] RAX: 0000000000000000 RBX: 0000000000002710 RCX: 000000003a2a18ef
[152447.124005] RDX: 000000000000005f RSI: 0000000000000000 RDI: 0000000000265906
[152447.124005] RBP: ffff88011fc03d78 R08: 000000003a2a194e R09: 0000000000000000
[152447.124005] R10: ffffffff81673c90 R11: 0000000000000000 R12: 0000000000000007
[152447.124005] R13: 000000000000006c R14: 0000000000000001 R15: 0000000000000046
[152447.124005] FS:  00007fb8311eb700(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[152447.124005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[152447.124005] CR2: 00007fff79ac1648 CR3: 000000009d7f9000 CR4: 00000000000407f0
[152447.124005] DR0: 0000000001b3f000 DR1: 0000000001937000 DR2: 0000000000000000
[152447.124005] DR3: 0000000001b2e000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[152447.124005] Stack:
[152447.124005]  ffff88011fc03d88 ffffffff8129a7c9 ffff88011fc03d98 ffffffff8129a7ef
[152447.124005]  ffff88011fc03db0 ffffffff8102b4b4 ffffffff81a6e610 ffff88011fc03dc0
[152447.124005]  ffffffff8131cd31 ffff88011fc03df0 ffffffff8131d2ea ffffffff81c76110
[152447.124005] Call Trace:
[152447.124005]  <IRQ> 
[152447.124005]  [<ffffffff8129a7c9>] __delay+0xf/0x11
[152447.124005]  [<ffffffff8129a7ef>] __const_udelay+0x24/0x26
[152447.124005]  [<ffffffff8102b4b4>] arch_trigger_all_cpu_backtrace+0xc5/0xd1
[152447.124005]  [<ffffffff8131cd31>] sysrq_handle_showallcpus+0x13/0x15
[152447.124005]  [<ffffffff8131d2ea>] __handle_sysrq+0x94/0x121
[152447.124005]  [<ffffffff8131d39a>] handle_sysrq+0x23/0x25
[152447.124005]  [<ffffffff8132dd3f>] serial8250_rx_chars+0x14b/0x1b8
[152447.124005]  [<ffffffff8132de22>] serial8250_handle_irq+0x76/0xb4
[152447.124005]  [<ffffffff8132de81>] serial8250_default_handle_irq+0x21/0x24
[152447.124005]  [<ffffffff8132d132>] serial8250_interrupt+0x3d/0xb2
[152447.124005]  [<ffffffff81075f34>] handle_irq_event_percpu+0x43/0x16e
[152447.124005]  [<ffffffff8108b382>] ? clockevents_program_event+0x9d/0xb9
[152447.124005]  [<ffffffff8107609b>] handle_irq_event+0x3c/0x57
[152447.124005]  [<ffffffff81078a0d>] handle_edge_irq+0xb1/0xcb
[152447.124005]  [<ffffffff810046ce>] handle_irq+0x21/0x2a
[152447.124005]  [<ffffffff81004146>] do_IRQ+0x4e/0xc3
[152447.124005]  [<ffffffff815244aa>] common_interrupt+0x6a/0x6a
[152447.124005]  <EOI> 
[152447.124005]  [<ffffffff8107b2ce>] ? synchronize_srcu_expedited+0x15/0x15
[152447.124005]  [<ffffffff8110dffd>] ? kmem_cache_alloc_trace+0xcb/0xda
[152447.124005]  [<ffffffff8107d7f6>] ? __call_rcu.constprop.63+0x55/0x1c8
[152447.124005]  [<ffffffff8107d983>] kfree_call_rcu+0x1a/0x1c
[152447.124005]  [<ffffffff810ca0dc>] put_ctx+0x50/0x53
[152447.124005]  [<ffffffff810cb9f7>] find_get_context+0x13f/0x170
[152447.124005]  [<ffffffff810cff70>] SYSC_perf_event_open+0x47b/0x7f5
[152447.124005]  [<ffffffff810d064a>] SyS_perf_event_open+0xe/0x10
[152447.124005]  [<ffffffff81523916>] system_call_fastpath+0x1a/0x1f
[152447.124005] Code: 90 55 48 8d 3c bf 48 89 e5 e8 b1 ff ff ff 5d c3 66 66 66 66 90 55 48 89 e5 65 8b 34 25 d4 b0 00 00 66 66 90 0f ae e8 0f 31 89 c1 <66> 66 90 0f ae e8 0f 31 48 c1 e2 20 89 c0 48 09 c2 41 89 d0 29 


