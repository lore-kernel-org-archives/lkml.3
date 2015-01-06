Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbbAFDD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:03:28 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:42594 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbbAFDD0 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 5 Jan 2015 22:03:26 -0500
Message-ID: <1420513392.24290.2.camel@stgolabs.net>
Subject: Re: [PATCH 1/2] mm/slub: optimize alloc/free fastpath by removing
 preemption on/off
From: Davidlohr Bueso <dave@stgolabs.net>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 05 Jan 2015 19:03:12 -0800
In-Reply-To: <1420421765-3209-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1420421765-3209-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 10:36 +0900, Joonsoo Kim wrote:
> -	preempt_disable();
> -	c = this_cpu_ptr(s->cpu_slab);
> +	do {
> +		tid = this_cpu_read(s->cpu_slab->tid);
> +		c = this_cpu_ptr(s->cpu_slab);
> +	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
> +	barrier();

I don't see the compiler reodering the object/page stores below, since c
is updated in the loop anyway. Is this really necessary (same goes for
slab_free)? The generated code by gcc 4.8 looks correct without it.
Additionally, the implied barriers for preemption control aren't really
the same semantics used here (if that is actually the reason why you are
using them).

Thanks,
Davidlohr

