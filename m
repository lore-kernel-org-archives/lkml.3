Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3GBMtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:49:43 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51181 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3GBMtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:49:42 -0400
X-Nat-Received: from [202.181.97.72]:49968 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1372769366.26296
To: akpm@linux-foundation.org
Cc: cl@linux.com, glommer@parallels.com, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201305071938.DAC81273.HOSJOFFOQLtMFV@I-love.SAKURA.ne.jp>
	<0000013e7f651028-9a57bc30-4148-4aba-a0e6-737b83bf2458-000000@email.amazonses.com>
	<20130701130903.61459f57f4ba31e282065001@linux-foundation.org>
	<201307020645.JGI86434.FFHOLOSFOtJVMQ@I-love.SAKURA.ne.jp>
	<20130701145356.f9c43875890d1aec90fe1ad9@linux-foundation.org>
In-Reply-To: <20130701145356.f9c43875890d1aec90fe1ad9@linux-foundation.org>
Message-Id: <201307022149.HEB90128.QFJFHOLMVtFSOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 2 Jul 2013 21:49:26 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 02072013 #10463928, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Look, I'll make this easier:
> 
> : Subject: slab: fix init_lock_keys
> : 
> : In 3.10 kernels with CONFIG_LOCKDEP=y on architectures with
> : PAGE_SHIFT + MAX_ORDER > 26 such as [architecture goes here], the kernel does
> : [x] when the user does [y].
> :
> : init_lock_keys() goes too far in initializing values in kmalloc_caches
> : because it assumed that the size of the kmalloc array goes up to
> : MAX_ORDER.  However, the size of the kmalloc array for SLAB may be
> : restricted due to increased page sizes or CONFIG_FORCE_MAX_ZONEORDER.
> :
> : Fix this by [z].
> 
> 
> Please fill in the text within [].
> 
OK. I made from http://marc.info/?l=linux-kernel&m=136810234704350&w=2 .
-----
Some architectures (e.g. powerpc built with CONFIG_PPC_256K_PAGES=y
CONFIG_FORCE_MAX_ZONEORDER=11) get PAGE_SHIFT + MAX_ORDER > 26.

In 3.10 kernels, CONFIG_LOCKDEP=y with PAGE_SHIFT + MAX_ORDER > 26 makes
init_lock_keys() dereference beyond kmalloc_caches[26].
This leads to an unbootable system (kernel panic at initializing SLAB)
if one of kmalloc_caches[26...PAGE_SHIFT+MAX_ORDER-1] is not NULL.

Fix this by making sure that init_lock_keys() does not dereference beyond
kmalloc_caches[26] arrays.
-----
