Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255Ab3B0PTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:19:16 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:40028 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752883Ab3B0PTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:19:14 -0500
Message-ID: <512E23F0.2060408@mimc.co.uk>
Date: Wed, 27 Feb 2013 15:19:12 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: JFFS2 deadlock
References: <512CA290.6050509@mimc.co.uk> <20130227101704.90466ae6df78ab9b3aa4ba22@canb.auug.org.au>
In-Reply-To: <20130227101704.90466ae6df78ab9b3aa4ba22@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/13 23:17, Stephen Rothwell wrote:
> Hi Mark,
> 
> On Tue, 26 Feb 2013 11:54:56 +0000 Mark Jackson <mpfj-list@mimc.co.uk> wrote:
>>
>> Just tested the current next-20130226 on a custom AM335X board, and I received the JFFS2 deadlock shown below.
> 
> Is this new today?  is it reproducible? Does if ail for Linus' tree?

Almost identical on Linus' tree:-

[    3.685186]
[    3.686803] ======================================================
[    3.693333] [ INFO: possible circular locking dependency detected ]
[    3.699962] 3.8.0-09426-g986876f-dirty #133 Not tainted
[    3.705482] -------------------------------------------------------
[    3.712105] rcS/682 is trying to acquire lock:
[    3.716801]  (&mm->mmap_sem){++++++}, at: [<c00f1258>] might_fault+0x3c/0x90
[    3.724307]
[    3.724307] but task is already holding lock:
[    3.730470]  (&f->sem){+.+.+.}, at: [<c023cb30>] jffs2_readdir+0x44/0x1a8
[    3.737686]
[    3.737686] which lock already depends on the new lock.
[    3.737686]
[    3.746331]
[    3.746331] the existing dependency chain (in reverse order) is:
[    3.754239]
-> #1 (&f->sem){+.+.+.}:
[    3.758229]        [<c0093614>] lock_acquire+0x9c/0x104
[    3.763775]        [<c04b3b4c>] mutex_lock_nested+0x3c/0x334
[    3.769769]        [<c023d358>] jffs2_readpage+0x20/0x44
[    3.775392]        [<c00da510>] __do_page_cache_readahead+0x2a0/0x2cc
[    3.782217]        [<c00da7dc>] ra_submit+0x28/0x30
[    3.787380]        [<c00d2010>] filemap_fault+0x304/0x458
[    3.793094]        [<c00f13bc>] __do_fault+0x6c/0x490
[    3.798439]        [<c00f43a4>] handle_pte_fault+0xb0/0x6f0
[    3.804337]        [<c00f4a84>] handle_mm_fault+0xa0/0xd4
[    3.810050]        [<c04b80e8>] do_page_fault+0x2a0/0x3d4
[    3.815773]        [<c000845c>] do_DataAbort+0x30/0x9c
[    3.821212]        [<c04b65e4>] __dabt_svc+0x44/0x80
[    3.826467]        [<c0288d10>] __clear_user_std+0x1c/0x64
[    3.832285]
-> #0 (&mm->mmap_sem){++++++}:
[    3.836824]        [<c0093010>] __lock_acquire+0x1d70/0x1de0
[    3.842815]        [<c0093614>] lock_acquire+0x9c/0x104
[    3.848345]        [<c00f127c>] might_fault+0x60/0x90
[    3.853690]        [<c011c504>] filldir+0x5c/0x158
[    3.858762]        [<c023cbc8>] jffs2_readdir+0xdc/0x1a8
[    3.864384]        [<c011c794>] vfs_readdir+0x98/0xb4
[    3.869729]        [<c011c894>] sys_getdents+0x74/0xd0
[    3.875166]        [<c0013800>] ret_fast_syscall+0x0/0x3c
[    3.880890]
[    3.880890] other info that might help us debug this:
[    3.880890]
[    3.889350]  Possible unsafe locking scenario:
[    3.889350]
[    3.895604]        CPU0                    CPU1
[    3.900388]        ----                    ----
[    3.905171]   lock(&f->sem);
[    3.908227]                                lock(&mm->mmap_sem);
[    3.914494]                                lock(&f->sem);
[    3.920210]   lock(&mm->mmap_sem);
[    3.923816]
[    3.923816]  *** DEADLOCK ***
[    3.923816]
[    3.930077] 2 locks held by rcS/682:
[    3.933851]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c011c758>] vfs_readdir+0x5c/0xb4
[    3.942625]  #1:  (&f->sem){+.+.+.}, at: [<c023cb30>] jffs2_readdir+0x44/0x1a8
[    3.950298]
[    3.950298] stack backtrace:
[    3.954930] [<c001b11c>] (unwind_backtrace+0x0/0xf0) from [<c008fac0>] (print_circular_bug+0x1d0/0x2dc)
[    3.964870] [<c008fac0>] (print_circular_bug+0x1d0/0x2dc) from [<c0093010>] (__lock_acquire+0x1d70/0x1de0)
[    3.975081] [<c0093010>] (__lock_acquire+0x1d70/0x1de0) from [<c0093614>] (lock_acquire+0x9c/0x104)
[    3.984650] [<c0093614>] (lock_acquire+0x9c/0x104) from [<c00f127c>] (might_fault+0x60/0x90)
[    3.993573] [<c00f127c>] (might_fault+0x60/0x90) from [<c011c504>] (filldir+0x5c/0x158)
[    4.002039] [<c011c504>] (filldir+0x5c/0x158) from [<c023cbc8>] (jffs2_readdir+0xdc/0x1a8)
[    4.010781] [<c023cbc8>] (jffs2_readdir+0xdc/0x1a8) from [<c011c794>] (vfs_readdir+0x98/0xb4)
[    4.019797] [<c011c794>] (vfs_readdir+0x98/0xb4) from [<c011c894>] (sys_getdents+0x74/0xd0)
[    4.028629] [<c011c894>] (sys_getdents+0x74/0xd0) from [<c0013800>] (ret_fast_syscall+0x0/0x3c)

