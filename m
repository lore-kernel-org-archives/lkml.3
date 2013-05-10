Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab3EJMi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:38:59 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52764 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EJMi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:38:58 -0400
X-Nat-Received: from [202.181.97.72]:62591 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1368189528.10957
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
	<201304300116.FGJ56210.FMSOJHFOtFQVOL@I-love.SAKURA.ne.jp>
	<201305092125.FGG13076.LFOtVOFMSFQJHO@I-love.SAKURA.ne.jp>
	<0000013e89a4ae3c-f2abd075-e096-42b5-891d-e2e5e2af9ecb-000000@email.amazonses.com>
	<201305100654.FCI28926.HOtMVOJLFFFSQO@I-love.SAKURA.ne.jp>
In-Reply-To: <201305100654.FCI28926.HOtMVOJLFFFSQO@I-love.SAKURA.ne.jp>
Message-Id: <201305102138.BDF90621.LFFOFtHSQOMVOJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 10 May 2013 21:38:47 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10052013 #9939283, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Can we manage with allocating only 26 elements when MAX_ORDER + PAGE_SHIFT > 26
> (e.g. PAGE_SIZE == 256 * 1024) ?
> 
> Can kmalloc_index()/kmalloc_size()/kmalloc_slab() etc. work correctly when
> MAX_ORDER + PAGE_SHIFT > 26 (e.g. PAGE_SIZE == 256 * 1024) ?
> 
Today I compared SLAB/SLUB code. If I understood correctly, the line

  if (size <=  64 * 1024 * 1024) return 26;

in kmalloc_index() is redundant (in fact, kmalloc_caches[26] is out of range)
and conflicts with what the comment

  * The largest kmalloc size supported by the SLAB allocators is
  * 32 megabyte (2^25) or the maximum allocatable page order if that is
  * less than 32 MB.

says, and 0 <= kmalloc_index() <= 25 is always true for SLAB and
0 <= kmalloc_index() <= PAGE_SHIFT+1 is always true for SLUB.

Therefore, towards 3.10-rc1,

> > -	for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
> > +	for (i = 1; i =< KMALLOC_SHIFT_HIGH; i++) {
> 
-+	for (i = 1; i =< KMALLOC_SHIFT_HIGH; i++) {
++	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {

would be the last fix for me. (I don't know why kmalloc_caches[0] is excluded.)
