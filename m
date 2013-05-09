Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3EIVyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:54:16 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59569 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3EIVyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:54:15 -0400
X-Nat-Received: from [202.181.97.72]:57118 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1368136446.16343
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com>
	<201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
	<201304300116.FGJ56210.FMSOJHFOtFQVOL@I-love.SAKURA.ne.jp>
	<201305092125.FGG13076.LFOtVOFMSFQJHO@I-love.SAKURA.ne.jp>
	<0000013e89a4ae3c-f2abd075-e096-42b5-891d-e2e5e2af9ecb-000000@email.amazonses.com>
In-Reply-To: <0000013e89a4ae3c-f2abd075-e096-42b5-891d-e2e5e2af9ecb-000000@email.amazonses.com>
Message-Id: <201305100654.FCI28926.HOtMVOJLFFFSQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 10 May 2013 06:54:04 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 09052013 #9931519, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> -	for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
> +	for (i = 1; i =< KMALLOC_SHIFT_HIGH; i++) {

  mm/slab.c: In function 'init_node_lock_keys':
  mm/slab.c:568:17: error: expected expression before '<' token

What I'm worrying is:

  /*
   * The largest kmalloc size supported by the SLAB allocators is
   * 32 megabyte (2^25) or the maximum allocatable page order if that is
   * less than 32 MB.
   *
   * WARNING: Its not easy to increase this value since the allocators have
   * to do various tricks to work around compiler limitations in order to
   * ensure proper constant folding.
   */
  #define KMALLOC_SHIFT_HIGH      ((MAX_ORDER + PAGE_SHIFT - 1) <= 25 ? \
                                  (MAX_ORDER + PAGE_SHIFT - 1) : 25)

  extern struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];

Can we manage with allocating only 26 elements when MAX_ORDER + PAGE_SHIFT > 26
(e.g. PAGE_SIZE == 256 * 1024) ?

Can kmalloc_index()/kmalloc_size()/kmalloc_slab() etc. work correctly when
MAX_ORDER + PAGE_SHIFT > 26 (e.g. PAGE_SIZE == 256 * 1024) ?
