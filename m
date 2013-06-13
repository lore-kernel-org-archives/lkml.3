Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3FMTGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:06:18 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:48746 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3FMTGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:06:17 -0400
Date: Thu, 13 Jun 2013 12:06:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613190610.GA13970@mtj.dyndns.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
 <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew, Kent.

On Wed, Jun 12, 2013 at 04:38:54PM -0700, Andrew Morton wrote:
...
> > +unsigned percpu_tag_alloc(struct percpu_tag_pool *pool, gfp_t gfp)
> > +{
> > +	DEFINE_WAIT(wait);
> > +	struct percpu_tag_cpu_freelist *tags;
> > +	unsigned long flags;
> > +	unsigned tag, this_cpu;
> > +
> > +	while (1) {
> > +		local_irq_save(flags);
...
> > +		schedule();
> > +	}
> 
> Does this loop need a try_to_freeze()?

I don't think so.  Kernel tasks should never enter freezer without it
explicitly knowing it.  It should be something evident in the
top-level control flow.  Freezer acts as a giant lock and entering
freezer deep underneath where the task could be holding random number
of resources and locks can easily develop into a deadlock.

If this allocation wait is gonna be visible to userland, what's
necessary probably would be making the sleeping interruptible.  The
freezer will then make the alloc fail and control should return to the
signal delivery path where it'll be frozen without holding any
resources.

Thanks.

-- 
tejun
