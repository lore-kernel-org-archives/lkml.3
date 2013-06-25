Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3FYJsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:48:19 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:32882 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3FYJsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:48:17 -0400
Message-ID: <1372153697.3301.98.camel@edumazet-glaptop>
Subject: Re: 13GB dcache+inode cache hash tables
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Steffen Persvold <sp@numascale.com>
Date: Tue, 25 Jun 2013 02:48:17 -0700
In-Reply-To: <51C95B3A.10809@numascale-asia.com>
References: <51C95B3A.10809@numascale-asia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 16:56 +0800, Daniel J Blueman wrote:
> As memory capacity increases, we see the dentry and inode cache hash 
> tables grow to wild sizes [1], eg 13GB is consumed on a 4.5TB system.
> 
> Perhaps a better approach adds a linear component to an exponent to give 
> tuned scaling, given that spatial locality is an advantage in hash table 
> and careful use of resources.
> 
> The same approach would fit to other hash tables (mount-cache, TCP 
> established, TCP bind, UDP, UDP-Lite, Dquot-cache) with different 
> coefficients, so perhaps we could generalise.
> 

TCP hash table is limited to 512K slots, unless overridden.
TCP bind limited to 64K slots.
UDP limited to 64K slots.

> If so what are reasonable reference points and assumptions?
> 

I do not know what you have in mind, please show us a patch ;)

I would love if all these hash tables could use hugepages.

vmalloc() is nice for NUMA spreading, but being able to use hugepages
for very large hashes could lower TLB pressure...

# grep alloc_large_system_hash /proc/vmallocinfo 
0xffffc90000002000-0xffffc90004003000 67112960 alloc_large_system_hash+0x153/0x21c pages=16384 vmalloc vpages N0=8192 N1=8192
0xffffc90004003000-0xffffc90004024000  135168 alloc_large_system_hash+0x153/0x21c pages=32 vmalloc N0=16 N1=16
0xffffc90004024000-0xffffc90006025000 33558528 alloc_large_system_hash+0x153/0x21c pages=8192 vmalloc vpages N0=4096 N1=4096
0xffffc90006025000-0xffffc90006036000   69632 alloc_large_system_hash+0x153/0x21c pages=16 vmalloc N0=8 N1=8
0xffffc90006052000-0xffffc90006057000   20480 alloc_large_system_hash+0x153/0x21c pages=4 vmalloc N0=2 N1=2
0xffffc90016081000-0xffffc90016882000 8392704 alloc_large_system_hash+0x153/0x21c pages=2048 vmalloc vpages N0=1024 N1=1024
0xffffc90016882000-0xffffc90016983000 1052672 alloc_large_system_hash+0x153/0x21c pages=256 vmalloc N0=128 N1=128
0xffffc90016983000-0xffffc90016a84000 1052672 alloc_large_system_hash+0x153/0x21c pages=256 vmalloc N0=128 N1=128
0xffffc90016a84000-0xffffc90016b85000 1052672 alloc_large_system_hash+0x153/0x21c pages=256 vmalloc N0=128 N1=128

# dmesg | grep hash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.003976] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.016692] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.022074] Mount-cache hash table entries: 256
[    1.089249] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.090651] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.090946] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.091187] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.119761] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)


