Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaETPa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:30:59 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63314 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaETPa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:30:57 -0400
X-Nat-Received: from [202.181.97.72]:45757 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1400599837.23128
To: dchinner@redhat.com
Cc: airlied@linux.ie, glommer@openvz.org, mgorman@suse.de,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] gpu/drm/ttm: Use mutex_lock_killable() for shrinker functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201405192339.JIJ04144.FHQFVFOtOSLJOM@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.00.1405200140010.20503@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.1405200140010.20503@skynet.skynet.ie>
Message-Id: <201405210030.HBD65663.FFLVHOFMSJOtOQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 21 May 2014 00:30:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 20052014 #7960777, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> From e314a1a1583e585d062dfc30c8aad8bf5380510b Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 19 May 2014 18:43:21 +0900
> Subject: [PATCH] gpu/drm/ttm: Use mutex_lock_killable() for shrinker functions.
> 
> I can observe that RHEL7 environment stalls with 100% CPU usage when a
> certain type of memory pressure is given. While the shrinker functions
> are called by shrink_slab() before the OOM killer is triggered, the stall
> lasts for many minutes.
> 
> I added debug printk() and observed that many threads are blocked for more
> than 10 seconds at ttm_dma_pool_shrink_count()/ttm_dma_pool_shrink_scan()
> functions. Since the kswapd can call these functions later, the current
> thread can return from these functions as soon as chosen by the OOM killer.
> 
> This patch changes "mutex_lock();" to "if (mutex_lock_killable()) return ...;"
> so that any threads can promptly give up. (By the way, as far as I tested,
> changing to "if (!mutex_trylock()) return ...;" likely shortens the duration
> of stall. Maybe we don't need to wait for mutex if someone is already calling
> these functions.)
> 

While discussing about XFS problem, I got a question. Is it OK (from point
of view of reentrant) to use mutex_lock() or mutex_lock_killable() inside
shrinker's entry point functions? Can senario shown below possible?

(1) kswapd is doing memory reclaim which does not need to hold mutex.

(2) Someone in GFP_KERNEL context (not kswapd) calls
    ttm_dma_pool_shrink_count() and then calls ttm_dma_pool_shrink_scan()
    from direct reclaim path.

(3) Inside ttm_dma_pool_shrink_scan(), GFP_KERNEL allocation is issued
    while mutex is held by the someone.

(4) GFP_KERNEL allocation cannot be completed immediately due to memory
    pressure.

(5) kswapd calls ttm_dma_pool_shrink_count() which need to hold mutex.

(6) Inside ttm_dma_pool_shrink_count(), kswapd is blocked waiting for
    mutex held by the someone, and the someone is waiting for GFP_KERNEL
    allocation to complete, but GFP_KERNEL allocation cannot be completed
    until mutex held by the someone is released?
