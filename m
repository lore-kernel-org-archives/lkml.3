Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311Ab3EAMOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 08:14:54 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51460 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317Ab3EAMOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 08:14:46 -0400
X-Nat-Received: from [202.181.97.72]:58193 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367410468.13635
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com>
	<201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp>
	<0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
	<201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
	<0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
In-Reply-To: <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
Message-Id: <201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 1 May 2013 21:14:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 01052013 #9864460, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> > "kmalloc() returning NULL for these allocations" is needed by "try kmalloc()
> > first, fallback to vmalloc()" allocation. There are kernel modules which expect
> > kmalloc() to return NULL rather than oops when the requested size is larger
> > than KMALLOC_MAX_SIZE bytes. If kmalloc() suddenly starts triggering oops, such
> > modules will break.
> 
> This behavior has been in there for years. Why try a kmalloc that
> always fails since the size is too big?
> 

This is nothing but a testcase. Size argument is sometimes unknown and/or
user-controlled. We expect that not only kmalloc() etc. but also kstrdup(),
kmemdup(), krealloc() etc. do not trigger oops. I think that checking the size
in SLAB/SLUB is the only safe way.

> > Anyway, there is a regression we want to fix : we won't be able to boot
> > Linux 3.10-rc1 for x86_32 built with CONFIG_DEBUG_SLAB=y &&
> > CONFIG_DEBUG_SPINLOCK=y && CONFIG_DEBUG_PAGEALLOC=y .
> > ("Fix off by one error in slab.h" did not fix the regression.)
> 
> Hmm... Where does this fail? In slab?
> 
It hangs (with CPU#0 spinning) immediately after printing

  Decompressing Linux... Parsing ELF... done.
  Booting the kernel.

lines. Today I heard that gdb can be used if I use qemu, but I doubt that I can
manage time to understand and find the exact location within a few days.

The culprit location is possibly in SLAB because the kernel boots if built with
CONFIG_DEBUG_SLAB=n || CONFIG_DEBUG_SPINLOCK=n || CONFIG_DEBUG_PAGEALLOC=n.
