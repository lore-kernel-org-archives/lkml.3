Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3IRGOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:14:05 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:55240 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3IRGNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:13:36 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: "memory" binding issues
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree@vger.kernel.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, m.szyprowski@samsung.com,
        swarren@nvidia.com, rob.herring@calxeda.com
In-Reply-To: <1379300274.4098.77.camel@pasglop>
References: <1379300274.4098.77.camel@pasglop>
Date: Tue, 17 Sep 2013 21:57:14 -0500
Message-Id: <20130918025714.A69D8C42C8F@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013 12:57:54 +1000, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> [resent to the right list this time around]
> 
> Hi folks !
> 
> So I don't have the bandwidth to follow closely what's going on, but I
> just today noticed the crackpot that went into 3.11 as part of commit:
> 
> 9d8eab7af79cb4ce2de5de39f82c455b1f796963
> drivers: of: add initialization code for dma reserved memory
> 
> Fist of all, do NOT add (or change) a binding as part of a patch
> implementing code, it's gross.

I really don't have any problem with a single patch including both. In
many cases it is easier to review when they are in the same patch...
That said, there is a plan to move the bindings out into a separate
repository which will make the issue moot in the near future.

> Secondly, I don't know how much that binding was discussed on the list
> (I assume it was and I just missed it) but it's gross.
> 
> It duplicates a binding that Jeremy Kerr had proposed a while ago for
> a /reserved-ranges (and /reserved-names) pair of properties, possibly in
> a better way but the fact is that the original binding received little
> or no feedback and we went on and implemented support for it in powerpc
> back in early 3.11 merge window.

reserved-ranges seemed too be too limited. Specifically there is a need
to have devices bind to specific regions. Consider for example a device
with two video devices with initialized framebuffers. The intent was to
reference a specific region from the device. A phandle is a natural way
to do that, and it allows for later additional attributes or
descriptions to be added to reserved region nodes.

BTW, at the risk of sounding petty, I noticed that the
early_reserve_mem_dt() implementation was made powerpc-only despite none
of it being powerpc specific. That really should have been put into
common code. :-p

> Additionally, it has the following issues:
> 
>  - It describes the "memory" node as /memory, which is WRONG
> 
> It should be "/memory@unit-address, this is important because the Linux
> kernel of_find_device_by_path() isn't smart enough to do partial
> searches (unlike the real OFW one) and thus to ignore the unit address
> for search purposes, and you *need* the unit address if you have
> multiple memory nodes (which you typically do on NUMA machines).

As discussed elsewhere in this thread, there is precidence for both
/memory and /memory@unit-address. Both need to work.

>  - To add to the above mistake, it defines "reserved memory" as a child
> node of the "/memory" node. That is wrong or at least poorly thought
> out. There can be several "memory" nodes, representing different areas
> of memory, possibly even interleaved, having the reserved ranges as
> children of a specific memory nodes thus doesn't work very well.
> Breaking them up into regions based on what memory nodes they cover is
> really nasty. Basically, the "reserved-memory" node should have been at
> the root of the device-tree.

I would be okay with that. We went back and forth on the best place for
it to live a number of times. The thought when placing it under the
memory node was that a region is (probably) going to be associated with
a particular bank of memory. Therefore it makes sense to be a child of
that bank of memory. If you feel strongly on this one then I have no
problem moving it to the root of the tree.

>  - It provides no indication of what a given region is used for (or used
> by). In the example, "display_region" is a label (thus information that
> is lost) and unless it's referenced by another node there is no good way
> to know what this region is about which is quite annoying.

Does this actually matter? In most cases the regions are completely
anonymous until referenced by a specific device and by default the
kernel should not use until it knows what the region is for.

We can however add properties to give the kernel hints on the usage. For
instance, if a regions isn't in use at boot time, then it would be fine
for the kernel to use it for movable pages up until the time a device
asks for the region (ie. CMA regions can be used this way).

>  - The "memory-region" property is a phandle to a "reserved-memory"
> region, this is not intuitive. If anything, the property should have
> been called "reserved-memory-region".

Sure. I don't see the problem, but I have no problem changing it if you
feel strongly about it.

>  - The way the "compatible" property is documented breaks a basic
> premise that the device-tree is a hardware description and not some
> convenient way to pass linux specific kernel parameters accross. It is
> *ok* to pass some linux specific stuff and to make compromise based on
> what a driver generally might expect but the whole business of using
> that to describe what to put in CMA is pushing it pretty far ...

I disagree. Originally I had the same reaction, but I've been swayed to
the point of view that setting aside regions is actually a pretty
hardware-centric thing because it describes how the hardware needs to be
used. I've already used the example of a framebuffer. It may not stricly
be hardware, but it is a description of how the hardware is setup that
the kernel should respect. Similarly, the size and placement of CMA
regions are more than merely a software parameter because they are
defined specifically to support the hardware devices.

>  - The implementation of early_init_dt_scan_reserved_mem() will not work
> on a setup whose /memory node has a unit address (typically /memory@0)

Agreed, that should be fixed. It should work regardless of whether or
not the memory node(s) have a unit address.

> Now, I'd like to understand why not use the simpler binding originally
> proposed by Jeremy, which had the advantage of proposing a unique name
> per region in the traditional form "vendor,name", which then allows
> drivers to pick up the region directly if they wish to query, remove or
> update it in the tree for example (because they changed the framebuffer
> address for example and want kexec to continue working).

Hmmm... I don't follow. How is query/remove/update any more or less
difficult between the two approaches? Updating the reg property should
be doable in-place with both methods, but finding a specific region
associated with a device is explicit in the nodes-and-phandles approach.
(unless the 'name' part of vendor,name is an instance name and the
device node has a property containing the name; ie "acme,framebuffer1",
"acme,framebuffer2", and then in the device node something like:
framebuffer-region = "acme,framebuffer2";)

> I don't object to having a node per region, though it seemed unnecessary
> at the time, but in any case, the current binding is crap and need to be
> fixed urgently before its use spreads.

It seems to me that the 'top-level' objection is the creation of a new
binding using a node per region. I think it is warrented. If you
disagree strongly then we'll revert the whole series and try again for
v3.13. Otherwise I think the other objections are fixable in this cycle.

g.
