Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3IRIIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:08:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:49916 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab3IRIId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:08:33 -0400
Message-ID: <1379491693.6148.25.camel@pasglop>
Subject: Re: "memory" binding issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        m.szyprowski@samsung.com, swarren@nvidia.com, rob.herring@calxeda.com
Date: Wed, 18 Sep 2013 18:08:13 +1000
In-Reply-To: <20130918013823.D617CC42C81@trevor.secretlab.ca>
References: <1379300274.4098.77.camel@pasglop>
	 <52372F2A.2050003@wwwdotorg.org> <1379371567.3721.46.camel@pasglop>
	 <20130918013823.D617CC42C81@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-17 at 18:38 -0700, Grant Likely wrote:
> On Tue, 17 Sep 2013 08:46:07 +1000, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > In anycase, just "/memory" will break on at least powerpc.
> 
> Ummm, really?

I meant the search for just '/memory' will break with the current path
searching algorithm on all powerpc machines that have the unit address.
We might have been also omitting it from some of our device-trees but
most of our real OF based machines will break and the stuff I'm
currently working on that does exploit the reserved stuff will.

Anything that supports multiple memory nodes will break for example.

It's a separate argument as to whether omitting the unit address is the
right thing to do in the dts. I don't like it but it's indeed a common
practice so we shouldn't make it not work anymore. However we shouldn't
*document* the memory node binding as having no unit address.

But as we have agreed, fixing the path searching  would go a long way
toward fixing the issue kernel-side while retaining the compatibility
with both type of device-trees.

Now regarding the specific issue of reserved memory, I still maintain
that this shouldn't be a child of the memory nodes since that's simply
not practical the minute you have multiple memory nodes.

I also think we are mixing up two very different concepts here and we
might be better off just handling them separately:

 - Marking areas of memory as reserved via the device-tree in order to
prevent SW (Linux, bootloader, ...) from stomping over them because they
are in use typically by some kind of driver or contain other information
that should be preserved. This is basically a better form of the
existing reserve map. The two main feature we are after here as far as
I'm concerned are
    
       1) be explicit in the device-tree instead of the header
          which means they are visible in /proc/device-tree,
          can potentially survive kexec, etc....

       2) be "named" (using vendor,function) so that the user can
          have a rough idea of what this is about *and* the driver
          can take ownership of them if needed. For example, if the
          firmware has configured an in-memory framebuffer, it can
          be reserved that way. Later, when the Linux DRM driver
          loads, it might decide to move that region around and can
          thus find and update or remove that property so it remains
          consistent for kexec.

Both of these are covered by the original binding I proposed (and
implemented on powerpc) of having a /reserved-ranges and /reserved-names
in the device-tree. But I'm not married to that binding and if the
general consensus is that we should make them nodes, then so be it,
but I disagree with having them as children of the /memory node.

 - "Segmenting" the physical memory into regions for use either by CMA
or by devices to indicate, possibly, the preferred areas for use by
those drivers. Fundamentally that memory is perfectly good to use by
Linux, and in fact this is arguably not HW description (though it's
acceptable as a "hint" to the operating system of what a good memory
usage would be for the platform).

Whether it makes sense to collate both into the same representation,
I am very unsure of.

Cheers,
Ben.

> ~/hacking/linux$ git grep 'memory {' arch/powerpc/boot/dts/* | wc -l
> 159
> ~/hacking/linux$ git grep 'memory@' arch/powerpc/boot/dts/* | wc -l
> 4
> 
> g.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


