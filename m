Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbbAUWVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:21:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbAUWVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:21:09 -0500
Date: Wed, 21 Jan 2015 14:21:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Krzysztof =?UTF-8?Q?Koz=C5=82owski?= <k.kozlowski.k@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm:
 mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch is
 causing preemptible splats
Message-Id: <20150121142107.e26d5ebf3340aa91759fef1f@linux-foundation.org>
In-Reply-To: <20150121141138.GC23700@dhcp22.suse.cz>
References: <20150121132308.GB23700@dhcp22.suse.cz>
	<CAJKOXPdgSsd8cr7ctKOGCwFTRMxcq71k7Pb5mQgYy--tGW8+_w@mail.gmail.com>
	<20150121141138.GC23700@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 15:11:38 +0100 Michal Hocko <mhocko@suse.cz> wrote:

> On Wed 21-01-15 15:06:03, Krzysztof Koz__owski wrote:
> [...]
> > Same here :) [1] . So actually only ARM seems affected (both armv7 and
> > armv8) because it is the only one which uses smp_processor_id() in
> > my_cpu_offset.
> 
> This was on x86_64 with CONFIG_DEBUG_PREEMPT so it is not only ARM
> specific.
>  

Hopefully
mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch
will fix this.

The most recent -mmotm was a bit of a trainwreck.  I'm scrambling to
get the holes plugged so I can get another mmotm out today.



From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slub: optimize alloc/free fastpath by removing preemption on/off

Change from v2:
- use raw_cpu_ptr() rather than this_cpu_ptr() to avoid warning from
 preemption debug check since this is intended behaviour
- fix typo alogorithm -> algorithm

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3 mm/slub.c
--- a/mm/slub.c~mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3
+++ a/mm/slub.c
@@ -2404,11 +2404,11 @@ redo:
 	 */
 	do {
 		tid = this_cpu_read(s->cpu_slab->tid);
-		c = this_cpu_ptr(s->cpu_slab);
+		c = raw_cpu_ptr(s->cpu_slab);
 	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
 
 	/*
-	 * Irqless object alloc/free alogorithm used here depends on sequence
+	 * Irqless object alloc/free algorithm used here depends on sequence
 	 * of fetching cpu_slab's data. tid should be fetched before anything
 	 * on c to guarantee that object and page associated with previous tid
 	 * won't be used with current tid. If we fetch tid first, object and
@@ -2670,7 +2670,7 @@ redo:
 	 */
 	do {
 		tid = this_cpu_read(s->cpu_slab->tid);
-		c = this_cpu_ptr(s->cpu_slab);
+		c = raw_cpu_ptr(s->cpu_slab);
 	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
 
 	/* Same with comment on barrier() in slab_alloc_node() */
_

