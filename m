Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaCROnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:43:31 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:35927
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957AbaCROna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:43:30 -0400
Date: Tue, 18 Mar 2014 09:43:27 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [percpu]  BUG: using __this_cpu_add() in preemptible [00000000]
 code: init/1
In-Reply-To: <alpine.DEB.2.10.1403071124140.21846@nuc>
Message-ID: <alpine.DEB.2.10.1403180942030.17965@nuc>
References: <20140307090911.GA18207@localhost> <alpine.DEB.2.10.1403071124140.21846@nuc>
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.10.1403071124142.21846@nuc>
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyways the statistics in slub should be low impact and able to
be placed anywhere. So I think we need this patch to avoid
the preemption checks begin triggered.


Subject: SLUB: Use raw_cpu_inc for incrementing statistics

Statistics are not critical to the operation of the allocation
but should also not cause too much overhead.

__this_cpu_inc now checks if preemption is disabled and triggers.
Use raw_cpu_inc to avoid the checks. Using this_cpu_ops may cause
interrupt disable/enable sequences on various arches which may
significantly impact allocator performance.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2014-03-07 14:10:30.142777022 -0600
+++ linux/mm/slub.c	2014-03-18 09:39:15.675035324 -0500
@@ -224,7 +224,7 @@
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
 {
 #ifdef CONFIG_SLUB_STATS
-	__this_cpu_inc(s->cpu_slab->stat[si]);
+	raw_cpu_inc(s->cpu_slab->stat[si]);
 #endif
 }

