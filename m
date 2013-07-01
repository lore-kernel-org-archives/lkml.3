Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab3GAVpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:45:40 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57371 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3GAVpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:45:39 -0400
X-Nat-Received: from [202.181.97.72]:59905 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1372715127.16055
To: akpm@linux-foundation.org, cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201305040915.AID02071.FHVQJtOFOMOLSF@I-love.SAKURA.ne.jp>
	<0000013e7a18153d-4b59eaf6-0fcd-4eec-b357-31d3d40baa7d-000000@email.amazonses.com>
	<201305071938.DAC81273.HOSJOFFOQLtMFV@I-love.SAKURA.ne.jp>
	<0000013e7f651028-9a57bc30-4148-4aba-a0e6-737b83bf2458-000000@email.amazonses.com>
	<20130701130903.61459f57f4ba31e282065001@linux-foundation.org>
In-Reply-To: <20130701130903.61459f57f4ba31e282065001@linux-foundation.org>
Message-Id: <201307020645.JGI86434.FFHOLOSFOtJVMQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 2 Jul 2013 06:45:27 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 01072013 #10459791, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 7 May 2013 14:28:49 +0000 Christoph Lameter <cl@linux.com> wrote:
> 
> > On Tue, 7 May 2013, Tetsuo Handa wrote:
> > 
> > > > These are exclusively from the module load. So the kernel seems to be
> > > > clean of large kmalloc's ?
> > > >
> > > There are modules (e.g. TOMOYO) which do not check for KMALLOC_MAX_SIZE limit
> > > and expect kmalloc() larger than KMALLOC_MAX_SIZE bytes to return NULL.
> > 
> > Dont do that. Please fix these things.
> 
> Slab should return NULL for a request greater than KMALLOC_MAX_SIZE. 
> For heaven's sake don't break that!

The patch that fixes above things (commit 6286ae97) went to 3.10.



> What's going on with this bug, btw?  This:
> 
> --- a/mm/slab.c~slab-fix-init_lock_keys
> +++ a/mm/slab.c
> @@ -565,7 +565,7 @@ static void init_node_lock_keys(int q)
>  	if (slab_state < UP)
>  		return;
>  
> -	for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
> +	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {
>  		struct kmem_cache_node *n;
>  		struct kmem_cache *cache = kmalloc_caches[i];
>  
> 
> still seems to be unapplied.
> 
The patch that fixes oops and panic on early boot on architectures with
PAGE_SHIFT + MAX_ORDER > 26 missed 3.10.

> I've read through the thread trying to work out what the end-user
> impact of that fix is, but it's all clear as mud.  It's possible that
> the end-user effect is `kernel locks up after printing "Booting the
> kernel"'.  Or maybe not.
> 
> And if the above patch does indeed fix something significant, we might
> need a -stable backport.
> 

Somebody needs this patch when debugging with CONFIG_LOCKDEP=y on
architectures with PAGE_SHIFT + MAX_ORDER > 26 .

> Can we get some clarity here please?
> 

Thank you for adding to -mm. But please delete

  Tetsuo said:
  
  : It hangs (with CPU#0 spinning) immediately after printing
  : 
  :   Decompressing Linux... Parsing ELF... done.
  :   Booting the kernel.
  : 
  : lines.

lines from "+ slab-fix-init_lock_keys.patch added to -mm tree", for
these lines are fixed by commit 8a965b3b. Though the same symptom would
appear if hitting this PAGE_SHIFT + MAX_ORDER > 26 bug, I can't confirm
the symptom for environments which I don't have.
