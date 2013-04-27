Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3D0Cm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 22:42:58 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43904 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab3D0Cm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 22:42:57 -0400
Date: Fri, 26 Apr 2013 22:42:48 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>
Cc: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        sonnyrao@chromium.org, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org
Subject: Re: IO regression after ab8fabd46f on x86 kernels with high memory
Message-ID: <20130427024248.GA1229@cmpxchg.org>
References: <517B1153.8000401@valvesoftware.com>
 <517B2FB4.30605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517B2FB4.30605@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 09:53:56PM -0400, Rik van Riel wrote:
> On 04/26/2013 07:44 PM, Pierre-Loup A. Griffais wrote:
> >I initially observed this between kernels 3.2 and 3.5: on 3.2, copying a
> >180M shared object on the same ext4 filesystem takes 0.6s. On 3.5, it
> >takes between two and three minutes. It looks like a similar throughput
> >regression happens on any machine running an i386 PAE kernel with high
> >amounts of memory; the threshold seems to be 16G; passing mem=15G to the
> >kernel commandline fixes it.
> 
> If you have that much memory in the system, you will
> want to run a 64 bit kernel to avoid all kinds of
> memory management corner cases.

Agreed.  You can even keep your 32 bit userland, just swap the
kernel...

> >I bisected it to the following change:
> >
> >commit ab8fabd46f811d5153d8a0cd2fac9a0d41fb593d
> >Author: Johannes Weiner <jweiner@redhat.com>
> >Date:   Tue Jan 10 15:07:42 2012 -0800
> >
> >     mm: exclude reserved pages from dirtyable memory
> >
> >I realize running x86 kernels against high amounts of memory is not
> >advised for various reasons, but I would assume that such a big
> >regression in basic functionality to not be part of them. Is that
> >accurate, or are these configurations expected to become unusable from
> >3.3 onwards?
> 
> Reverting that patch would probably break i686 PAE systems with
> lots of memory at a different threshold.

It would also re-introduce the reclaim stalls when zones with very
little page cache due to lowmem reserves end up with a large
percentage of their LRU dirty.  And that affects modern machines too,
because of the lowmem reserves in DMA32 due to relatively bigger
Normal zones.

On such large highmem machines, however, the imbalance between highmem
and lowmem is so enormous that the lowmem reserves basically exclude
all of lowmem from page cache usage.

But because dirty highmem creates lowmem pressure, and the amount of
sanely allowable dirty memory is actually a function of lowmem, not
highmem, highmem is not included in the amount of dirtyable memory.

So because your lowmem is not available for page cache and highmem is
not considered dirtyable out of the box, the amount of dirtyable
memory on your machine is 0.  You can workaround this by setting
vm.highmem_is_dirtyable=1.
