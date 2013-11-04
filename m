Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3KDOY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:24:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab3KDOY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:24:27 -0500
Message-ID: <5277AE11.2030006@redhat.com>
Date: Mon, 04 Nov 2013 15:24:17 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [crc32] INFO: rcu_sched self-detected stall on CPU { 0}  (t=2101
 jiffies g=4294967081 c=4294967080 q=41)
References: <20131104141355.GB17177@localhost>
In-Reply-To: <20131104141355.GB17177@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 03:13 PM, Fengguang Wu wrote:
> Hi Daniel,
>
> Is it expected for this commit to trigger the rcu stall warnings?
> The warnings are 100% reproducible with the attached kconfig.

Didn't hit in on my tests with CONFIG_CRC32_SELFTEST=y, but I'm working on a
patch asap to address this. Thanks!

> commit efba721f636ee016859d86d15748650119402b10
> Author: Daniel Borkmann <dborkman@redhat.com>
> Date:   Wed Oct 30 11:50:50 2013 +0100
>
>      lib: crc32: add test cases for crc32{, c}_combine routines
>
>      We already have 100 test cases for crcs itself, so split the test
>      buffer with a-prio known checksums, and test crc of two blocks
>      against crc of the whole block for the same results.
>
>      Output/result with CONFIG_CRC32_SELFTEST=y:
>
>        [    2.687095] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
>        [    2.687097] crc32: self tests passed, processed 225944 bytes in 278177 nsec
>        [    2.687383] crc32c: CRC_LE_BITS = 64
>        [    2.687385] crc32c: self tests passed, processed 225944 bytes in 141708 nsec
>        [    7.336771] crc32_combine: 113072 self tests passed
>        [   12.050479] crc32c_combine: 113072 self tests passed
>        [   17.633089] alg: No test for crc32 (crc32-pclmul)
>
>      Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>      Cc: linux-kernel@vger.kernel.org
>      Signed-off-by: David S. Miller <davem@davemloft.net>
>
> [    2.364402] crc32c: CRC_LE_BITS = 1
> [    2.364953] crc32c: self tests passed, processed 225944 bytes in 5680877 nsec
> [   16.143376] crc32_combine: 113072 self tests passed
> [   23.340041] INFO: rcu_sched self-detected stall on CPU { 0}  (t=2101 jiffies g=4294967081 c=4294967080 q=41)
> [   23.340041] sending NMI to all CPUs:
> [   23.340041] NMI backtrace for cpu 0
> [   23.340041] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc6-01322-gf421436 #414
> [   23.340041] task: 80138000 ti: 80140000 task.ti: 80140000
> [   23.340041] EIP: 0060:[<81057de4>] EFLAGS: 00010046 CPU: 0
> [   23.340041] EIP is at default_send_IPI_mask_logical+0x164/0x1f0
> [   23.340041] EAX: fffff000 EBX: 03000000 ECX: fffff000 EDX: 00000c00
> [   23.340041] ESI: 00000046 EDI: 00000002 EBP: 80141ce0 ESP: 80141cd0
> [   23.340041]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   23.340041] CR0: 8005003b CR2: 00000000 CR3: 01bed000 CR4: 000006d0
> [   23.340041] Stack:
> [   23.340041]  00000800 00002710 8dbba1a0 81967b80 80141cec 81057fac 00002710 80141cfc
> [   23.340041]  81058691 818908e0 00000029 80141d40 8115cdec 818a7884 00000835 ffffff29
> [   23.340041]  ffffff28 00000029 80141d40 810cfe5d 00000001 80140000 8dbba1a0 00000000
> [   23.340041] Call Trace:
> [   23.340041]  [<81057fac>] default_send_IPI_all+0x2c/0xd0
> [   23.340041]  [<81058691>] arch_trigger_all_cpu_backtrace+0x91/0x130
> [   23.340041]  [<8115cdec>] rcu_check_callbacks+0x35c/0xa40
> [   23.340041]  [<810cfe5d>] ? account_process_tick+0x1ed/0x2e0
> [   23.340041]  [<8108eeef>] update_process_times+0x6f/0xe0
> [   23.340041]  [<81115d01>] tick_sched_handle.isra.12+0x71/0xa0
> [   23.340041]  [<81115d9a>] tick_sched_timer+0x6a/0xc0
> [   23.340041]  [<810b57e7>] __run_hrtimer.isra.17+0xc7/0x1b0
> [   23.340041]  [<81115d30>] ? tick_sched_handle.isra.12+0xa0/0xa0
> [   23.340041]  [<810b6833>] hrtimer_interrupt+0x1b3/0x3d0
> [   23.340041]  [<8115bd29>] ? rcu_irq_enter+0x139/0x190
> [   23.340041]  [<810548c1>] local_apic_timer_interrupt+0x81/0xa0
> [   23.340041]  [<81085b0e>] ? irq_enter+0x1e/0xf0
> [   23.340041]  [<81054d28>] smp_apic_timer_interrupt+0x58/0x90
> [   23.340041]  [<816ab692>] apic_timer_interrupt+0x36/0x3c
> [   23.340041]  [<81a5eeed>] ? crc32test_init+0x11c2/0x1317
> [   23.340041]  [<81a5dd2b>] ? debug_objects_mem_init+0x3eb/0x3eb
> [   23.340041]  [<81000440>] do_one_initcall+0x100/0x250
> [   23.340041]  [<810ac931>] ? parameq+0x21/0xf0
> [   23.340041]  [<81a1e700>] ? do_early_param+0x110/0x12b
> [   23.340041]  [<810acdf2>] ? parse_args+0x3f2/0x5d0
> [   23.340041]  [<81a1f94d>] kernel_init_freeable+0x2e4/0x47a
> [   23.340041]  [<81a1e71b>] ? do_early_param+0x12b/0x12b
> [   23.340041]  [<8168b8f9>] kernel_init+0x19/0x290
> [   23.340041]  [<816abaf7>] ret_from_kernel_thread+0x1b/0x28
> [   23.340041]  [<8168b8e0>] ? rest_init+0x190/0x190
> [   23.340041] Code: f8 a4 c1 81 01 83 15 fc a4 c1 81 00 eb 12 90 80 ce 04 83 05 00 a5 c1 81 01 83 15 04 a5 c1 81 00 a1 10 87 94 81 89 90 00 c3 ff ff <f7> c6 00 02 00 00 75 3c 83 05 08 a5 c1 81 01 89 f0 83 15 0c a5
> [   23.350050] NMI backtrace for cpu 1
> [   23.350050] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.12.0-rc6-01322-gf421436 #414
> [   23.350050] task: 8015d2c0 ti: 80176000 task.ti: 80176000
> [   23.350050] EIP: 0060:[<81064ae3>] EFLAGS: 00200246 CPU: 1
> [   23.350050] EIP is at native_safe_halt+0x13/0x30
> [   23.350050] EAX: 8015d2c0 EBX: 80176000 ECX: 00000000 EDX: 00000001
> [   23.350050] ESI: ffffffff EDI: ffff8ba1 EBP: 80177f60 ESP: 80177f60
> [   23.350050]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   23.350050] CR0: 8005003b CR2: ffffffff CR3: 01bed000 CR4: 000006d0
> [   23.350050] Stack:
> [   23.350050]  80177f68 81014509 80177f70 810156ae 80177f88 810f6cea 46a4dfe6 55086500
> [   23.350050]  8f51f76f 8fffc440 80177fb4 810521cb d8d4b9d1 051b2406 a1acbf74 c2cf5d8e
> [   23.350050]  ff810013 8f51f76f 01000800 00000000 00000000 00000000 00000000 00000000
> [   23.350050] Call Trace:
> [   23.350050]  [<81014509>] default_idle+0x29/0x40
> [   23.350050]  [<810156ae>] arch_cpu_idle+0x2e/0x80
> [   23.350050]  [<810f6cea>] cpu_startup_entry+0x2aa/0x3e0
> [   23.350050]  [<810521cb>] start_secondary+0x5eb/0x630
> [   23.350050] Code: 01 83 15 a4 50 c2 81 00 5d c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 83 05 a8 50 c2 81 01 89 e5 83 15 ac 50 c2 81 00 fb f4 <83> 05 b0 50 c2 81 01 83 15 b4 50 c2 81 00 5d c3 8d b6 00 00 00
>
> git bisect start f421436a591d34fa5279b54a96ac07d70250cc8d dcb30e659287a6b40dafed1362532da42ec27229 --
> git bisect good 53af53ae83fe960ceb9ef74cac7915e9088f4266  # 20:03     20+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> git bisect good db10accfd266a93149cd21cd75026aa03c635e7e  # 20:11     20+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> git bisect good 5f258a1552d1a8fd263346635022fdf16aa06d6a  # 20:18     20+      0  net: dl2k: remove unnecessary pci_set_drvdata()
> git bisect good b45bd46decd947eaa3497699d450e0851d247534  # 20:25     20+      0  Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
> git bisect good 6c7a9a3c7838eab1f17ef00c87925151be06cf1c  # 20:33     20+      0  mvneta: drop redundant mac address check
> git bisect good bed6f762123fc53c63efef386531dd877cba2468  # 20:41     20+      0  net: cdc_ncm: remove redundant netdev field
> git bisect good 59ede3168a0b3fe02f82a7bed52432f18dbb1070  # 20:50     20+      0  net: cdc_ncm: return proper error if setup fails
> git bisect good 296c10639a33941d0090afa17b7535fcbf81d97a  # 20:58     20+      0  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
> git bisect  bad 2817a336d4d533fb8b68719723cd60ea7dd7c09e  # 21:01      0-      5  net: skb_checksum: allow custom update/combine for walking skb
> git bisect good 6e95fcaa42e5078ac265964deebed597f9eae07a  # 21:12     20+      0  lib: crc32: add functionality to combine two crc32{, c}s in GF(2)
> git bisect  bad efba721f636ee016859d86d15748650119402b10  # 21:16      0-      7  lib: crc32: add test cases for crc32{, c}_combine routines
> git bisect good 6e95fcaa42e5078ac265964deebed597f9eae07a  # 21:20     60+      0  lib: crc32: add functionality to combine two crc32{, c}s in GF(2)
> git bisect  bad f421436a591d34fa5279b54a96ac07d70250cc8d  # 21:20      0-     19  net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)
> git bisect good 1e418d9716d909dd6d2afa89c9066f329b62613c  # 21:30     60+      0  Revert "lib: crc32: add test cases for crc32{, c}_combine routines"
> git bisect good 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52  # 21:30     69+      0  Linux 3.12
> git bisect good e3ad71f5e8b6e700a38d5a0da12b29d53600e65e  # 21:34     60+      0  Add linux-next specific files for 20131104
>
> Thanks,
> Fengguang
>
>
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>
