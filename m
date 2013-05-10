Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3EJVPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:15:43 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34276 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab3EJVPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:15:42 -0400
Date: Fri, 10 May 2013 14:15:38 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-s390@vger.kernel.org, bcrl@kvack.org, schwidefsky@de.ibm.com,
        kirill.shutemov@linux.intel.com, zab@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v3 next/akpm] aio: convert the ioctx list to radix tree
Message-ID: <20130510211538.GD7801@google.com>
References: <1366026055-28604-1-git-send-email-octavian.purdila@intel.com>
 <20130510134015.ac8ad56305c539fa9bd8b5a7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510134015.ac8ad56305c539fa9bd8b5a7@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 01:40:15PM -0700, Andrew Morton wrote:
> On Mon, 15 Apr 2013 14:40:55 +0300 Octavian Purdila <octavian.purdila@intel.com> wrote:
> 
> > When using a large number of threads performing AIO operations the
> > IOCTX list may get a significant number of entries which will cause
> > significant overhead. For example, when running this fio script:
> > 
> > rw=randrw; size=256k ;directory=/mnt/fio; ioengine=libaio; iodepth=1
> > blocksize=1024; numjobs=512; thread; loops=100
> > 
> > on an EXT2 filesystem mounted on top of a ramdisk we can observe up to
> > 30% CPU time spent by lookup_ioctx:
> > 
> >  32.51%  [guest.kernel]  [g] lookup_ioctx
> >   9.19%  [guest.kernel]  [g] __lock_acquire.isra.28
> >   4.40%  [guest.kernel]  [g] lock_release
> >   4.19%  [guest.kernel]  [g] sched_clock_local
> >   3.86%  [guest.kernel]  [g] local_clock
> >   3.68%  [guest.kernel]  [g] native_sched_clock
> >   3.08%  [guest.kernel]  [g] sched_clock_cpu
> >   2.64%  [guest.kernel]  [g] lock_release_holdtime.part.11
> >   2.60%  [guest.kernel]  [g] memcpy
> >   2.33%  [guest.kernel]  [g] lock_acquired
> >   2.25%  [guest.kernel]  [g] lock_acquire
> >   1.84%  [guest.kernel]  [g] do_io_submit
> > 
> > This patchs converts the ioctx list to a radix tree.
> 
> The patch looks nice.  One thing we should pay attention to is the
> memory consumption.  radix-trees can be far less space-efficient than
> lists, and as the tree key comes from mmap() it can be pretty sparsely
> distributed.
> 
> So could you please have a think about this, see if we can cook up some
> worst-case numbers and decide if they are problematic?

Because the overhead of an ioctx is so high (ringbuffer is some number
of pages) it shouldn't matter much - but I wouldn't mind seeing a bit of
arithmatic.
