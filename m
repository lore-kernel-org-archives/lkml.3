Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3D2Ckr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 22:40:47 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63606 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab3D2Ckq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 22:40:46 -0400
X-Nat-Received: from [202.181.97.72]:51705 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367203232.24540
To: glommer@parallels.com, cl@linux.com, penberg@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201304242108.FDC35910.VJMHFFFSOLOOQt@I-love.SAKURA.ne.jp><201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp>
In-Reply-To: <201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp>
Message-Id: <201304291140.IFJ95894.OFLSFFHQOOMVJt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 29 Apr 2013 11:40:28 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 29042013 #9853800, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Also, kmalloc_index() in include/linux/slab.h can return 0 to 26.
> 
> If (MAX_ORDER + PAGE_SHIFT - 1) > 25 is true and
> kmalloc_index(64 * 1024 * 1024) is requested (I don't know whether such case
> happens), kmalloc_caches[26] is beyond the array, for kmalloc_caches[26]
> allows 0 to 25.
> 
> If (MAX_ORDER + PAGE_SHIFT - 1) <= 25 is true and
> kmalloc_index(64 * 1024 * 1024) is requested (I don't know whether such case
> happens), kmalloc_caches[26] is beyond the array, for
> kmalloc_caches[MAX_ORDER + PAGE_SHIFT] allows 0 to MAX_ORDER + PAGE_SHIFT - 1.
> 
> Would you recheck that the array size is correct?
> 

I confirmed (on x86_32) that

  volatile unsigned int size = 8 * 1024 * 1024;
  kmalloc(size, GFP_KERNEL);

causes no warning at compile time and returns NULL at runtime. But

  unsigned int size = 8 * 1024 * 1024;
  kmalloc(size, GFP_KERNEL);

causes compile time warning

  include/linux/slab_def.h:136: warning: array subscript is above array bounds

and runtime bug.

  BUG: unable to handle kernel NULL pointer dereference at 00000058
  IP: [<c10b9d76>] kmem_cache_alloc+0x26/0xb0

I confirmed (on x86_32) that

  kmalloc(64 * 1024 * 1024, GFP_KERNEL);

causes compile time warning

  include/linux/slab_def.h:136: warning: array subscript is above array bounds

and runtime bug.

  Kernel BUG at c10b9c5b [verbose debug info unavailable]
  invalid opcode: 0000 [#1] SMP

Also,

  volatile unsigned int size = 64 * 1024 * 1024;
  kmalloc(size, GFP_KERNEL);

causes no warning at compile time but runtime bug.

  Kernel BUG at c10b9c5b [verbose debug info unavailable]
  invalid opcode: 0000 [#1] SMP

There are kernel modules which expect kmalloc() to return NULL rather than
oops when the requested size is too large.
