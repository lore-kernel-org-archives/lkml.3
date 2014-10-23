Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaJWOSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:18:34 -0400
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:47315 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755680AbaJWOSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:18:32 -0400
Date: Thu, 23 Oct 2014 09:18:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com
Subject: Re: [RFC 0/4] [RFC] slub: Fastpath optimization (especially for
 RT)
In-Reply-To: <20141023080942.GA7598@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.11.1410230916090.19494@gentwo.org>
References: <20141022155517.560385718@linux.com> <20141023080942.GA7598@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, Joonsoo Kim wrote:

> Preemption disable during very short code would cause large problem for RT?

This is the hotpath and preempt enable/disable adds a significant number
of cycles.

> And, if page_address() and virt_to_head_page() remain as current patchset
> implementation, this would work worse than before.

Right.

> I looked at the patchset quickly and found another idea to remove
> preemption disable. How about just retrieving s->cpu_slab->tid first,
> before accessing s->cpu_slab, in slab_alloc() and slab_free()?
> Retrieved tid may ensure that we aren't migrated to other CPUs so that
> we can remove code for preemption disable.

You cannot do any of these things because you need the tid from the right
cpu and the scheduler can prempt you and reschedule you on another
processor at will. tid and c may be from different per cpu areas.
