Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbaAIANS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 19:13:18 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63272 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbaAIANQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 19:13:16 -0500
X-AuditID: 9c93017d-b7be2ae0000020a5-06-52cde9984f8c
Date: Thu, 9 Jan 2014 09:13:31 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, Helge Deller <deller@gmx.de>,
        Mikulas Patocka <mpatocka@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH] fix crash when using XFS on loopback
Message-ID: <20140109001331.GA15738@lge.com>
References: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com>
 <20140106073549.GA25771@lge.com>
 <alpine.LRH.2.02.1401061237120.6190@file01.intranet.prod.int.rdu2.redhat.com>
 <20140107014159.GA26726@lge.com>
 <52CDBD94.9090808@gmx.de>
 <CAOJsxLGJbRrDOesdSFnYCt9GOyTGEF0TDWNux06C3OxJnuLFMg@mail.gmail.com>
 <20140108135930.9fc1d3a63eeb9a45dcbbb2e8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108135930.9fc1d3a63eeb9a45dcbbb2e8@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 01:59:30PM -0800, Andrew Morton wrote:
> On Wed, 8 Jan 2014 23:37:49 +0200 Pekka Enberg <penberg@kernel.org> wrote:
> 
> > The patch looks good to me but it probably should go through Andrew's tree.
> 
> yup.
> 
> page_mapping() will be called quite frequently, and adding a new
> test-n-branch in there will be somewhat costly.  We might end up with a
> better kernel if we were to instead revert 8456a648cf44f.  How useful
> was that patch?

Hello,

Performance effect of this patch was decribed in the cover-letter, but
I missed to attach it to patch description. Sorry about that.

In summary, this patch saves some memory and decreases cache-footprint
so that it increases performance.

Here goes the description in cover-letter.

Below is some numbers of 'cat /proc/slabinfo'.

* Before *
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables [snip...]
kmalloc-512          527    600    512    8    1 : tunables   54   27    0 : slabdata     75     75      0
kmalloc-256          210    210    256   15    1 : tunables  120   60    0 : slabdata     14     14      0
kmalloc-192         1040   1040    192   20    1 : tunables  120   60    0 : slabdata     52     52      0
kmalloc-96           750    750    128   30    1 : tunables  120   60    0 : slabdata     25     25      0
kmalloc-64          2773   2773     64   59    1 : tunables  120   60    0 : slabdata     47     47      0
kmalloc-128          660    690    128   30    1 : tunables  120   60    0 : slabdata     23     23      0
kmalloc-32         11200  11200     32  112    1 : tunables  120   60    0 : slabdata    100    100      0
kmem_cache           197    200    192   20    1 : tunables  120   60    0 : slabdata     10     10      0

* After *
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables [snip...]
kmalloc-512          525    640    512    8    1 : tunables   54   27    0 : slabdata     80     80      0
kmalloc-256          210    210    256   15    1 : tunables  120   60    0 : slabdata     14     14      0
kmalloc-192         1016   1040    192   20    1 : tunables  120   60    0 : slabdata     52     52      0
kmalloc-96           560    620    128   31    1 : tunables  120   60    0 : slabdata     20     20      0
kmalloc-64          2148   2280     64   60    1 : tunables  120   60    0 : slabdata     38     38      0
kmalloc-128          647    682    128   31    1 : tunables  120   60    0 : slabdata     22     22      0
kmalloc-32         11360  11413     32  113    1 : tunables  120   60    0 : slabdata    101    101      0
kmem_cache           197    200    192   20    1 : tunables  120   60    0 : slabdata     10     10      0

kmem_caches consisting of objects less than or equal to 128 byte have one more
objects in a slab. You can see it at objperslab.


Here are the performance results on my 4 cpus machine.

* Before *

 Performance counter stats for 'perf bench sched messaging -g 50 -l 1000' (10 runs):

       238,309,671 cache-misses                                                  ( +-  0.40% )

      12.010172090 seconds time elapsed                                          ( +-  0.21% )

* After *

 Performance counter stats for 'perf bench sched messaging -g 50 -l 1000' (10 runs):

       229,945,138 cache-misses                                                  ( +-  0.23% )

      11.627897174 seconds time elapsed                                          ( +-  0.14% )

cache-misses are reduced by this patchset, roughly 5%.
And elapsed times are also improved by 3.1% to baseline.

Thanks.
