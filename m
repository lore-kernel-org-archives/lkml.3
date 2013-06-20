Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab3FTM6C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:58:02 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:36254 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757660Ab3FTM6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:58:00 -0400
Message-ID: <51C2FC56.1070808@newflow.co.uk>
Date: Thu, 20 Jun 2013 13:57:58 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: 3.10.0-rc4: jffs2: Possible circular locking dependency detected
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just mounted a JFFS2 partition (held in NOR flash on a custom AM335x
CPU board), and I always get the following:-

[    3.864244]
[    3.865851] ======================================================
[    3.872359] [ INFO: possible circular locking dependency detected ]
[    3.878968] 3.10.0-rc4-00172-gf31c62e-dirty #249 Not tainted
[    3.884926] -------------------------------------------------------
[    3.891526] rcS/507 is trying to acquire lock:
[    3.896206]  (&mm->mmap_sem){++++++}, at: [<c00b42c8>] might_fault+0x3c/0x94
[    3.903684]
[    3.903684] but task is already holding lock:
[    3.909826]  (&f->sem){+.+.+.}, at: [<c016f208>] jffs2_readdir+0x40/0x1b0
[    3.917021]
[    3.917021] which lock already depends on the new lock.
[    3.917021]
[    3.925637]
[    3.925637] the existing dependency chain (in reverse order) is:
[    3.933516]
-> #1 (&f->sem){+.+.+.}:
[    3.937489]        [<c0079ad0>] lock_acquire+0x68/0x7c
[    3.942918]        [<c041f290>] mutex_lock_nested+0x40/0x31c
[    3.948893]        [<c0170b00>] jffs2_readpage+0x20/0x4c
[    3.954500]        [<c009faf4>] __do_page_cache_readahead+0x28c/0x2b4
[    3.961305]        [<c00a0028>] ra_submit+0x28/0x30
[    3.966450]        [<c009686c>] filemap_fault+0x330/0x3e4
[    3.972143]        [<c00b0308>] __do_fault+0x68/0x4a4
[    3.977481]        [<c00b3214>] handle_pte_fault+0x70/0x6b4
[    3.983361]        [<c00b38f0>] handle_mm_fault+0x98/0xcc
[    3.989055]        [<c001d614>] do_page_fault+0x210/0x398
[    3.994750]        [<c00084a4>] do_DataAbort+0x38/0x98
[    4.000170]        [<c001315c>] __dabt_svc+0x3c/0x60
[    4.005417]        [<c01df448>] __clear_user_std+0x1c/0x64
[    4.011209]
-> #0 (&mm->mmap_sem){++++++}:
[    4.015729]        [<c0078f40>] __lock_acquire+0x1990/0x1d7c
[    4.021699]        [<c0079ad0>] lock_acquire+0x68/0x7c
[    4.027118]        [<c00b42f0>] might_fault+0x64/0x94
[    4.032444]        [<c00d9bd0>] filldir+0x6c/0x174
[    4.037507]        [<c016f28c>] jffs2_readdir+0xc4/0x1b0
[    4.043110]        [<c00da020>] vfs_readdir+0x94/0xb8
[    4.048438]        [<c00da118>] SyS_getdents+0x64/0xd4
[    4.053859]        [<c00135c0>] ret_fast_syscall+0x0/0x48
[    4.059556]
[    4.059556] other info that might help us debug this:
[    4.059556]
[    4.067989]  Possible unsafe locking scenario:
[    4.067989]
[    4.074222]        CPU0                    CPU1
[    4.078989]        ----                    ----
[    4.083756]   lock(&f->sem);
[    4.086799]                                lock(&mm->mmap_sem);
[    4.093042]                                lock(&f->sem);
[    4.098735]   lock(&mm->mmap_sem);
[    4.102326]
[    4.102326]  *** DEADLOCK ***
[    4.102326]
[    4.108567] 2 locks held by rcS/507:
[    4.112328]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c00d9fe0>] vfs_readdir+0x54/0xb8
[    4.121070]  #1:  (&f->sem){+.+.+.}, at: [<c016f208>] jffs2_readdir+0x40/0x1b0
[    4.128713]
[    4.128713] stack backtrace:
[    4.133312] CPU: 0 PID: 507 Comm: rcS Not tainted 3.10.0-rc4-00172-gf31c62e-dirty #249
[    4.141676] [<c0018e70>] (unwind_backtrace+0x0/0xf4) from [<c0016d88>] (show_stack+0x10/0x14)
[    4.150669] [<c0016d88>] (show_stack+0x10/0x14) from [<c041bc88>] (print_circular_bug+0x2e8/0x2f4)
[    4.160118] [<c041bc88>] (print_circular_bug+0x2e8/0x2f4) from [<c0078f40>] (__lock_acquire+0x1990/0x1d7c)
[    4.170297] [<c0078f40>] (__lock_acquire+0x1990/0x1d7c) from [<c0079ad0>] (lock_acquire+0x68/0x7c)
[    4.179742] [<c0079ad0>] (lock_acquire+0x68/0x7c) from [<c00b42f0>] (might_fault+0x64/0x94)
[    4.188549] [<c00b42f0>] (might_fault+0x64/0x94) from [<c00d9bd0>] (filldir+0x6c/0x174)
[    4.196992] [<c00d9bd0>] (filldir+0x6c/0x174) from [<c016f28c>] (jffs2_readdir+0xc4/0x1b0)
[    4.205708] [<c016f28c>] (jffs2_readdir+0xc4/0x1b0) from [<c00da020>] (vfs_readdir+0x94/0xb8)
[    4.214698] [<c00da020>] (vfs_readdir+0x94/0xb8) from [<c00da118>] (SyS_getdents+0x64/0xd4)
[    4.223507] [<c00da118>] (SyS_getdents+0x64/0xd4) from [<c00135c0>] (ret_fast_syscall+0x0/0x48)
