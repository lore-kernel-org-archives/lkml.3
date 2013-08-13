Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab3HMUbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:31:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076Ab3HMUbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:31:37 -0400
Date: Tue, 13 Aug 2013 13:31:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] mm: make lru_add_drain_all() selective
Message-Id: <20130813133135.3b580af557d1457e4ee8331a@linux-foundation.org>
In-Reply-To: <20130813201958.GA28996@mtj.dyndns.org>
References: <5202CEAA.9040204@linux.vnet.ibm.com>
	<201308072335.r77NZZwl022494@farm-0012.internal.tilera.com>
	<20130812140520.c6a2255d2176a690fadf9ba7@linux-foundation.org>
	<52099187.80301@tilera.com>
	<20130813123512.3d6865d8bf4689c05d44738c@linux-foundation.org>
	<20130813201958.GA28996@mtj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 16:19:58 -0400 Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Tue, Aug 13, 2013 at 12:35:12PM -0700, Andrew Morton wrote:
> > I don't know how lots-of-kmallocs compares with alloc_percpu()
> > performance-wise.
> 
> If this is actually performance sensitive,

I've always assumed that it isn't performance-sensitive. 
schedule_on_each_cpu() has to be slow as a dog.

Then again, why does this patchset exist?  It's a performance
optimisation so presumably someone cares.  But not enough to perform
actual measurements :(

> the logical thing to do
> would be pre-allocating per-cpu buffers instead of depending on
> dynamic allocation.  Do the invocations need to be stackable?

schedule_on_each_cpu() calls should if course happen concurrently, and
there's the question of whether we wish to permit async
schedule_on_each_cpu().  Leaving the calling CPU twiddling thumbs until
everyone has finished is pretty sad if the caller doesn't want that.

> > That being said, the `cpumask_var_t mask' which was added to
> > lru_add_drain_all() is unneeded - it's just a temporary storage which
> > can be eliminated by creating a schedule_on_each_cpu_cond() or whatever
> > which is passed a function pointer of type `bool (*call_needed)(int
> > cpu, void *data)'.
> 
> I'd really like to avoid that.  Decision callbacks tend to get abused
> quite often and it's rather sad to do that because cpumask cannot be
> prepared and passed around.  Can't it just preallocate all necessary
> resources?

I don't recall seeing such abuse.  It's a very common and powerful
tool, and not implementing it because some dummy may abuse it weakens
the API for all non-dummies.  That allocation is simply unneeded.
