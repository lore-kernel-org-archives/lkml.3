Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3EJP5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:57:33 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:40266 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625Ab3EJP5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:57:32 -0400
Date: Fri, 10 May 2013 15:57:30 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201305102138.BDF90621.LFFOFtHSQOMVOJ@I-love.SAKURA.ne.jp>
Message-ID: <0000013e8f295277-653bcbfa-e1cc-4c05-8e6d-eb6a5a661f6f-000000@email.amazonses.com>
References: <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp> <201304300116.FGJ56210.FMSOJHFOtFQVOL@I-love.SAKURA.ne.jp> <201305092125.FGG13076.LFOtVOFMSFQJHO@I-love.SAKURA.ne.jp> <0000013e89a4ae3c-f2abd075-e096-42b5-891d-e2e5e2af9ecb-000000@email.amazonses.com>
 <201305100654.FCI28926.HOtMVOJLFFFSQO@I-love.SAKURA.ne.jp> <201305102138.BDF90621.LFFOFtHSQOMVOJ@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.10-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013, Tetsuo Handa wrote:

> Tetsuo Handa wrote:
> > Can we manage with allocating only 26 elements when MAX_ORDER + PAGE_SHIFT > 26
> > (e.g. PAGE_SIZE == 256 * 1024) ?
> >
> > Can kmalloc_index()/kmalloc_size()/kmalloc_slab() etc. work correctly when
> > MAX_ORDER + PAGE_SHIFT > 26 (e.g. PAGE_SIZE == 256 * 1024) ?
> >
> Today I compared SLAB/SLUB code. If I understood correctly, the line
>
>   if (size <=  64 * 1024 * 1024) return 26;
>
> in kmalloc_index() is redundant (in fact, kmalloc_caches[26] is out of range)
> and conflicts with what the comment

True we could remove it but it does not hurt. There is a bounding of size
before any call to kmalloc_index.

>   * The largest kmalloc size supported by the SLAB allocators is
>   * 32 megabyte (2^25) or the maximum allocatable page order if that is
>   * less than 32 MB.
>
> says, and 0 <= kmalloc_index() <= 25 is always true for SLAB and
> 0 <= kmalloc_index() <= PAGE_SHIFT+1 is always true for SLUB.
>
> Therefore, towards 3.10-rc1,
>
> > > -	for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
> > > +	for (i = 1; i =< KMALLOC_SHIFT_HIGH; i++) {
> >
> -+	for (i = 1; i =< KMALLOC_SHIFT_HIGH; i++) {
> ++	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {
>
> would be the last fix for me. (I don't know why kmalloc_caches[0] is excluded.)

Yep. kmalloc[0] is not used. The first cache to be used is 1 and 2 which
are the non power of two caches. 3 and higher are the power of two caches.


Subject: SLAB: Fix init_lock_keys

init_lock_keys goes too far in initializing values in kmalloc_caches because
it assumed that the size of the kmalloc array goes up to MAX_ORDER. However, the size
of the kmalloc array for SLAB may be restricted due to increased page sizes or CONFIG_FORCE_MAX_ZONEORDER.

Reported-by: Tetsuo Handa <penguin-kernel@I-Love.SAKURA.ne.jp>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slab.c
===================================================================
--- linux.orig/mm/slab.c	2013-05-09 09:06:20.000000000 -0500
+++ linux/mm/slab.c	2013-05-09 09:08:08.338606055 -0500
@@ -565,7 +565,7 @@ static void init_node_lock_keys(int q)
 	if (slab_state < UP)
 		return;

-	for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
+	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {
 		struct kmem_cache_node *n;
 		struct kmem_cache *cache = kmalloc_caches[i];

