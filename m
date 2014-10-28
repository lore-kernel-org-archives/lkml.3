Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaJ1U0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:26:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaJ1U0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:26:17 -0400
Date: Tue, 28 Oct 2014 13:26:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 dma-mapping tree
Message-Id: <20141028132617.12dc0fb45f33103fe9f6b04b@linux-foundation.org>
In-Reply-To: <544F3D91.1070604@samsung.com>
References: <20141028152444.79bd9fe9@canb.auug.org.au>
	<20141027232910.952850f8.akpm@linux-foundation.org>
	<544F3D91.1070604@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 07:54:09 +0100 Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> Hello,
> 
> On 2014-10-28 07:29, Andrew Morton wrote:
> > On Tue, 28 Oct 2014 15:24:44 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> >> Today's linux-next merge of the akpm-current tree got a conflict in
> >> mm/cma.c between commit 16195ddd4ebc ("mm: cma: Ensure that
> >> reservations never cross the low/high mem boundary") from the
> >> dma-mapping tree and commit 2a70e5a78672 ("mm/cma: ake kmemleak ignore
> >> CMA regions") from the akpm-current tree.
> > hm, we have multiple trees altering mm/cma.c?
> >
> > I'm a bit surprised that this series was merged, given that Laurent
> > said he would be sending out a v2...
> 
> v2 of Laurent's patches has been posted on 24th October
> (https://lkml.org/lkml/2014/10/24/207 ), but since I didn't notice them 
> to be taken
> I thought that it would make sense to get them via my tree and send them 
> to Linus
> during the 3.18-rc cycle. If this was not appropriate, I will drop my tree.

I think I got it all sorted out.  Thierry's "mm/cma: make kmemleak
ignore CMA regions" needed a bit of rework - please check.


From: Thierry Reding <treding@nvidia.com>
Subject: mm/cma: make kmemleak ignore CMA regions

kmemleak will add allocations as objects to a pool.  The memory allocated
for each object in this pool is periodically searched for pointers to
other allocated objects.  This only works for memory that is mapped into
the kernel's virtual address space, which happens not to be the case for
most CMA regions.  

Furthermore, CMA regions are typically used to store data transferred to
or from a device and therefore don't contain pointers to other objects.

Without this, the kernel crashes on the first execution of the
scan_gray_list() because it tries to access highmem.  Perhaps a more
appropriate fix would be to reject any object that can't map to a kernel
virtual address?

[akpm@linux-foundation.org: add comment]
[akpm@linux-foundation.org: fix comment, per Catalin]
[sfr@canb.auug.org.au: include linux/io.h for phys_to_virt()]
Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions mm/cma.c
--- a/mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions
+++ a/mm/cma.c
@@ -33,6 +33,7 @@
 #include <linux/log2.h>
 #include <linux/cma.h>
 #include <linux/highmem.h>
+#include <linux/io.h>
 
 struct cma {
 	unsigned long	base_pfn;
@@ -301,6 +302,11 @@ int __init cma_declare_contiguous(phys_a
 			}
 		}
 
+		/*
+		 * kmemleak scans/reads tracked objects for pointers to other
+		 * objects but this address isn't mapped and accessible
+		 */
+		kmemleak_ignore(phys_to_virt(addr));
 		base = addr;
 	}
 
_

