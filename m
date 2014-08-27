Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935428AbaH0QLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:11:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38336 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935137AbaH0QLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:11:17 -0400
Message-ID: <53FE02E4.9010900@oracle.com>
Date: Wed, 27 Aug 2014 12:10:12 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, serge@hallyn.com
CC: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: keys: NULL ptr deref in key_alloc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[ 1587.614996] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[ 1587.619523] IP: rb_insert_color (lib/rbtree.c:94 lib/rbtree.c:388)
[ 1587.620675] PGD 29dead067 PUD 36687c067 PMD 0
[ 1587.621618] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1587.623858] Dumping ftrace buffer:
[ 1587.624346]    (ftrace buffer empty)
[ 1587.624346] Modules linked in:
[ 1587.624346] CPU: 16 PID: 23740 Comm: trinity-c574 Not tainted 3.17.0-rc2-next-20140827-sasha-00031-g9ff673f #1080
[ 1587.624346] task: ffff8803a49f3000 ti: ffff88040f394000 task.ti: ffff88040f394000
[ 1587.624346] RIP: rb_insert_color (lib/rbtree.c:94 lib/rbtree.c:388)
[ 1587.624346] RSP: 0018:ffff88040f397dd0  EFLAGS: 00010246
[ 1587.635541] RAX: ffff880372fa4c88 RBX: ffff880271300c84 RCX: 0000000000000000
[ 1587.635541] RDX: 0000000000000000 RSI: ffffffff9c9e9be0 RDI: ffff880271300c88
[ 1587.635541] RBP: ffff88040f397dd0 R08: 0000000000000000 R09: 0000000000000001
[ 1587.635541] R10: 000000000000cb01 R11: 0000000000000001 R12: ffffffff9adaf940
[ 1587.635541] R13: 00000000000000a6 R14: ffff88009bf7a760 R15: ffff880271300c80
[ 1587.635541] FS:  00007f28f4711700(0000) GS:ffff880278200000(0000) knlGS:0000000000000000
[ 1587.635541] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1587.635541] CR2: 0000000000000008 CR3: 000000029da66000 CR4: 00000000000006a0
[ 1587.635541] Stack:
[ 1587.635541]  ffff88040f397e40 ffffffff95a5698f 00000005000000d0 ffff88009bf7a820
[ 1587.635541]  0000000000000000 0000000000000004 ffff880272117400 000036363f010000
[ 1587.635541]  0000000000000005 ffff880272117400 0000000000000003 ffff8803a49f3000
[ 1587.635541] Call Trace:
[ 1587.635541] key_alloc (include/linux/spinlock.h:349 security/keys/key.c:172 security/keys/key.c:313)
[ 1587.635541] keyring_alloc (security/keys/keyring.c:500)
[ 1587.635541] ? creds_are_invalid (kernel/cred.c:701)
[ 1587.635541] install_thread_keyring_to_cred (security/keys/process_keys.c:138)
[ 1587.635541] lookup_user_key (security/keys/process_keys.c:160 security/keys/process_keys.c:538)
[ 1587.635541] ? key_validate (security/keys/process_keys.c:493)
[ 1587.635541] keyctl_set_timeout (include/linux/err.h:35 security/keys/keyctl.c:1334)
[ 1587.635541] SyS_keyctl (security/keys/keyctl.c:1585)
[ 1587.635541] tracesys (arch/x86/kernel/entry_64.S:542)
[ 1587.635541] Code: 8b 50 08 48 85 d2 75 eb 5d c3 31 c0 5d c3 0f 1f 44 00 00 55 48 8b 07 48 89 e5 48 85 c0 0f 84 21 01 00 00 48 8b 10 f6 c2 01 75 62 <48> 8b 4a 08 49 89 d0 48 39 c8 0f 84 93 00 00 00 48 85 c9 74 05
All code
========
   0:	8b 50 08             	mov    0x8(%rax),%edx
   3:	48 85 d2             	test   %rdx,%rdx
   6:	75 eb                	jne    0xfffffffffffffff3
   8:	5d                   	pop    %rbp
   9:	c3                   	retq
   a:	31 c0                	xor    %eax,%eax
   c:	5d                   	pop    %rbp
   d:	c3                   	retq
   e:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  13:	55                   	push   %rbp
  14:	48 8b 07             	mov    (%rdi),%rax
  17:	48 89 e5             	mov    %rsp,%rbp
  1a:	48 85 c0             	test   %rax,%rax
  1d:	0f 84 21 01 00 00    	je     0x144
  23:	48 8b 10             	mov    (%rax),%rdx
  26:	f6 c2 01             	test   $0x1,%dl
  29:	75 62                	jne    0x8d
  2b:*	48 8b 4a 08          	mov    0x8(%rdx),%rcx		<-- trapping instruction
  2f:	49 89 d0             	mov    %rdx,%r8
  32:	48 39 c8             	cmp    %rcx,%rax
  35:	0f 84 93 00 00 00    	je     0xce
  3b:	48 85 c9             	test   %rcx,%rcx
  3e:	74 05                	je     0x45
	...

Code starting with the faulting instruction
===========================================
   0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   4:	49 89 d0             	mov    %rdx,%r8
   7:	48 39 c8             	cmp    %rcx,%rax
   a:	0f 84 93 00 00 00    	je     0xa3
  10:	48 85 c9             	test   %rcx,%rcx
  13:	74 05                	je     0x1a
	...
[ 1587.635541] RIP rb_insert_color (lib/rbtree.c:94 lib/rbtree.c:388)
[ 1587.635541]  RSP <ffff88040f397dd0>
[ 1587.635541] CR2: 0000000000000008


Thanks,
Sasha
