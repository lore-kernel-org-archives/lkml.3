Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbaCSWiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:38:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaCSWix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:38:53 -0400
Date: Wed, 19 Mar 2014 15:38:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [percpu]  BUG: using __this_cpu_add() in preemptible [00000000]
 code: init/1
Message-Id: <20140319153851.34dfdf97616422b159dc153b@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.10.1403180942030.17965@nuc>
References: <20140307090911.GA18207@localhost>
	<alpine.DEB.2.10.1403071124140.21846@nuc>
	<alpine.DEB.2.10.1403180942030.17965@nuc>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 09:43:27 -0500 (CDT) Christoph Lameter <cl@linux.com> wrote:

> Anyways the statistics in slub should be low impact and able to
> be placed anywhere. So I think we need this patch to avoid
> the preemption checks begin triggered.
> 
> 
> Subject: SLUB: Use raw_cpu_inc for incrementing statistics
> 
> Statistics are not critical to the operation of the allocation
> but should also not cause too much overhead.
> 
> __this_cpu_inc now checks if preemption is disabled and triggers.
> Use raw_cpu_inc to avoid the checks. Using this_cpu_ops may cause
> interrupt disable/enable sequences on various arches which may
> significantly impact allocator performance.
> 
> ...
>
> --- linux.orig/mm/slub.c	2014-03-07 14:10:30.142777022 -0600
> +++ linux/mm/slub.c	2014-03-18 09:39:15.675035324 -0500
> @@ -224,7 +224,7 @@
>  static inline void stat(const struct kmem_cache *s, enum stat_item si)
>  {
>  #ifdef CONFIG_SLUB_STATS
> -	__this_cpu_inc(s->cpu_slab->stat[si]);
> +	raw_cpu_inc(s->cpu_slab->stat[si]);
>  #endif
>  }

Please always consider how the code will appear to a naive reader. 
That reader won't know why raw_ is being used here, so we should
provide an explanation.

--- a/mm/slub.c~slub-use-raw_cpu_inc-for-incrementing-statistics-fix
+++ a/mm/slub.c
@@ -224,6 +224,10 @@ static inline void memcg_propagate_slab_
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
 {
 #ifdef CONFIG_SLUB_STATS
+	/*
+	 * The rmw is racy on a preemptible kernel but this is acceptable, so
+	 * avoid this_cpu_add()'s irq-disable overhead.
+	 */
 	raw_cpu_inc(s->cpu_slab->stat[si]);
 #endif
 }
_

