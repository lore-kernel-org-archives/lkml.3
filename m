Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3GAUJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:09:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3GAUJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:09:04 -0400
Date: Mon, 1 Jul 2013 13:09:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, glommer@parallels.com,
        penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
Message-Id: <20130701130903.61459f57f4ba31e282065001@linux-foundation.org>
In-Reply-To: <0000013e7f651028-9a57bc30-4148-4aba-a0e6-737b83bf2458-000000@email.amazonses.com>
References: <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
	<201305040348.CIF81716.OStQOHFJMFLOVF@I-love.SAKURA.ne.jp>
	<0000013e6bd7a766-8473586c-7937-4129-bad1-a4198acdddcf-000000@email.amazonses.com>
	<201305040915.AID02071.FHVQJtOFOMOLSF@I-love.SAKURA.ne.jp>
	<0000013e7a18153d-4b59eaf6-0fcd-4eec-b357-31d3d40baa7d-000000@email.amazonses.com>
	<201305071938.DAC81273.HOSJOFFOQLtMFV@I-love.SAKURA.ne.jp>
	<0000013e7f651028-9a57bc30-4148-4aba-a0e6-737b83bf2458-000000@email.amazonses.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 May 2013 14:28:49 +0000 Christoph Lameter <cl@linux.com> wrote:

> On Tue, 7 May 2013, Tetsuo Handa wrote:
> 
> > > These are exclusively from the module load. So the kernel seems to be
> > > clean of large kmalloc's ?
> > >
> > There are modules (e.g. TOMOYO) which do not check for KMALLOC_MAX_SIZE limit
> > and expect kmalloc() larger than KMALLOC_MAX_SIZE bytes to return NULL.
> 
> Dont do that. Please fix these things.

Slab should return NULL for a request greater than KMALLOC_MAX_SIZE. 
For heaven's sake don't break that!

What's going on with this bug, btw?  This:

--- a/mm/slab.c~slab-fix-init_lock_keys
+++ a/mm/slab.c
@@ -565,7 +565,7 @@ static void init_node_lock_keys(int q)
 	if (slab_state < UP)
 		return;
 
-	for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
+	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {
 		struct kmem_cache_node *n;
 		struct kmem_cache *cache = kmalloc_caches[i];
 

still seems to be unapplied.

I've read through the thread trying to work out what the end-user
impact of that fix is, but it's all clear as mud.  It's possible that
the end-user effect is `kernel locks up after printing "Booting the
kernel"'.  Or maybe not.

And if the above patch does indeed fix something significant, we might
need a -stable backport.

Can we get some clarity here please?
