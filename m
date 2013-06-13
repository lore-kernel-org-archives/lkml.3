Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3FMTN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:13:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3FMTNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:13:25 -0400
Date: Thu, 13 Jun 2013 12:13:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-Id: <20130613121324.2cab80256217df97254af16c@linux-foundation.org>
In-Reply-To: <20130613190610.GA13970@mtj.dyndns.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
	<20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
	<20130613190610.GA13970@mtj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013 12:06:10 -0700 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew, Kent.
> 
> On Wed, Jun 12, 2013 at 04:38:54PM -0700, Andrew Morton wrote:
> ...
> > > +unsigned percpu_tag_alloc(struct percpu_tag_pool *pool, gfp_t gfp)
> > > +{
> > > +	DEFINE_WAIT(wait);
> > > +	struct percpu_tag_cpu_freelist *tags;
> > > +	unsigned long flags;
> > > +	unsigned tag, this_cpu;
> > > +
> > > +	while (1) {
> > > +		local_irq_save(flags);
> ...
> > > +		schedule();
> > > +	}
> > 
> > Does this loop need a try_to_freeze()?
> 
> I don't think so.  Kernel tasks should never enter freezer without it
> explicitly knowing it.  It should be something evident in the
> top-level control flow.  Freezer acts as a giant lock and entering
> freezer deep underneath where the task could be holding random number
> of resources and locks can easily develop into a deadlock.

As I understand it, if a task is stuck in this loop at freeze time, the
whole freeze attempt will fail.  But it's been a long time since I
thought about or worked on this stuff.

Another issue is device takedown ordering - this thread is blocked
waiting for tags to be returned by IO completion, so there may be
issues where the hardware has been shut down.

I really don't know - I'm flagging it as something which should be
thought about, tested, etc.

> If this allocation wait is gonna be visible to userland, what's
> necessary probably would be making the sleeping interruptible.  The
> freezer will then make the alloc fail and control should return to the
> signal delivery path where it'll be frozen without holding any
> resources.

Maybe.  Interruptible sleeps here will be a bit of a nuisance with
signals.  Poke Rafael ;)

