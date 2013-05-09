Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3EIOOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:14:34 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:46047 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562Ab3EIOOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:14:33 -0400
Date: Thu, 9 May 2013 14:14:31 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201305092125.FGG13076.LFOtVOFMSFQJHO@I-love.SAKURA.ne.jp>
Message-ID: <0000013e89a4ae3c-f2abd075-e096-42b5-891d-e2e5e2af9ecb-000000@email.amazonses.com>
References: <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com> <517E8758.9040803@parallels.com> <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
 <201304300116.FGJ56210.FMSOJHFOtFQVOL@I-love.SAKURA.ne.jp> <201305092125.FGG13076.LFOtVOFMSFQJHO@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.09-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 May 2013, Tetsuo Handa wrote:

> +       BUILD_BUG_ON(PAGE_SHIFT + MAX_ORDER != KMALLOC_SHIFT_HIGH + 1);
>         for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {

Yea looping to PAGE_SHIFT + MAX_ORDER is fundamentally wrong.


Subject: SLAB: Fix init_lock_keys()

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
+	for (i = 1; i =< KMALLOC_SHIFT_HIGH; i++) {
 		struct kmem_cache_node *n;
 		struct kmem_cache *cache = kmalloc_caches[i];

