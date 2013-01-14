Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab3ANRSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:18:31 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:53186 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab3ANRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:18:29 -0500
Date: Mon, 14 Jan 2013 09:18:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Josh Triplett <josh@joshtriplett.org>,
        Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH] module, fix percpu reserved memory exhaustion
Message-ID: <20130114171822.GC27942@mtj.dyndns.org>
References: <1357785669-31848-1-git-send-email-prarit@redhat.com>
 <87d2xc1itd.fsf@rustcorp.com.au>
 <50F01EC2.1000908@redhat.com>
 <87pq1byzum.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq1byzum.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

On Sat, Jan 12, 2013 at 11:36:09AM +1030, Rusty Russell wrote:
> > I've been thinking about that.  The problem is that at the same time the kvm
> > problem occurs I'm attempting to load a debug module that I've written to debug
> > some cpu timer issues that allocates a large amount of percpu data (~.5K/cpu).
> > While extending PERCPU_MODULE_RESERVE to 10k might work now, it might not work
> > tomorrow if I have the need to increase the size of my log buffer.
> 
> Well, it looks like PERCPU_MODULE_RESERVE is actually very generous; it
> could easily be halved.  I guess this is because dynamic per-cpu data is
> now such a nice alternative (thanks to Tejun).

Heh, thanks. :)

There are two percpu constants that I basically pulled out of my ass.

* PERCPU_MODULE_RESERVE: It's used on architectures with data model
  which restricts the distance between code and data.  e.g. x86_64
  genereates code which can't address full 64bit for static data and
  as percpu addressing depends on the regular address generation to
  derive percpu addresses, the percpu offsets need to be restricted
  somehow.  Percpu allocator currently achieves this by reserving
  certain amount in the first percpu chunk which is guaranteed to have
  very low (starting from 0) percpu address space offsets.

  On those archs, this becomes the hard limit for all module static
  percpu areas.  Maybe 8k is way too high and we can go with 4k.
  Worth a try I guess.

* PERCPU_DYNAMIC_RESERVE: The amount of space at the end of the first
  chunk used for dynamic allocation.  This isn't as critical as the
  above and the only reason it exists is because the first chunk is
  often embedded in the kernel linear address space instead of vmalloc
  area and the former is often mapped with larger page table size than
  the latter.  The goal of PERCPU_DYNAMIC_RESERVE is to have just
  enough space to cover the usual percpu allocations without wasting
  too much space to minimize impact on TLB pressure.

  The current number isn't entirely made up.  I did some testing with
  some random config.  Don't know how it holds up now.  It probably
  can be increased given that we developed quite a few percpu dynamic
  allocations since then.

  It would be awesome to have a way to somehow dynamically adjust this
  one; unfortunately, that would require persistent data across
  boots. :(

Thanks.

-- 
tejun
