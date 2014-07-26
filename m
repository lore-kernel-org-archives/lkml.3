Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaGZDOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 23:14:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51676 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaGZDOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 23:14:45 -0400
Message-ID: <53D31D16.1030806@oracle.com>
Date: Fri, 25 Jul 2014 23:14:30 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: dhowells@redhat.com, James Morris <james.l.morris@oracle.com>,
        serge@hallyn.com
CC: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: security: oops on boot in __key_link_begin
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm (sometimes) seeing the following when booting the most recent -next kernel:

[   31.319902] Loading compiled-in X.509 certificates
[   31.328118] BUG: unable to handle kernel paging request at ffffffff8b49ff42
[   31.328981] IP: assoc_array_insert (lib/assoc_array.c:480 lib/assoc_array.c:1021)
[   31.329703] PGD 25a25067 PUD 25a26063 PMD 0
[   31.330218] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   31.330473] Dumping ftrace buffer:
[   31.330473]    (ftrace buffer empty)
[   31.330473] Modules linked in:
[   31.330473] CPU: 29 PID: 1 Comm: swapper/0 Tainted: G        W      3.16.0-rc6-next-20140725-sasha-00048-ga713fc0-dirty #937
[   31.330473] task: ffff8805f9c40000 ti: ffff88030bcd4000 task.ti: ffff88030bcd4000
[   31.330473] RIP: assoc_array_insert (lib/assoc_array.c:480 lib/assoc_array.c:1021)
[   31.330473] RSP: 0000:ffff88030bcd7bc8  EFLAGS: 00010246
[   31.330473] RAX: 0000000000000000 RBX: ffff8805f56ac208 RCX: dfff970a48e00000
[   31.330473] RDX: ffff880a375b9b38 RSI: 00000000000000fc RDI: ffff880a375b9a50
[   31.330473] RBP: ffff88030bcd7cc8 R08: 0000000000000004 R09: 0000000000000004
[   31.330473] R10: ffff880b078d5854 R11: 0000000000000000 R12: ffff8805f56ac209
[   31.330473] R13: ffffffffa41c0880 R14: ffff88030bcd7d30 R15: ffff880a375b9a40
[   31.330473] FS:  0000000000000000(0000) GS:ffff8805ffc00000(0000) knlGS:0000000000000000
[   31.330473] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   31.330473] CR2: ffffffff8b49ff42 CR3: 0000000025a22000 CR4: 00000000000006a0
[   31.330473] Stack:
[   31.330473]  ffff88030bcd7cc8 ffff8805f9c40000 ffffffffa7b8d5a0 0000000000000001
[   31.330473]  ffff8803095f8090 ffff88030bcd7c08 ffffffff9f2115cd 0000000000000001
[   31.330473]  ffff88030bcd7c20 ffffffff9f2117b1 0000000000000000 ffff88030bcd7c30
[   31.330473] Call Trace:
[   31.330473] ? get_parent_ip (kernel/sched/core.c:2561)
[   31.330473] ? preempt_count_sub (kernel/sched/core.c:2617)
[   31.330473] ? put_lock_stats.isra.13 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[   31.330473] ? __key_link_begin (./arch/x86/include/asm/bitops.h:311 security/keys/keyring.c:1073)
[   31.330473] ? __key_link_begin (./arch/x86/include/asm/bitops.h:311 security/keys/keyring.c:1073)
[   31.330473] __key_link_begin (security/keys/keyring.c:1088)
[   31.330473] key_create_or_update (security/keys/key.c:840 (discriminator 4))
[   31.330473] load_system_certificate_list (kernel/system_keyring.c:88)
[   31.330473] ? system_trusted_keyring_init (kernel/system_keyring.c:56)
[   31.330473] do_one_initcall (init/main.c:792)
[   31.330473] kernel_init_freeable (init/main.c:858 init/main.c:866 init/main.c:885 init/main.c:1006)
[   31.330473] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2600)
[   31.330473] ? do_one_initcall (init/main.c:933)
[   31.330473] kernel_init (init/main.c:938)
[   31.330473] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[   31.330473] ? do_one_initcall (init/main.c:933)
[ 31.330473] Code: 67 40 e8 19 ba 42 ff 48 8d 43 10 49 89 47 30 49 8d bf f0 00 00 00 e8 05 ba 42 ff 48 8b bc 24 88 00 00 00 49 89 9f f0 00 00 00 55 <c1> b8 42 ff 49 8b 5f 10 49 8d bf 00 01 00 00 e8 e1 b9 42 ff 49
All code
========
   0:	67 40 e8 19 ba 42 ff 	addr32 rex callq 0xffffffffff42ba20
   7:	48 8d 43 10          	lea    0x10(%rbx),%rax
   b:	49 89 47 30          	mov    %rax,0x30(%r15)
   f:	49 8d bf f0 00 00 00 	lea    0xf0(%r15),%rdi
  16:	e8 05 ba 42 ff       	callq  0xffffffffff42ba20
  1b:	48 8b bc 24 88 00 00 	mov    0x88(%rsp),%rdi
  22:	00
  23:	49 89 9f f0 00 00 00 	mov    %rbx,0xf0(%r15)
  2a:	55                   	push   %rbp
  2b:*	c1 b8 42 ff 49 8b 5f 	sarl   $0x5f,-0x74b600be(%rax)		<-- trapping instruction
  32:	10 49 8d             	adc    %cl,-0x73(%rcx)
  35:	bf 00 01 00 00       	mov    $0x100,%edi
  3a:	e8 e1 b9 42 ff       	callq  0xffffffffff42ba20
  3f:	49                   	rex.WB
	...

Code starting with the faulting instruction
===========================================
   0:	c1 b8 42 ff 49 8b 5f 	sarl   $0x5f,-0x74b600be(%rax)
   7:	10 49 8d             	adc    %cl,-0x73(%rcx)
   a:	bf 00 01 00 00       	mov    $0x100,%edi
   f:	e8 e1 b9 42 ff       	callq  0xffffffffff42b9f5
  14:	49                   	rex.WB
	...
[   31.330473] RIP assoc_array_insert (lib/assoc_array.c:480 lib/assoc_array.c:1021)
[   31.330473]  RSP <ffff88030bcd7bc8>
[   31.330473] CR2: ffffffff8b49ff42


Thanks,
Sasha
