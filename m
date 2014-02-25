Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaBYC5C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:57:02 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56581 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaBYC5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:57:00 -0500
Message-ID: <530C0673.3010401@gmail.com>
Date: Tue, 25 Feb 2014 10:56:51 +0800
From: wyang <w90p710@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: Re: INFO: rcu_preempt self-detected stall on CPU with 3.10 kernel
References: <530B01F5.8020109@gmail.com> <20140224154745.GL8264@linux.vnet.ibm.com>
In-Reply-To: <20140224154745.GL8264@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/24/2014 11:47 PM, Paul E. McKenney wrote:
> On Mon, Feb 24, 2014 at 04:25:25PM +0800, wyang wrote:
>> Hi Paul,
>>
>> I ran into a cpu stall warning in a MIPS board with 3.10 kernel, I
>> noted you push a patch(c896054f) to reduce default RCU CPU stall
>> warning timeout to 21s.
>> why is it 21s? what decide this time?  seems this time is too short
>> for MIPS, can I retore it to 60s? Do you give me any suggestion on
>> this issue?
> Well, if you want a 60-second timeout, you can boot with something
> like rcupdate.rcu_cpu_stall_timeout=60.
>
> That said, it is worth checking to see if the stall you are seeing is
> the symptom of a problem that needs to be fixed.  For example, are you
> having some problems with netlink?
Hi Paul,

Thank you for your response. Hmm, I also tried to fix it, but 
unfortunately I always got random call traces, I only posted one of them 
in previous email.
You note that timer interrupt happens in netlink and then checks the 
rcu, finially triggers the warning, but sometime it occurs somewhere else.
You can check the other call tarce posted by me. so I guess whehter its 
neccessary to increase the default RCU cpu stall warning timeout.

INFO: rcu_preempt self-detected stall on CPUINFO: rcu_preempt 
self-detected stall on CPU { 2} (t=2100 jiffies g=18446744073709551438 
c=18446744073709551437 q=154)
CPU: 2 PID: 188 Comm: udevd Not tainted 3.10.19 #1
Stack : c0000000f1d5f2d0 ffffffffc1bfdf30 c0000000f1d5f2e0 ffffffffc10a961c
ffffffffc1c00000 0000000000000004 c0000000f1d5f300 ffffffffc107537c
ffffffffc1f80000 0000000000000000 c0000000f1d5f320 ffffffffc1c00000
c0000000f1d5f330 ffffffffc1076234 0000000000000000 0000000000000000
0000000000000000 ffffffffc1f60000 ffffffffc1f61248 ffffffffc1f60000
ffffffffc1a753f8 ffffffffc1bed2b7 ffffffffc1f61248 c0000000fb62ae30
00000000000000bc 0000000000000002 ffffffffc1be0000 c0000000f0400c20
c0000000f1d5f3b0 c0000000f1d5f2c0 c0000000f1d5f3d8 ffffffffc1118550
c0000000f1d5f410 ffffffffc1077cd8 c0000000fb62aaa0 ffffffffc1a753f8
0000000000000002 ffffffffc1048eb8 0000000000000000 0000000000000000
...
Call Trace:
[<ffffffffc1048eb8>] show_stack+0xd8/0xf8
[<ffffffffc1118550>] rcu_check_callbacks+0x3a8/0x9d8
[<ffffffffc1088a00>] update_process_times+0x60/0xa8
[<ffffffffc10d638c>] tick_sched_handle.isra.14+0x54/0x70
[<ffffffffc10d63fc>] tick_sched_timer+0x54/0x90
[<ffffffffc10a6a94>] __run_hrtimer+0xa4/0x298
[<ffffffffc10a7858>] hrtimer_interrupt+0x148/0x2e0
[<ffffffffc104d2b8>] c0_compare_interrupt+0x98/0xe8
[<ffffffffc110d61c>] handle_irq_event_percpu+0x84/0x368
[<ffffffffc11123f0>] handle_percpu_irq+0xa0/0xe8
[<ffffffffc110c9ec>] generic_handle_irq+0x4c/0x80
[<ffffffffc1947a6c>] do_IRQ+0x2c/0x40
[<ffffffffc10346b8>] plat_irq_dispatch+0x390/0x418
[<ffffffffc1042580>] ret_from_irq+0x0/0x4
[<ffffffffc14d95c4>] ebitmap_get_bit+0xc4/0xe0
[<ffffffffc14e9e34>] mls_level_isvalid+0x15c/0x1d8
[<ffffffffc14e9ee0>] mls_range_isvalid+0x30/0x98
[<ffffffffc14e9fa8>] mls_context_isvalid+0x60/0x120
[<ffffffffc14e0608>] policydb_context_isvalid+0xf8/0x120
[<ffffffffc14e4df0>] security_compute_sid.part.11+0x3f8/0x538
[<ffffffffc14cefa8>] selinux_inode_init_security+0xd8/0x340
[<ffffffffc14c6b5c>] security_inode_init_security+0x124/0x158
[<ffffffffc1172e7c>] shmem_mknod+0x64/0x168
[<ffffffffc11cb0b0>] vfs_create+0x140/0x170
[<ffffffffc11cd678>] do_last.isra.40+0x938/0xdd0
[<ffffffffc11cdbcc>] path_openat.isra.41+0xbc/0x4f0
[<ffffffffc11cf09c>] do_filp_open+0x4c/0xc0
[<ffffffffc11ba620>] do_sys_open+0x130/0x220
[<ffffffffc104fd64>] handle_sys64+0x44/0x68

Thanks
Wei
>
> 							Thanx, Paul
>
>
>> Thanks
>> Wei
>> [   34.480000] [sched_delayed] sched: RT throttling activated
>> [   54.230000] INFO: rcu_preempt self-detected stall on CPU
>> [   54.230000] INFO: rcu_preempt self-detected stall on CPU
>>
>> [   54.230000]     5: (2099 ticks this GP)
>> idle=cf7/140000000000001/0 softirq=63/70
>> [   54.230000]
>> [   54.230000]  (t=2100 jiffies g=18446744073709551451
>> c=18446744073709551450 q=682)
>> [   54.230000] CPU: 5 PID: 133 Comm: udevd Not tainted
>> 3.10.19-WR6.0.0.0_cgl #5
>> [   54.230000] Stack : c0000000f5fcf170 ffffffffc1b2dfb0
>> c0000000f5fcf180 ffffffffc10abd8c
>>   ffffffffc1b30000 0000000000000004 c0000000f5fcf1a0 ffffffffc10776fc
>>   ffffffffc1eb0000  0000000000000000  c0000000f5fcf1c0 ffffffffc1b30000
>>   c0000000f5fcf1d0  ffffffffc10785b4  0000000000000000 0000000000000000
>>   0000000000000000  ffffffffc1e90000  ffffffffc1e912c8 ffffffffc1e90000
>>   ffffffffc19bb388  ffffffffc1b1d277  ffffffffc1e912c8 c0000000f5d04c68
>>   0000000000000085 0000000000000005  ffffffffc1b10000 ffffffffc1b10000
>>   c0000000f5fcf250  c0000000f5fcf160  c0000000f5fcf278 ffffffffc111bbb0
>>   c0000000f5fcf2b0  ffffffffc107a058  c0000000f5d048d8 ffffffffc19bb388
>>   0000000000000005  ffffffffc1048e38  0000000000000000 0000000000000000
>>
>>
>> [   54.230000] Call Trace:
>> [   54.230000] [<ffffffffc1048e38>] show_stack+0xd8/0xf8
>> [   54.230000] [<ffffffffc111bbb0>] rcu_check_callbacks+0x400/0xa80
>> [   54.230000] [<ffffffffc108ae00>] update_process_times+0x60/0xa8
>> [   54.230000] [<ffffffffc10d7d3c>] tick_sched_timer+0x54/0x90
>> [   54.230000] [<ffffffffc10a91f4>] __run_hrtimer+0xa4/0x298
>> [   54.230000] [<ffffffffc10a9fb8>] hrtimer_interrupt+0x148/0x2e0
>> [   54.230000] [<ffffffffc104d238>] c0_compare_interrupt+0x98/0xe8
>> [   54.230000] [<ffffffffc1110b1c>] handle_irq_event_percpu+0x84/0x368
>> [   54.230000] [<ffffffffc11158f0>] handle_percpu_irq+0xa0/0xe8
>> [   54.230000] [<ffffffffc110feec>] generic_handle_irq+0x4c/0x80
>> [   54.230000] [<ffffffffc189f90c>] do_IRQ+0x2c/0x40
>> [   54.230000] [<ffffffffc1034650>] plat_irq_dispatch+0x380/0x3d0
>> [   54.230000] [<ffffffffc1042500>] ret_from_irq+0x0/0x4
>> [   54.230000] [<ffffffffc1898844>] __schedule+0x4dc/0xa48
>> [   54.230000] [<ffffffffc18991dc>] preempt_schedule+0x54/0x78
>> [   54.230000] [<ffffffffc1716e70>] sock_def_readable+0x50/0x88
>> [   54.230000] [<ffffffffc176888c>] netlink_sendskb+0x44/0xb8
>> [   54.230000] [<ffffffffc1768b88>] netlink_unicast+0x288/0x2e0
>> [   54.230000] [<ffffffffc1769010>] netlink_sendmsg+0x2e0/0x3d8
>> [   54.230000] [<ffffffffc1710a38>] sock_sendmsg+0xe8/0x128
>> [   54.230000] [<ffffffffc1711cc0>] ___sys_sendmsg+0x378/0x388
>> [   54.230000] [<ffffffffc1713b54>] __sys_sendmsg+0x5c/0xc0
>> [   54.230000] [<ffffffffc104fce4>] handle_sys64+0x44/0x68
>> [   54.410000]     1: (2099 ticks this GP)
>> idle=d7d/140000000000001/0 softirq=131/134
>> [   54.420000]      (t=2119 jiffies g=18446744073709551451
>> c=18446744073709551450 q=682)
>> [   54.430000] CPU: 1 PID: 70 Comm: irq/23-eth%d Not tainted
>> 3.10.19-WR6.0.0.0_cgl #5
>> [   54.430000] Stack : c0000000f4d7f4c0 ffffffffc107809c
>> 0000000000000001 0000000000000285
>>        ffffffffc1b30000 0000000000000004 0000000000000001 0000000000000000
>>        c0000000f4d7f500 ffffffffc1077e9c 0000000000000046 ffffffffc1b30000
>>        c0000000f4d7f520 ffffffffc107850c 0000000000000000 0000000000000000
>>        0000000000000000 ffffffffc1e90000 ffffffffc1e912c8 ffffffffc1e90000
>>        ffffffffc19bb388 ffffffffc1b1d277 ffffffffc1e912c8 c0000000f8c35c98
>>        0000000000000046 0000000000000001 ffffffffc1b10000 ffffffffc1b10000
>>        c0000000f4d7f5a0 c0000000f4d7f4b0 c0000000f4d7f5c8 ffffffffc111bbb0
>>        c0000000f4d7f600 ffffffffc107a058 c0000000f8c35908 ffffffffc19bb388
>>        0000000000000001 ffffffffc1048e38 0000000000000000 0000000000000000
>>        ...
>> [   54.500000] Call Trace:
>> [   54.500000] [<ffffffffc1048e38>] show_stack+0xd8/0xf8
>> [   54.500000] [<ffffffffc111bbb0>] rcu_check_callbacks+0x400/0xa80
>> [   54.510000] [<ffffffffc108ae00>] update_process_times+0x60/0xa8
>> [   54.510000] [<ffffffffc10d7d3c>] tick_sched_timer+0x54/0x90
>> [   54.510000] [<ffffffffc10a91f4>] __run_hrtimer+0xa4/0x298
>> [   54.520000] [<ffffffffc10a9fb8>] hrtimer_interrupt+0x148/0x2e0
>> [   54.520000] [<ffffffffc104d238>] c0_compare_interrupt+0x98/0xe8
>> [   54.530000] [<ffffffffc1110b1c>] handle_irq_event_percpu+0x84/0x368
>> [   54.530000] [<ffffffffc11158f0>] handle_percpu_irq+0xa0/0xe8
>> [   54.540000] [<ffffffffc110feec>] generic_handle_irq+0x4c/0x80
>> [   54.540000] [<ffffffffc189f90c>] do_IRQ+0x2c/0x40
>> [   54.540000] [<ffffffffc1034650>] plat_irq_dispatch+0x380/0x3d0
>> [   54.550000] [<ffffffffc1042500>] ret_from_irq+0x0/0x4
>> [   54.550000] [<ffffffffc1774614>] ip_rcv_finish+0x2b4/0x3c8
>> [   54.560000] [<ffffffffc172f710>] __netif_receive_skb_core+0x370/0x9d0
>> [   54.560000] [<ffffffffc172fe6c>] netif_receive_skb+0x4c/0xf0
>> [   54.570000] [<ffffffffc161b974>] smsc911x_poll+0x11c/0x2b0
>> [   54.570000] [<ffffffffc1731754>] net_rx_action+0x1ac/0x320
>> [   54.570000] [<ffffffffc107f910>] __do_softirq+0x150/0x340
>> [   54.580000] [<ffffffffc107fc60>] do_softirq+0xb8/0xc0
>> [   54.580000] [<ffffffffc107fe6c>] local_bh_enable+0xfc/0x108
>> [   54.590000] [<ffffffffc1111d38>] irq_forced_thread_fn+0x68/0x90
>> [   54.590000] [<ffffffffc1112190>] irq_thread+0x160/0x1f8
>> [   54.600000] [<ffffffffc10a47d4>] kthread+0xcc/0xd8
>> [   54.600000] [<ffffffffc104258c>] ret_from_kernel_thread+0x14/0x1c
>>
>> [  117.260000] INFO: rcu_preempt self-detected stall on CPU
>> [  117.260000]     7: (8402 ticks this GP)
>> idle=c6f/140000000000001/0 softirq=379/383
>> [  117.270000]      (t=8404 jiffies g=18446744073709551451
>> c=18446744073709551450 q=690)
>> [  117.280000] INFO: rcu_preempt detected stalls on CPUs/tasks:
>> [  117.280000]     7: (8402 ticks this GP)
>> idle=c6f/140000000000001/0 softirq=379/383
>> [  117.280000]     (detected by 0, t=8405 jiffies,
>> g=18446744073709551451, c=18446744073709551450, q=690)
>> [  117.280000] Task dump for CPU 7:
>> [  117.280000] ksoftirqd/7     R  running task        0    36      2
>> 0x00100004
>> [  117.280000] Stack : 0000000080e0b38a 80e0a5140b010000
>> 80e0a51480e0a514 c0000000f873fac0
>>        000002fe00000000 c0000000f5a306c0 c0000000f8ac1710 ffffffff80e0b38a
>>        000000000000000b 0000000000000001 c0000000f873fbb8 ffffffffc189a15c
>>        c0000000f5a34380 ffffffffc1b7aa80 c0000000f5a18300 ffffffffc1775e50
>>        c0000000f5a34380 ffffffffc1b90000 c0000000f5a34388 0000000000000007
>>        c0000000f873fc08 ffffffffc1775ff0 c0000000f5a342c0 c0000000f8598000
>>        c0000000f5a34388 0000000000000100 c0000000f873fc38 ffffffffc10898d0
>>        c0000000f5a327c8 c0000000f8598000 0000000000000000 ffffffffc1775e50
>>        c0000000f5a34380 0000000000200200 c0000000f873fc78 ffffffffc1089d08
>>        c0000000f873fc78 c0000000f873fc78 c0000000f8599028 c0000000f8599428
>>        ...
>> [  117.280000] Call Trace:
>> [  117.280000] [<ffffffffc1898814>] __schedule+0x4ac/0xa48
>> [  117.280000] [<ffffffffc10afc30>] smpboot_thread_fn+0x280/0x320
>> [  117.280000] [<ffffffffc10a47d4>] kthread+0xcc/0xd8
>> [  117.280000] [<ffffffffc104258c>] ret_from_kernel_thread+0x14/0x1c
>>
>> [  117.380000] CPU: 7 PID: 36 Comm: ksoftirqd/7 Not tainted
>> 3.10.19-WR6.0.0.0_cgl #5
>> [  117.390000] Stack : c0000000f873f3e0 ffffffffc107809c
>> 0000000000000001 00000000000002b1
>>        ffffffffc1b30000 0000000000000004 0000000000000001 0000000000000000
>>        c0000000f873f420 ffffffffc1077e9c 0000000000000045 ffffffffc1b30000
>>        c0000000f873f440 ffffffffc107850c 0000000000000000 0000000000000000
>>        0000000000000000 ffffffffc1e90000 ffffffffc1e912c8 ffffffffc1e90000
>>        ffffffffc19bb388 ffffffffc1b1d277 ffffffffc1e912c8 c0000000f84c5c98
>>        0000000000000024 0000000000000007 ffffffffc1b10000 ffffffffc1b10000
>>        c0000000f873f4c0 c0000000f873f3d0 c0000000f873f4e8 ffffffffc111bbb0
>>        c0000000f873f520 ffffffffc107a058 c0000000f84c5908 ffffffffc19bb388
>>        0000000000000007 ffffffffc1048e38 0000000000000000 0000000000000000
>>        ...
>> [  117.450000] Call Trace:
>> [  117.450000] [<ffffffffc1048e38>] show_stack+0xd8/0xf8
>> [  117.460000] [<ffffffffc111bbb0>] rcu_check_callbacks+0x400/0xa80
>> [  117.460000] [<ffffffffc108ae00>] update_process_times+0x60/0xa8
>> [  117.470000] [<ffffffffc10d7d3c>] tick_sched_timer+0x54/0x90
>> [  117.470000] [<ffffffffc10a91f4>] __run_hrtimer+0xa4/0x298
>> [  117.470000] [<ffffffffc10a9fb8>] hrtimer_interrupt+0x148/0x2e0
>> [  117.480000] [<ffffffffc104d238>] c0_compare_interrupt+0x98/0xe8
>> [  117.480000] [<ffffffffc1110b1c>] handle_irq_event_percpu+0x84/0x368
>> [  117.490000] [<ffffffffc11158f0>] handle_percpu_irq+0xa0/0xe8
>> [  117.490000] [<ffffffffc110feec>] generic_handle_irq+0x4c/0x80
>> [  117.500000] [<ffffffffc189f90c>] do_IRQ+0x2c/0x40
>> [  117.500000] [<ffffffffc1034650>] plat_irq_dispatch+0x380/0x3d0
>> [  117.510000] [<ffffffffc1042500>] ret_from_irq+0x0/0x4
>> [  117.510000] [<ffffffffc17dfdd4>] xfrm_lookup+0x284/0x5d8
>> [  117.510000] [<ffffffffc17af814>] icmp_send+0x5d4/0x680
>> [  117.520000] [<ffffffffc1775ff0>] ip_expire+0x1a0/0x1e0
>> [  117.520000] [<ffffffffc10898d0>] call_timer_fn+0x58/0x1a0
>> [  117.530000] [<ffffffffc1089d08>] run_timer_softirq+0x1f8/0x2d0
>> [  117.530000] [<ffffffffc107f910>] __do_softirq+0x150/0x340
>> [  117.530000] [<ffffffffc107fb80>] run_ksoftirqd+0x80/0xa8
>> [  117.540000] [<ffffffffc10afc30>] smpboot_thread_fn+0x280/0x320
>> [  117.540000] [<ffffffffc10a47d4>] kthread+0xcc/0xd8
>> [  117.550000] [<ffffffffc104258c>] ret_from_kernel_thread+0x14/0x1c
>>
>

