Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab3ECPuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:50:21 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:60209 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932459Ab3ECPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:50:20 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2013 11:50:20 EDT
Date: Fri, 3 May 2013 15:43:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
Message-ID: <0000013e6b0fcf7b-9fabe4c8-2667-4bea-a9d1-f1c77e18fe78-000000@email.amazonses.com>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com> <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp> <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
 <201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp> <0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com> <201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.03-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013, Tetsuo Handa wrote:

> I don't think this patch is sufficient. There are functions (e.g. kstrdup())
> which call variant functions (e.g. kmalloc_track_caller()). I think we need to
> check size at functions which determine index from size (e.g. kmalloc_slab()).

Right.

> > Index: linux/include/linux/slab_def.h
> > ===================================================================
> > --- linux.orig/include/linux/slab_def.h	2013-05-02 15:02:45.864728115 -0500
> > +++ linux/include/linux/slab_def.h	2013-05-02 15:06:14.940474110 -0500
> > @@ -126,6 +126,9 @@ static __always_inline void *kmalloc(siz
> >  		if (!size)
> >  			return ZERO_SIZE_PTR;
> >
> > +		if (size >= KMALLOC_MAX_SIZE)
> > +			return NULL;
> > +
>
> Why not (size > KMALLOC_MAX_SIZE) ?

Correct.

We also would want some diagnostics as to who is doing these large allocs
so that these issues can be fixed. Updated patch:

Subject: slab: Return NULL for oversized allocations

The inline path seems to have changed the SLAB behavior for very large
kmalloc allocations. This patch restores the old behavior but also
adds diagnostics so that we can figure where in the code these
large allocations occur.

Signed-off-by: Christoph Lameter <cl@linux.com>


Index: linux/include/linux/slab_def.h
===================================================================
--- linux.orig/include/linux/slab_def.h	2013-05-03 10:36:46.019564801 -0500
+++ linux/include/linux/slab_def.h	2013-05-03 10:37:28.860302188 -0500
@@ -126,6 +126,11 @@ static __always_inline void *kmalloc(siz
 		if (!size)
 			return ZERO_SIZE_PTR;

+		if (size > KMALLOC_MAX_SIZE) {
+			WARN_ON(1);
+			return NULL;
+		}
+
 		i = kmalloc_index(size);

 #ifdef CONFIG_ZONE_DMA
@@ -172,6 +177,11 @@ static __always_inline void *kmalloc_nod
 		if (!size)
 			return ZERO_SIZE_PTR;

+		if (size > KMALLOC_MAX_SIZE) {
+			WARN_ON(1);
+			return NULL;
+		}
+
 		i = kmalloc_index(size);

 #ifdef CONFIG_ZONE_DMA
Index: linux/mm/slab_common.c
===================================================================
--- linux.orig/mm/slab_common.c	2013-05-03 10:36:46.019564801 -0500
+++ linux/mm/slab_common.c	2013-05-03 10:38:29.045351837 -0500
@@ -373,6 +373,11 @@ struct kmem_cache *kmalloc_slab(size_t s
 {
 	int index;

+	if (size > KMALLOC_MAX_SIZE) {
+		WARN_ON(1);
+		return NULL;
+	}
+
 	if (size <= 192) {
 		if (!size)
 			return ZERO_SIZE_PTR;


