Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab3BFC0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:26:33 -0500
Received: from mail.candelatech.com ([208.74.158.172]:47474 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab3BFC0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:26:32 -0500
Message-ID: <5111BF51.5010607@candelatech.com>
Date: Tue, 05 Feb 2013 18:26:25 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
References: <5111AD8D.1080005@candelatech.com> <20130206015430.GA9161@home.goodmis.org>
In-Reply-To: <20130206015430.GA9161@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 05:54 PM, Steven Rostedt wrote:
> On Tue, Feb 05, 2013 at 05:10:37PM -0800, Ben Greear wrote:
>> I'm debugging something that could be my own bug in my wanlink module (but then
>> again, haven't seen this on 3.5 kernels, and my module is
>> basically un-changed since then).
>>
>> I'm using lockdep, and keep seeing "BUG: MAX_LOCK_DEPTH too low".
>> I tried changing the depth to 96 from 48, but it still hits.
>>
>> I also added debug_show_all_locks(); when this error
>> case hits.  I was assuming that if lockdep depth is large,
>> there would be lots of locks held..but that does not
>> seem to be the case??

> Perhaps what you want to do is add a:
>
> 	lockdep_print_held_locks(current);

Well, here it is..something is calling rcu_read_lock lots and lots,
it seems.  Any way to get a better idea of where those calls are
made?

Showing all locks held in the system:
1 lock held by mingetty/2868:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8132d503>] n_tty_read+0x28d/0x785
1 lock held by mingetty/2870:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8132d503>] n_tty_read+0x28d/0x785
1 lock held by mingetty/2872:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8132d503>] n_tty_read+0x28d/0x785
1 lock held by mingetty/2874:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8132d503>] n_tty_read+0x28d/0x785
1 lock held by mingetty/2876:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8132d503>] n_tty_read+0x28d/0x785
1 lock held by mingetty/2878:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8132d503>] n_tty_read+0x28d/0x785
1 lock held by bash/3337:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8132d503>] n_tty_read+0x28d/0x785
1 lock held by bash/3369:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8132d503>] n_tty_read+0x28d/0x785

=============================================

96 locks held by swapper/0/0:
  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #4:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #5:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #6:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #7:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #8:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #9:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #10:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #11:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #12:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #13:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #14:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #15:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #16:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #17:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #18:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #19:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #20:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #21:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #22:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #23:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #24:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #25:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #26:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #27:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #28:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #29:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #30:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #31:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #32:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #33:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #34:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #35:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #36:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #37:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #38:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #39:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #40:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #41:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #42:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #43:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #44:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #45:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #46:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #47:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #48:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #49:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #50:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #51:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #52:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #53:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #54:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #55:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #56:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #57:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #58:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #59:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #60:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #61:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #62:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #63:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #64:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #65:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #66:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #67:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #68:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #69:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #70:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #71:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #72:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #73:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #74:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #75:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #76:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #77:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #78:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #79:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #80:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #81:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #82:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #83:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #84:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #85:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #86:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #87:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #88:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #89:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #90:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #91:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #92:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
  #93:  (&(&wl->cfg_spin_lock)->rlock){..-...}, at: [<ffffffffa07bc4d0>] handle_rcv+0x15d/0x1dd [wanlink]
  #94:  (&wl_threads[q].my_wq){..-...}, at: [<ffffffff810abe4d>] __wake_up+0x1d/0x48
  #95:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810b09c1>] try_to_wake_up+0x29/0x20b
BUG: MAX_LOCK_DEPTH too low, depth: 96  max: 96!
turning off the locking correctness validator.
Pid: 0, comm: swapper/0 Tainted: G         C O 3.7.6+ #6
Call Trace:
  <IRQ>  [<ffffffff810cda86>] __lock_acquire+0xe8d/0xf13
  [<ffffffff810cc3e8>] ? mark_lock+0x2d/0x231
  [<ffffffff810cdb70>] lock_acquire+0x64/0x81
  [<ffffffff810b09c1>] ? try_to_wake_up+0x29/0x20b
  [<ffffffff81540435>] _raw_spin_lock_irqsave+0x4e/0x60
  [<ffffffff810b09c1>] ? try_to_wake_up+0x29/0x20b
  [<ffffffff810b09c1>] try_to_wake_up+0x29/0x20b
  [<ffffffff810b0bb0>] default_wake_function+0xd/0xf
  [<ffffffff810ab34d>] __wake_up_common+0x49/0x7f
  [<ffffffff810abe64>] __wake_up+0x34/0x48
  [<ffffffffa07bbe11>] handleRcvWlp+0xf4d/0xfd5 [wanlink]
  [<ffffffff810ccf7c>] ? __lock_acquire+0x383/0xf13
  [<ffffffffa07bc325>] wp_handle_rcv_pkt+0x1f5/0x243 [wanlink]
  [<ffffffffa07bc51c>] handle_rcv+0x1a9/0x1dd [wanlink]
  [<ffffffff814777f5>] deliver_skb+0x58/0x60
  [<ffffffff81477d04>] __netif_receive_skb+0x507/0x63c
  [<ffffffff810100b6>] ? read_tsc+0x9/0x1b
  [<ffffffff81479b3d>] netif_receive_skb+0x56/0x8b
  [<ffffffff8147a168>] ? __napi_gro_receive+0xf3/0x102
  [<ffffffff81479c55>] napi_skb_finish+0x24/0x57
  [<ffffffff8147a39d>] napi_gro_receive+0x91/0x96
  [<ffffffffa0218d31>] e1000_receive_skb+0x50/0x5b [e1000e]
  [<ffffffffa021c00c>] e1000_clean_rx_irq+0x29f/0x341 [e1000e]
  [<ffffffffa021c5c6>] e1000e_poll+0x7d/0x239 [e1000e]
  [<ffffffff8147a523>] net_rx_action+0xb2/0x1e2
  [<ffffffff8108ee06>] ? __do_softirq+0x6d/0x17b
  [<ffffffff8108ee44>] __do_softirq+0xab/0x17b
  [<ffffffff815473bc>] call_softirq+0x1c/0x30
  [<ffffffff8100bd46>] do_softirq+0x46/0x9e
  [<ffffffff8108ec9f>] irq_exit+0x4e/0xcc
  [<ffffffff8100b635>] do_IRQ+0x97/0xae
  [<ffffffff81540f72>] common_interrupt+0x72/0x72
  <EOI>  [<ffffffff81011082>] ? mwait_idle+0x77/0x9f
  [<ffffffff81011079>] ? mwait_idle+0x6e/0x9f
  [<ffffffff81011379>] cpu_idle+0x68/0xbc
  [<ffffffff81522b4c>] rest_init+0x130/0x137
  [<ffffffff81522a1c>] ? csum_partial_copy_generic+0x16c/0x16c
  [<ffffffff81ac3c87>] start_kernel+0x37f/0x38c
  [<ffffffff81ac373d>] ? repair_env_string+0x58/0x58
  [<ffffffff81ac32dd>] x86_64_start_reservations+0xb8/0xbd
  [<ffffffff81ac33e3>] x86_64_start_kernel+0x101/0x110
BUG: sleeping function called from invalid context at /home/greearb/git/linux-3.7.dev.y/kernel/mutex.c:269
in_atomic(): 0, irqs_disabled(): 0, pid: 2476, name: kwanlink/0
INFO: lockdep is turned off.
Pid: 2476, comm: kwanlink/0 Tainted: G         C O 3.7.6+ #6
Call Trace:
  [<ffffffff810ac9b0>] __might_sleep+0x1a2/0x1ab
  [<ffffffff8153e549>] mutex_lock_nested+0x20/0x3b
  [<ffffffffa07bd4ac>] do_task+0x6d/0x248 [wanlink]
  [<ffffffffa07bd7e0>] wl_thread_task+0x159/0x202 [wanlink]
  [<ffffffffa07bd687>] ? do_task+0x248/0x248 [wanlink]
  [<ffffffff810a350b>] kthread+0xc2/0xca
  [<ffffffff810a3449>] ? __init_kthread_worker+0x56/0x56
  [<ffffffff8154607c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810a3449>] ? __init_kthread_worker+0x56/0x56
BUG: sleeping function called from invalid context at /home/greearb/git/linux-3.7.dev.y/kernel/mutex.c:269



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

