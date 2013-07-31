Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab3GaLYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:24:06 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:48295 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab3GaLYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:24:04 -0400
MIME-Version: 1.0
Date: Wed, 31 Jul 2013 16:54:03 +0530
Message-ID: <CAOaiJ-mNE=1nuaPqd+qUZVsHakm1Mo-j40dXiTeN+nEVLXOvXg@mail.gmail.com>
Subject: ipv4: crash at leaf_walk_rcu
From: vinayak menon <vinayakm.list@gmail.com>
To: linux-kernel@vger.kernel.org, davem@davemloft.net,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Arun KS <getarunks@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A crash was seen on 3.4.5 kernel during some random wlan operations.

CPU: Single core ARM Cortex A9.

fib_route_seq_next was called with second argument (void *v) as
0xd6e3e360 which is a "freed" object of the "ip_fib_trie" cache. I
confirmed that the object was freed with crash utility.

Sequence: fib_route_seq_next->trie_nextleaf->leaf_walk_rcu

As "v" was a freed object, inside trie_nextleaf(), node_parent_rcu()
returned an invalid tnode. But as I had enabled slab poisoning and the
object was already freed, the tnode was 0x6b6b6b6b. And this was
passed to leaf_walk_rcu and resulted in the crash.

fib_route_seq_start, takes rcu_read_lock(), but free_leaf calls
call_rcu_bh. Can this be the problem ?
Should rcu_read_lock() in fib_route_seq_start be changed to rcu_read_lock_bh() ?

----------------------------------------------------------------------------
PC is at leaf_walk_rcu+0x10/0xa0
LR is at fib_route_seq_next+0x58/0x74
pc : [<c0500e5c>]    lr : [<c050108c>]    psr: a0000013
sp : c150bee0  ip : 00000000  fp : 00000000
r10: 00000400  r9 : 53701020  r8 : c32345c0
r7 : 00000000  r6 : 00000001  r5 : 00000000  r4 : 00000002
r3 : 6b6b6b6b  r2 : 00000001  r1 : d6e3e360  r0 : 6b6b6b6a
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c53c7d  Table: 835dc059  DAC: 00000015

Backtrace:
[<c0500e5c>] (leaf_walk_rcu+0x10/0xa0) from [<c050108c>]
(fib_route_seq_next+0x58/0x74)
[<c050108c>] (fib_route_seq_next+0x58/0x74) from [<c011c06c>]
(seq_read+0x2cc/0x438)
[<c011c06c>] (seq_read+0x2cc/0x438) from [<c0145734>] (proc_reg_read+0xb0/0xcc)
[<c0145734>] (proc_reg_read+0xb0/0xcc) from [<c0100798>] (vfs_read+0xac/0x124)
[<c0100798>] (vfs_read+0xac/0x124) from [<c0100848>] (sys_read+0x38/0x64)
[<c0100848>] (sys_read+0x38/0x64) from [<c000e100>] (ret_fast_syscall+0x0/0x48)

Thanks,
Vinayak
