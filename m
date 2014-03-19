Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829AbaCSW7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:59:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaCSW7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:59:11 -0400
Date: Wed, 19 Mar 2014 15:59:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: 3.14-rc6: softlockup at kswapd
Message-Id: <20140319155909.f2c61651518775dff41695c6@linux-foundation.org>
In-Reply-To: <20140318075225.GA6955@amd.pavel.ucw.cz>
References: <20140318075225.GA6955@amd.pavel.ucw.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 08:52:25 +0100 Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> Machine should have been idle overnight, but I think  something killed
> chromium-browser -- so it may ran out of memory.
> 
> Anyway, dmesg below.
> 
> Any ideas?
> 								Pavel
> ...
>
> BUG: soft lockup - CPU#0 stuck for 22s! [kswapd0:745]
> Modules linked in:
> CPU: 0 PID: 745 Comm: kswapd0 Tainted: G        W    3.14.0-rc6+ #330
> Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 ) 03/31/2011
> task: f5f785a0 ti: f5c1a000 task.ti: f509c000
> EIP: 0060:[<c4075b93>] EFLAGS: 00000246 CPU: 0
> EIP is at lock_release+0xa3/0x1e0
> EAX: f5f785a0 EBX: f5f785a0 ECX: 00000000 EDX: 00000000
> ESI: 000882a7 EDI: 00000000 EBP: f509ddd8 ESP: f509ddb4
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> CR0: 8005003b CR2: b38ab000 CR3: 04bd2000 CR4: 00000710
> Stack:
>  c40d188b 00000000 f5c205c0 0000013a 00000001 00000246 f5c205c0 00000000
>  f509df08 f509dde4 c47e0906 f5c205c0 f509ddf4 c40d1899 f5d17800 0000013a
>  f509de0c c40ef33a 00000000 00000000 00000020 f5d17ba4 f509de4c c40c519e
> Call Trace:
>  [<c40d188b>] ? list_lru_count_node+0x1b/0x60
>  [<c47e0906>] _raw_spin_unlock+0x16/0x20
>  [<c40d1899>] list_lru_count_node+0x29/0x60
>  [<c40ef33a>] super_cache_count+0x5a/0xc0
>  [<c40c519e>] shrink_slab_node+0x2e/0x1d0
>  [<c40c536a>] ? shrink_slab+0x2a/0xf0
>  [<c40c5411>] shrink_slab+0xd1/0xf0
>  [<c40c5912>] kswapd+0x4e2/0x930
>  [<c40534d4>] kthread+0xb4/0xd0
>  [<c40c5430>] ? shrink_slab+0xf0/0xf0
>  [<c4050000>] ? alloc_pid+0x2e0/0x380
>  [<c47e13b7>] ret_from_kernel_thread+0x1b/0x28
>  [<c4053420>] ? __init_kthread_worker+0x60/0x60

hm, don't know.

A recent change in there was 0b1fb40a3b12 ("mm: vmscan: shrink all slab
objects if tight on memory"), but I can't see a way in which that could
cause shrink_slab() to get stuck in such a fashion.  Perhaps we're
looping at a higher level in vscan.

shrink_slab_node() will get stuck if a shrinker has a zero .batch, but
alloc_super() uses 1024 and the trace shows ->count_objects, not
->scan_objects.



